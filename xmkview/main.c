#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <doslib.h>
#include <iocslib.h>
#include "himem.h"
#include "crtc.h"
#include "keyboard.h"

#define VERSION "2023.06.24"

// scene class
typedef struct {
  int32_t start_frame_index;
  int32_t end_frame_index;
} SCENE;

static SCENE scenes[ 1024 ];

// to preserve original function keys
static uint8_t funckey_original_settings[ 712 ];

// to preserve original function mode
static int32_t funckey_original_mode;

// show help message
static void show_help_message() {
  printf("usage: xmkview [options] <output-txt>\n");
  printf("options:\n");
  printf("     -h ... show help message\n");
}

static inline void wait_vsync() {
  while(!(B_BPEEK((uint8_t*)0xe88001) & 0x10));
  while( (B_BPEEK((uint8_t*)0xe88001) & 0x10));
}

// main loop
int32_t main(int32_t argc, char* argv[]) {

  // default return code
  int32_t rc = -1;

  // default mode
  int16_t screen_mode = -1;

  // output file
  uint8_t* output_file_name = NULL;

  // input tx file handle
  FILE* fx = NULL;

  // input tp file handle
  FILE* fp = NULL;

  // tx read buffer
  uint8_t* tx_read_buffer = NULL;

  // tp read buffer
  uint16_t* tp_read_buffer = NULL;  

  // frame buffer
  uint16_t* frame_buffer = NULL;

  // thumbnail buffer
  uint16_t* thumbnail_buffer = NULL;

  // use high memory?
  int16_t use_high_memory = himem_isavailable() ? 1 : 0;

  // preserve original funckey settings
  FNCKEYGT(0, funckey_original_settings);

  // preserve original funckey mode
  funckey_original_mode = C_FNKMOD(-1);

  // parse command lines
  for (int16_t i = 1; i < argc; i++) {
    if (argv[i][0] == '-' && strlen(argv[i]) >= 2) {
      if (argv[i][1] == 'h') {
        show_help_message();
        goto exit;
      } else {
        printf("error: unknown option (%s).\n",argv[i]);
        goto exit;
      }
    } else {
      output_file_name = argv[i];
    }
  }

  if (output_file_name == NULL) {
    show_help_message();
    goto exit;
  }

  tx_read_buffer = himem_malloc(384 * 256 * 1, 0);
  if (tx_read_buffer == NULL) {
    printf("error: memory allocation error.\n");
    goto exit;
  }

  tp_read_buffer = himem_malloc(512 * 2, 0);
  if (tp_read_buffer == NULL) {
    printf("error: memory allocation error.\n");
    goto exit;
  }

  frame_buffer = himem_malloc(384 * 256 * 2, use_high_memory);
  if (frame_buffer == NULL) {
    printf("error: memory allocation error.\n");
    goto exit;
  }
  memset(frame_buffer, 0, 384 * 256 * 2);

  thumbnail_buffer = himem_malloc(500 * 64 * 2, use_high_memory);
  if (frame_buffer == NULL) {
    printf("error: memory allocation error.\n");
    goto exit;
  }
  memset(thumbnail_buffer, 0, 500 * 64 * 2);

  // screen mode
  CRTMOD(12);
  G_CLR_ON();
  C_CUROFF();
  C_FNKMOD(3);
  B_CONSOL((64-15)*8, 4*16, 14, 16);

  // customize function keys
  uint8_t funckey_settings[ 712 ];
  memset(funckey_settings, 0, 712);
  funckey_settings[ 20 * 32 + 6 * 0 ] = '\x05';   // ROLLUP
  funckey_settings[ 20 * 32 + 6 * 1 ] = '\x15';   // ROLLDOWN
  funckey_settings[ 20 * 32 + 6 * 3 ] = '\x07';   // DEL
  funckey_settings[ 20 * 32 + 6 * 4 ] = '\x01';   // UP
  funckey_settings[ 20 * 32 + 6 * 5 ] = '\x13';   // LEFT
  funckey_settings[ 20 * 32 + 6 * 6 ] = '\x04';   // RIGHT
  funckey_settings[ 20 * 32 + 6 * 7 ] = '\x06';   // DOWN
  FNCKEYST(0, funckey_settings);

  SCENE current_scene = { -1, -1 };
  int16_t num_scenes = 0;

  int32_t current_frame_index = 10000;
  int32_t prev_frame_index = -1;

  uint8_t mes[ 256 ];

  B_PUTMES(6, 0,  0, 64, "XMKVIEW - MACS TX VIEWER version " VERSION);
  B_PUTMES(1, 0, 29, 64, "[ESC]:EXIT [RIGHT/LEFT]:MOVE FRAME [SP/B]:JUMP FRAME");
  B_PUTMES(1, 0, 30, 64, "[SHIFT+S]:SAVE [M/S]:MARK START [E]:MARK END [CR]:ADD SCENE");

  for (;;) {

    if (B_KEYSNS() != 0) {

      int16_t scan_code = B_KEYINP() >> 8;
      int16_t shift_sense = B_SFTSNS();

      if (shift_sense & 0x01) {
        scan_code += 0x100;
      }
      if (shift_sense & 0x02) {
        scan_code += 0x200;
      }

      if (scan_code == KEY_SCAN_CODE_ESC || scan_code == KEY_SCAN_CODE_Q) {

        break;

      } else if (scan_code == KEY_SCAN_CODE_LEFT) {

        if (current_frame_index > 0) current_frame_index--;

      } else if (scan_code == KEY_SCAN_CODE_RIGHT) {

        current_frame_index++;

      } else if (scan_code == KEY_SCAN_CODE_B) {

        if (current_frame_index > 20) current_frame_index -= 20;

      } else if (scan_code == KEY_SCAN_CODE_SPACE) {

        current_frame_index += 20;

      } else if (scan_code == KEY_SCAN_CODE_M || scan_code == KEY_SCAN_CODE_S) {

        if (current_scene.start_frame_index == current_frame_index) {

          current_scene.start_frame_index = -1;
          B_PUTMES(3, 0, 25, 20, "");

        } else {

          current_scene.start_frame_index = current_frame_index;
          sprintf(mes, "SCENE START = %d", current_scene.start_frame_index);
          B_PUTMES(3, 0, 25, 20, mes);

        }

      } else if (scan_code == KEY_SCAN_CODE_E) {

        if (current_scene.end_frame_index == current_frame_index) {

          current_scene.end_frame_index = -1;
          B_PUTMES(3, 0, 26, 20, "");

        } else {

          current_scene.end_frame_index = current_frame_index;
          sprintf(mes, "SCENE END   = %d", current_scene.end_frame_index);
          B_PUTMES(3, 0, 26, 20, mes);

        }

      } else if (scan_code == KEY_SCAN_CODE_CR || scan_code == KEY_SCAN_CODE_ENTER) {

        if (current_scene.start_frame_index >= 0 && current_scene.end_frame_index > current_scene.start_frame_index) {
          memcpy((uint8_t*)(&scenes[ num_scenes ]), (uint8_t*)(&current_scene), sizeof(SCENE));
          sprintf(mes, "SC %05d:%05d\r\n", scenes[ num_scenes ].start_frame_index, scenes[ num_scenes ].end_frame_index);
          B_PRINT(mes);
          num_scenes++;
          current_scene.start_frame_index = -1;
          current_scene.end_frame_index = -1;
          B_PUTMES(3, 0, 25, 20, "");
          B_PUTMES(3, 0, 26, 20, "");
        }

      } else if (scan_code == KEY_SCAN_CODE_SHIFT_S) {

        if (num_scenes > 0) {
          FILE* fo = fopen(output_file_name, "w");
          for (int16_t i = 0; i < num_scenes; i++) {
            fprintf(fo, "fix_palette %d %d\n", scenes[i].start_frame_index - 10000, scenes[i].end_frame_index - 10000);
          }
          fclose(fo);
          B_PUTMES(3, 0, 27, 20, "SAVED.");
          for (uint32_t t0 = ONTIME(); t0 + 50 > ONTIME();) {}
          B_PUTMES(3, 0, 27, 20, "");
        }


      }
 
    }

    if (current_frame_index != prev_frame_index) {

      uint8_t tx_file_name[ 256 ];
      uint8_t tp_file_name[ 256 ];

      int16_t image_group = (current_frame_index - 10000) / 500;

      sprintf(tx_file_name, "im%02d\\Tx%05d", image_group, current_frame_index);
      sprintf(tp_file_name, "im%02d\\Tp%05d", image_group, current_frame_index);

      sprintf(mes, "FRAME NO. = %05d", current_frame_index);

      fx = fopen(tx_file_name, "rb");
      fp = fopen(tp_file_name, "rb");

      if (fx == NULL || fp == NULL) {

        current_frame_index = prev_frame_index;

      } else {

        if (screen_mode != 2 && screen_mode != 3) {
          
          fseek(fx, 0, SEEK_END);
          size_t tx_size = ftell(fx);
          fseek(fx, 0, SEEK_SET);
          screen_mode = (tx_size > 256 * 256 * 1) ? 3 : 2;

          wait_vsync();

          struct FILLPTR fillptr = { 6 + 200 - 4, 316 + 64 + 2, 6 + 200 + (screen_mode == 3 ? 96 : 64) + 3, 316 + 64 + 3, 0b0011100111001110};
          FILL(&fillptr);

        }

        fread(tx_read_buffer, 1, screen_mode == 3 ? 384 * 256 : 256 * 256, fx);
        fread(tp_read_buffer, 2, 256, fp);

        if (screen_mode == 3) {

          for (int16_t y = 0; y < 256; y++) {
            for (int16_t x = 0; x < 384; x++) {
              frame_buffer[ y * 384 + x ] = tp_read_buffer[ tx_read_buffer[ y * 384 + x ]];
            }
          }

          struct PUTPTR putptr = { 0, 48, 383, 48+255, (uint8_t*)frame_buffer, (uint8_t*)&(frame_buffer[ 384 * 256 ]) - 1 };
          
          wait_vsync();
          PUTGRM(&putptr);

          B_PUTMES(1, 0, 2, 18, mes);

        } else {

          for (int16_t y = 0; y < 256; y++) {
            for (int16_t x = 0; x < 256; x++) {
              frame_buffer[ y * 256 + x ] = tp_read_buffer[ tx_read_buffer[ y * 256 + x ]];
            }
          }

          struct PUTPTR putptr = {16, 48, 16+255, 48+255, (uint8_t*)frame_buffer, (uint8_t*)&(frame_buffer[ 256 * 256 ]) - 1 };
          
          wait_vsync();
          PUTGRM(&putptr);

          B_PUTMES(1, 0, 2, 18, mes);

        }

        prev_frame_index = current_frame_index;

      }

      if (fx != NULL) {
        fclose(fx);
        fx = NULL;
      }

      if (fp != NULL) {
        fclose(fp);
        fp = NULL;
      }

      for (int16_t i = -2; i <= 2; i++) {

        int32_t ti = current_frame_index + i;
        int16_t im = (ti - 10000) / 500;

        sprintf(tx_file_name, "im%02d\\Tx%05d", im, ti);
        sprintf(tp_file_name, "im%02d\\Tp%05d", im, ti);

        fx = fopen(tx_file_name, "rb");
        fp = fopen(tp_file_name, "rb");

        if (fx != NULL && fp != NULL) {

          fread(tx_read_buffer, 1, screen_mode == 3 ? 384 * 256 : 256 * 256, fx);
          fread(tp_read_buffer, 2, 256, fp);

          if (screen_mode == 3) {

            for (int16_t y = 0; y < 64; y++) {
              for (int16_t x = 0; x < 96; x++) {
                thumbnail_buffer[ y * 500 + (i + 2) * 100 + x ] = tp_read_buffer[ tx_read_buffer[ y * 4 * 384 + x * 4 ]];
              }
            }

          } else {

            for (int16_t y = 0; y < 64; y++) {
              for (int16_t x = 0; x < 64; x++) {
                thumbnail_buffer[ y * 500 + (i + 2) * 100 + x ] = tp_read_buffer[ tx_read_buffer[ y * 4 * 256 + x * 4 ]];
              }
            }
          }

        } else {

          for (int16_t y = 0; y < 64; y++) {
            memset((uint8_t*)(&thumbnail_buffer[ y * 500 + (i + 2) * 100 ]), 0, 96 * 2);
          }

        }

        if (fx != NULL) {
          fclose(fx);
          fx = NULL;
        }

        if (fp != NULL) {
          fclose(fp);
          fp = NULL;
        }

      }

      wait_vsync();

      struct PUTPTR putptr = { 6, 316, 6 + 500 - 1, 316 + 64 - 1, (uint8_t*)thumbnail_buffer, (uint8_t*)&(thumbnail_buffer[ 512 * 64 ]) - 1 };            
      PUTGRM(&putptr);

//      struct BOXPTR boxptr = { 6 + 200 - 4, 300 - 4, 6 + 200 + (screen_mode == 3 ? 96 : 64) + 3, 300 + 64 + 3, 0b0011100111001110, 0xffff };
//      BOX(&boxptr);

    }

  }

catch:

  if (fx != NULL) {
    fclose(fx);
    fx = NULL;
  }

  if (fp != NULL) {
    fclose(fp);
    fp = NULL;
  }

  if (tx_read_buffer != NULL) {
    himem_free(tx_read_buffer, 0);
    tx_read_buffer = NULL;
  }

  if (tp_read_buffer != NULL) {
    himem_free(tp_read_buffer, 0);
    tp_read_buffer = NULL;
  }

  if (frame_buffer != NULL) {
    himem_free(frame_buffer, use_high_memory);
    frame_buffer = NULL;
  }

  if (thumbnail_buffer != NULL) {
    himem_free(thumbnail_buffer, use_high_memory);
    thumbnail_buffer = NULL;
  }

  // resume screen
  CRTMOD(16);
  G_CLR_ON();
  C_CURON();

  // resume function key settings
  FNCKEYST(0, funckey_original_settings);

  // resume function key mode
  C_FNKMOD(funckey_original_mode);

exit:

  return rc;
}