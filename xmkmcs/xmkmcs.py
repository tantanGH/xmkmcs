import argparse
import sys
import os
import glob
import shutil

from PIL import Image

#
#  pcm to adpcm converter class
#
class ADPCM:

  step_adjust = [ -1, -1, -1, -1, 2, 4, 6, 8, -1, -1, -1, -1, 2, 4, 6, 8 ]

  step_size = [  16,  17,  19,  21,  23,  25,  28,  31,  34,  37,  41,  45,   50,   55,   60,   66,
                 73,  80,  88,  97, 107, 118, 130, 143, 157, 173, 190, 209,  230,  253,  279,  307,
                337, 371, 408, 449, 494, 544, 598, 658, 724, 796, 876, 963, 1060, 1166, 1282, 1411, 1552 ]


  def decode_adpcm(self, code, step_index, last_data):

    ss = ADPCM.step_size[ step_index ]

    delta = ( ss >> 3 )

    if code & 0x01:
      delta += ( ss >> 2 )

    if code & 0x02:
      delta += ( ss >> 1 )

    if code & 0x04:
      delta += ss

    if code & 0x08:
      delta = -delta
      
    estimate = last_data + delta

    if estimate > 2047:
      estimate = 2047

    if estimate < -2048:
      estimate = -2048

    step_index += ADPCM.step_adjust[ code ]

    if step_index < 0:
      step_index = 0

    if step_index > 48:
      step_index = 48

    return (estimate, step_index)


  def encode_adpcm(self, current_data, last_estimate, step_index):

    ss = ADPCM.step_size[ step_index ]

    delta = current_data - last_estimate

    code = 0x00
    if delta < 0:
      code = 0x08         # bit3 = 1
      delta = -delta

    if delta >= ss:
      code += 0x04        # bit2 = 1
      delta -= ss

    if delta >= ( ss >> 1 ):
      code += 0x02        # bit1 = 1
      delta -= ss>>1

    if delta >= ( ss >> 2 ):
      code += 0x01        # bit0 = 1
      
    # need to use decoder to estimate
    (estimate, adjusted_index) = self.decode_adpcm(code, step_index, last_estimate)

    return (code,estimate, adjusted_index)


  def convert_pcm_to_adpcm(self, pcm_file, pcm_freq, pcm_channels, adpcm_file, adpcm_freq, max_peak, min_avg):

    rc = 1

    with open(pcm_file, "rb") as pf:

      pcm_bytes = pf.read()
      pcm_data = []

      pcm_peak = 0
      pcm_total = 0.0
      num_samples = 0

      resample_counter = 0

      if pcm_channels == 2:
        for i in range(len(pcm_bytes) // 4):
          resample_counter += adpcm_freq
          if resample_counter >= pcm_freq:
            lch = int.from_bytes(pcm_bytes[i*4+0:i*4+2], 'big', signed=True)
            rch = int.from_bytes(pcm_bytes[i*4+2:i*4+4], 'big', signed=True)
            pcm_data.append((lch + rch) // 2)
            resample_counter -= pcm_freq
            if abs(lch) > pcm_peak:
              pcm_peak = abs(lch)
            if abs(rch) > pcm_peak:
              pcm_peak = abs(rch)
            pcm_total += float(abs(lch) + abs(rch))
            num_samples += 2
      else:
        for i in range(len(pcm_bytes) // 2):
          resample_counter += adpcm_freq
          if resample_counter >= pcm_freq:
            mch = int.from_bytes(pcm_bytes[i*2+0:i*2+2], 'big', signed=True)
            pcm_data.append(mch)
            resample_counter -= pcm_freq
            if abs(mch) > pcm_peak:
              pcm_peak = abs(mch)
            pcm_total += float(abs(mch))
            num_samples += 1

      avg_level = 100.0 * pcm_total / num_samples / 32767.0
      peak_level = 100.0 * pcm_peak / 32767.0
      print(f"Average Level ... {avg_level:.2f}%")
      print(f"Peak Level    ... {peak_level:.2f}%")

      if avg_level < float(min_avg) or peak_level > float(max_peak):
        print("Level range error. Adjust volume settings.")
        return 1

      last_estimate = 0
      step_index = 0
      adpcm_data = []

      for i,x in enumerate(pcm_data):

        # signed 16bit to 12bit, then encode to ADPCM
        xx = x // 16
        (code, estimate, adjusted_index) = self.encode_adpcm(xx, last_estimate, step_index) 

        # fill a byte in this order: lower 4 bit -> upper 4 bit
        if i % 2 == 0:
          adpcm_data.append(code)
        else:
          adpcm_data[-1] |= code << 4

        last_estimate = estimate
        step_index = adjusted_index

      with open(adpcm_file, 'wb') as af:
        af.write(bytes(adpcm_data))

    return 0

  def check_pcm_level(self, pcm_file, pcm_freq, pcm_channels, max_peak, min_avg):

    rc = 1

    with open(pcm_file, "rb") as pf:

      pcm_bytes = pf.read()

      pcm_peak = 0
      pcm_total = 0.0
      num_samples = 0

      if pcm_channels == 2:
        for i in range(len(pcm_bytes) // 4):
          lch = int.from_bytes(pcm_bytes[i*4+0:i*4+2], 'big', signed=True)
          rch = int.from_bytes(pcm_bytes[i*4+2:i*4+4], 'big', signed=True)
          if abs(lch) > pcm_peak:
            pcm_peak = abs(lch)
          if abs(rch) > pcm_peak:
            pcm_peak = abs(rch)
          pcm_total += float(abs(lch) + abs(rch))
          num_samples += 2
      else:
        for i in range(len(pcm_bytes) // 2):
          mch = int.from_bytes(pcm_bytes[i*2+0:i*2+2], 'big', signed=True)
          if abs(mch) > pcm_peak:
            pcm_peak = abs(mch)
          pcm_total += float(abs(mch))
          num_samples += 1

      avg_level = 100.0 * pcm_total / num_samples / 32767.0
      peak_level = 100.0 * pcm_peak / 32767.0
      print(f"Average Level ... {avg_level:.2f}%")
      print(f"Peak Level    ... {peak_level:.2f}%")

      if avg_level < float(min_avg) or peak_level > float(max_peak):
        print("Level range error. Adjust volume settings.")
        return 1

    return 0

#
#  stage 1 mov to adpcm/pcm
#
def stage1(src_file, src_cut_ofs, src_cut_len, \
           pcm_volume, pcm_peak_max, pcm_avg_min, pcm_freq, pcm_wip_file, pcm2_wip_file, adpcm_wip_file):

  print("[STAGE 1] started.")

  adpcm_freq = 15625

  opt = f"-y -i {src_file} "
  opt += f"-f s16be -acodec pcm_s16be -filter:a \"volume={pcm_volume},lowpass=f={adpcm_freq}\" -ar {adpcm_freq} -ac 1 -ss {src_cut_ofs} -t {src_cut_len} {pcm2_wip_file} "  
  opt += f"-f s16be -acodec pcm_s16be -filter:a \"volume={pcm_volume}\" -ar {pcm_freq} -ac 2 -ss {src_cut_ofs} -t {src_cut_len} {pcm_wip_file} "
  
  if os.system(f"ffmpeg {opt}") != 0:
    print("error: ffmpeg failed.")
    return 1
  
  if ADPCM().convert_pcm_to_adpcm(pcm2_wip_file, adpcm_freq, 1, adpcm_wip_file, adpcm_freq, pcm_peak_max, pcm_avg_min) != 0:
    print("error: adpcm conversion failed.")
    return 1
  
  print("[STAGE 1] completed.")

  return 0

#
#  stage2 mov to bmp
#
def stage2(src_file, src_cut_ofs, src_cut_len, fps, num_colors, variable_palette, screen_width, view_width, view_height, deband, sharpness, output_bmp_dir):

  print("[STAGE 2] started.")

  if screen_width != 384 and screen_width != 256:
    print(f"error: screen_width {screen_wdith} is not supported.")
    return 1

  if view_width > screen_width:
    print("error: view_width is too large.")
    return 1

  if view_height > 256:
    print("error: view_height is too large.")
    return 1

  os.makedirs(output_bmp_dir, exist_ok=True)

  for p in glob.glob(f"{output_bmp_dir}{os.sep}*.bmp"):
    if os.path.isfile(p):
      os.remove(p)

  if sharpness > 0.0:
    sharpness_filter=f",unsharp=3:3:{sharpness}:3:3:0"
  else:
    sharpness_filter=""
  
  if deband:
    deband_filter=",deband=1thr=0.02:2thr=0.02:3thr=0.02:blur=1"
    deband_filter2="-pix_fmt rgb565"
  else:
    deband_filter=""
    deband_filter2=""

  if num_colors == 256:
    if variable_palette:
      palette_filter=",split [a][b];[a] palettegen=stats_mode=single [p];[b][p] paletteuse=new=1:dither=bayer:bayer_scale=4"
      palette_filter2="-pix_fmt pal8"
    else:
      palette_filter=",split [a][b];[a] palettegen=stats_mode=diff [p];[b][p] paletteuse=dither=bayer:bayer_scale=4"
      palette_filter2="-pix_fmt pal8"
  else:
    palette_filter=""
    palette_filter2=""

  opt = f"-y -i {src_file} -ss {src_cut_ofs} -t {src_cut_len} " + \
        f"-filter_complex \"[0:v] fps={fps},scale={view_width}:{view_height}{sharpness_filter}{deband_filter}{palette_filter}\" " + \
        f"-vcodec bmp {deband_filter2}{palette_filter2} \"{output_bmp_dir}/output_%05d.bmp\""

  if os.system(f"ffmpeg {opt}") != 0:
    print("error: ffmpeg failed.")
    return 1
  
  print("[STAGE 2] completed.")

  return 0

#
#  stage 3 bmp to tx (32768/65536 colors)
#
def stage3(output_bmp_dir, num_colors, screen_width, view_width, view_height, lze_compression):

  print("[STAGE 3] started.")

  tp64k_bytes = bytes([
    0x00,0x01,0x00,0x01,0x02,0x03,0x02,0x03,0x04,0x05,0x04,0x05,0x06,0x07,0x06,0x07,0x08,0x09,0x08,0x09,0x0a,0x0b,0x0a,0x0b,0x0c,0x0d,0x0c,0x0d,0x0e,0x0f,0x0e,0x0f,
    0x10,0x11,0x10,0x11,0x12,0x13,0x12,0x13,0x14,0x15,0x14,0x15,0x16,0x17,0x16,0x17,0x18,0x19,0x18,0x19,0x1a,0x1b,0x1a,0x1b,0x1c,0x1d,0x1c,0x1d,0x1e,0x1f,0x1e,0x1f,
    0x20,0x21,0x20,0x21,0x22,0x23,0x22,0x23,0x24,0x25,0x24,0x25,0x26,0x27,0x26,0x27,0x28,0x29,0x28,0x29,0x2a,0x2b,0x2a,0x2b,0x2c,0x2d,0x2c,0x2d,0x2e,0x2f,0x2e,0x2f,
    0x30,0x31,0x30,0x31,0x32,0x33,0x32,0x33,0x34,0x35,0x34,0x35,0x36,0x37,0x36,0x37,0x38,0x39,0x38,0x39,0x3a,0x3b,0x3a,0x3b,0x3c,0x3d,0x3c,0x3d,0x3e,0x3f,0x3e,0x3f,
    0x40,0x41,0x40,0x41,0x42,0x43,0x42,0x43,0x44,0x45,0x44,0x45,0x46,0x47,0x46,0x47,0x48,0x49,0x48,0x49,0x4a,0x4b,0x4a,0x4b,0x4c,0x4d,0x4c,0x4d,0x4e,0x4f,0x4e,0x4f,
    0x50,0x51,0x50,0x51,0x52,0x53,0x52,0x53,0x54,0x55,0x54,0x55,0x56,0x57,0x56,0x57,0x58,0x59,0x58,0x59,0x5a,0x5b,0x5a,0x5b,0x5c,0x5d,0x5c,0x5d,0x5e,0x5f,0x5e,0x5f,
    0x60,0x61,0x60,0x61,0x62,0x63,0x62,0x63,0x64,0x65,0x64,0x65,0x66,0x67,0x66,0x67,0x68,0x69,0x68,0x69,0x6a,0x6b,0x6a,0x6b,0x6c,0x6d,0x6c,0x6d,0x6e,0x6f,0x6e,0x6f,
    0x70,0x71,0x70,0x71,0x72,0x73,0x72,0x73,0x74,0x75,0x74,0x75,0x76,0x77,0x76,0x77,0x78,0x79,0x78,0x79,0x7a,0x7b,0x7a,0x7b,0x7c,0x7d,0x7c,0x7d,0x7e,0x7f,0x7e,0x7f,
    0x80,0x81,0x80,0x81,0x82,0x83,0x82,0x83,0x84,0x85,0x84,0x85,0x86,0x87,0x86,0x87,0x88,0x89,0x88,0x89,0x8a,0x8b,0x8a,0x8b,0x8c,0x8d,0x8c,0x8d,0x8e,0x8f,0x8e,0x8f,
    0x90,0x91,0x90,0x91,0x92,0x93,0x92,0x93,0x94,0x95,0x94,0x95,0x96,0x97,0x96,0x97,0x98,0x99,0x98,0x99,0x9a,0x9b,0x9a,0x9b,0x9c,0x9d,0x9c,0x9d,0x9e,0x9f,0x9e,0x9f,
    0xa0,0xa1,0xa0,0xa1,0xa2,0xa3,0xa2,0xa3,0xa4,0xa5,0xa4,0xa5,0xa6,0xa7,0xa6,0xa7,0xa8,0xa9,0xa8,0xa9,0xaa,0xab,0xaa,0xab,0xac,0xad,0xac,0xad,0xae,0xaf,0xae,0xaf,
    0xb0,0xb1,0xb0,0xb1,0xb2,0xb3,0xb2,0xb3,0xb4,0xb5,0xb4,0xb5,0xb6,0xb7,0xb6,0xb7,0xb8,0xb9,0xb8,0xb9,0xba,0xbb,0xba,0xbb,0xbc,0xbd,0xbc,0xbd,0xbe,0xbf,0xbe,0xbf,
    0xc0,0xc1,0xc0,0xc1,0xc2,0xc3,0xc2,0xc3,0xc4,0xc5,0xc4,0xc5,0xc6,0xc7,0xc6,0xc7,0xc8,0xc9,0xc8,0xc9,0xca,0xcb,0xca,0xcb,0xcc,0xcd,0xcc,0xcd,0xce,0xcf,0xce,0xcf,
    0xd0,0xd1,0xd0,0xd1,0xd2,0xd3,0xd2,0xd3,0xd4,0xd5,0xd4,0xd5,0xd6,0xd7,0xd6,0xd7,0xd8,0xd9,0xd8,0xd9,0xda,0xdb,0xda,0xdb,0xdc,0xdd,0xdc,0xdd,0xde,0xdf,0xde,0xdf,
    0xe0,0xe1,0xe0,0xe1,0xe2,0xe3,0xe2,0xe3,0xe4,0xe5,0xe4,0xe5,0xe6,0xe7,0xe6,0xe7,0xe8,0xe9,0xe8,0xe9,0xea,0xeb,0xea,0xeb,0xec,0xed,0xec,0xed,0xee,0xef,0xee,0xef,
    0xf0,0xf1,0xf0,0xf1,0xf2,0xf3,0xf2,0xf3,0xf4,0xf5,0xf4,0xf5,0xf6,0xf7,0xf6,0xf7,0xf8,0xf9,0xf8,0xf9,0xfa,0xfb,0xfa,0xfb,0xfc,0xfd,0xfc,0xfd,0xfe,0xff,0xfe,0xff,
  ])

  bmp_files = sorted(os.listdir(output_bmp_dir))
  num_frames = len(bmp_files)
  written_frames = 0

  screen_height = 256
  frame_index_offset = 10000

  ofs_x = (screen_width  - view_width ) // 2 if view_width  < screen_width  else 0
  ofs_y = (screen_height - view_height) // 2 if view_height < screen_height else 0

  for i, bmp_name in enumerate(bmp_files):

    if bmp_name.lower().endswith(".bmp"):

      im = Image.open(output_bmp_dir + os.sep + bmp_name)

      im_width, im_height = im.size
      if im_width != view_width:
        print("error: bmp width is not same as view width.")
        return rc

      im_bytes = im.tobytes()

      grm_bytes = bytearray(screen_width * screen_height * 2)
      for y in range(im_height):
        for x in range(im_width):
          r = im_bytes[ (y * im_width + x) * 3 + 0 ] >> 3
          g = im_bytes[ (y * im_width + x) * 3 + 1 ] >> 3
          b = im_bytes[ (y * im_width + x) * 3 + 2 ] >> 3
          c = (g << 11) | (r << 6) | (b << 1)
          if num_colors == 65536:
            ge = im_bytes[ (y * im_width + x) * 3 + 1 ] % 8
            if ge >= 4:
              c += 1
          else:
            if c > 0:
              c += 1
          grm_bytes[ (ofs_y + y) * screen_width * 2 + (ofs_x + x) * 2 + 0 ] = c // 256
          grm_bytes[ (ofs_y + y) * screen_width * 2 + (ofs_x + x) * 2 + 1 ] = c % 256

      frame_index = i + frame_index_offset
      frame_group = i // 500

      grm_file_name = f"im{frame_group:02d}/Tx{frame_index:05d}"
      plt_file_name = f"im{frame_group:02d}/Tp{frame_index:05d}"

      os.makedirs(f"im{frame_group:02d}", exist_ok=True)

      with open(grm_file_name, "wb") as f:
        f.write(grm_bytes)

      with open(plt_file_name, "wb") as f:
        f.write(tp64k_bytes)

      if lze_compression:
        os.system(f"lze e {grm_file_name} {grm_file_name}.lze > /dev/null")

      print(".", end="", flush=True)
      written_frames += 1

  if written_frames == len(bmp_files):
    rc = 0

  print()
  print("[STAGE 3] completed.")

  return 0

#
#  main
#
def main():

  parser = argparse.ArgumentParser()
  parser.add_argument("src_file", help="source movie file")
  parser.add_argument("mcs_name", help="target mcs file")
  parser.add_argument("-fps", help="frame per second", type=float, default=30.0)
  parser.add_argument("-co", "--src_cut_ofs", help="source cut start offset", default="00:00:00.000")
  parser.add_argument("-cl", "--src_cut_len", help="source cut length", default="01:00:00.000")
  parser.add_argument("-nc", "--num_colors", help="number of colors", type=int, default=65536, choices=[256, 32768, 65536])
  parser.add_argument("-vp", "--variable_palette", help="use variable palette", action='store_true')
  parser.add_argument("-lz", "--lze_compression", help="use lze compression", action='store_true')
  parser.add_argument("-sw", "--screen_width", help="screen width", type=int, default=256, choices=[256, 384])
  parser.add_argument("-vw", "--view_width", help="view width", type=int, default=180)
  parser.add_argument("-vh", "--view_height", help="view height", type=int, default=140)
  parser.add_argument("-pv", "--pcm_volume", help="pcm volume", type=float, default=1.0)
  parser.add_argument("-pp", "--pcm_peak_max", help="pcm peak max", type=float, default=98.0)
  parser.add_argument("-pa", "--pcm_avg_min", help="pcm average min", type=float, default=8.5)
  parser.add_argument("-pf", "--pcm_freq", help="16bit pcm frequency", type=int, default=32000, choices=[22050, 24000, 32000, 44100, 48000])
#  parser.add_argument("-ib", "--use_ibit", help="use i bit for color reduction", action='store_true')
  parser.add_argument("-db", "--deband", help="use debanding filter", action='store_true')
  parser.add_argument("-sp", "--sharpness", help="sharpness (max 1.5)", type=float, default=0.6)
  parser.add_argument("-tt", "--title", help="macs title", default="")
  parser.add_argument("-cm", "--comment", help="macs comment", default="")
  parser.add_argument("-bm", "--preserve_bmp", help="preserve output bmp folder", action='store_true')

  args = parser.parse_args()

  output_bmp_dir = "output_bmp"

  mcs_data_file = f"{args.mcs_name}"
  if mcs_data_file[-4:].upper() != ".MCS":
    mcs_data_file += ".MCS"
  pcm_wip_file = f"_wip_pcm.dat"
  pcm2_wip_file = f"_wip_pcm2.dat"
  adpcm_wip_file = f"_wip_adpcm.dat"

  if stage1(args.src_file, args.src_cut_ofs, args.src_cut_len, \
            args.pcm_volume, args.pcm_peak_max, args.pcm_avg_min, args.pcm_freq, pcm_wip_file, pcm2_wip_file, adpcm_wip_file) != 0:
    return 1
  
  if stage2(args.src_file, args.src_cut_ofs, args.src_cut_len, \
            args.fps, args.num_colors, args.variable_palette, \
            args.screen_width, args.view_width, args.view_height, args.deband, args.sharpness, \
            output_bmp_dir) != 0:
    return 1

  if stage3(output_bmp_dir, args.num_colors, \
            args.screen_width, args.view_width, args.view_height, args.lze_compression):
    return 1

#  if pcm_wip_file:
#    if os.path.isfile(pcm_wip_file):
#	    os.remove(pcm_wip_file)

#  if pcm2_wip_file:
#    if os.path.isfile(pcm2_wip_file):
#	    os.remove(pcm2_wip_file)

#  if adpcm_wip_file:
#    if os.path.isfile(adpcm_wip_file):
#      os.remove(adpcm_wip_file)

  if args.preserve_bmp is False:
    shutil.rmtree(output_bmp_dir, ignore_errors=True)

  return 0

if __name__ == "__main__":
  main()
