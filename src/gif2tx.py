import argparse
import sys
import os

from PIL import Image, ImageSequence

def convert_gif_to_tx_variable_palette(gif_file_name, screen_width, screen_height, view_width, view_height, crop_x=0, crop_y=0):

    # size check
    if view_width > screen_width or view_height > screen_height:
      print("error: view size is larger than screen size.")
      return

    # centering
    ofs_x = (screen_width  - view_width ) // 2 if view_width  < screen_width  else 0
    ofs_y = (screen_height - view_height) // 2 if view_height < screen_height else 0

    # frame index offset (fix)
    frame_index_offset = 10000

    # frame number
    n = 0
    
    with Image.open(gif_file_name) as gif:

      for im in ImageSequence.Iterator(gif):

        im2 = im.convert('RGB').convert('P', palette=1, colors=255, dither=None)
        im_palette = im2.getpalette()
        im_bytes = im2.tobytes()

        im_width, im_height = im.size

        grm = bytearray( [0] * screen_width * screen_height )

        for y in range(view_height):
          for x in range(view_width):
            pal_code = im_bytes[ ( crop_y + y ) * im_width + ( crop_x + x ) ]
            if pal_code == 0:
              pal_code = 255
            elif pal_code == 255:
              pal_code = 0
            grm[ ( ofs_y + y ) * screen_width + ofs_x + x ] = pal_code

        plt = bytearray( 2 * 256 )

        for i in range(256):
          grb_word = ((im_palette[ i * 3 + 1 ] >> 3) << 11) | ((im_palette[ i * 3 + 0 ] >> 3) << 6) | ((im_palette[ i * 3 + 2 ] >> 3) << 1)
          grb_word += 1 if grb_word != 0 else 0
          plt[ i * 2 + 0 ] = ( grb_word >> 8 ) & 0xff
          plt[ i * 2 + 1 ] = ( grb_word >> 0 ) & 0xff

        plt[ 255 * 2 + 0 ] = plt[ 0 ]
        plt[ 255 * 2 + 1 ] = plt[ 1 ]
        plt[ 0 ] = 0
        plt[ 1 ] = 0

        frame_index = n + frame_index_offset
        frame_group = n // 500

        grm_file_name = f"im{frame_group:02d}/Tx{frame_index:05d}"
        plt_file_name = f"im{frame_group:02d}/Tp{frame_index:05d}"

        os.makedirs(f"im{frame_group:02d}", exist_ok=True)

        with open(grm_file_name, "wb") as f:
          f.write(grm)

        with open(plt_file_name, "wb") as f:
          f.write(plt)

        print(".", end="", flush=True)

        n += 1

      print("Done.")

def convert_gif_to_tx_fixed_palette(gif_file_name, screen_width, screen_height, view_width, view_height, crop_x=0, crop_y=0):

    # size check
    if view_width > screen_width or view_height > screen_height:
      print("error: view size is larger than screen size.")
      return

    # centering
    ofs_x = (screen_width  - view_width ) // 2 if view_width  < screen_width  else 0
    ofs_y = (screen_height - view_height) // 2 if view_height < screen_height else 0

    # frame index offset (fix)
    frame_index_offset = 10000

    # frame number
    n = 0

    # global palette
    im_palette = None
    im_pal_codes = dict()
    
    with Image.open(gif_file_name) as gif:

      for im in ImageSequence.Iterator(gif):

        if im_palette is None:
          im_palette = im.getpalette()
          for i in range(256):
            col_code = (im_palette[ i * 3 + 0 ] << 16) | (im_palette[ i * 3 + 1 ] << 8) | im_palette[ i * 3 + 2 ]
            im_pal_codes[ col_code ] = i
        
        im_bytes = im.convert('RGB').tobytes()
        im_width, im_height = im.size

        grm = bytearray( [0] * screen_width * screen_height )

        for y in range(view_height):
          for x in range(view_width):
            col_code = (im_bytes[ ( crop_y + y ) * im_width * 3 + ( crop_x + x ) * 3 + 0 ] << 16) | \
                       (im_bytes[ ( crop_y + y ) * im_width * 3 + ( crop_x + x ) * 3 + 1 ] <<  8) | \
                        im_bytes[ ( crop_y + y ) * im_width * 3 + ( crop_x + x ) * 3 + 2 ]
            if im_pal_codes[ col_code ] is None:
              print(f"error: palette code is not defined for color {col_code:06h}")
              sys.exit(1)
            grm[ ( ofs_y + y ) * screen_width + ofs_x + x ] = im_pal_codes[ col_code ]

        plt = bytearray( 2 * 256 )

        for i in range(256):
          grb_word = ((im_palette[ i * 3 + 1 ] >> 3) << 11) | ((im_palette[ i * 3 + 0 ] >> 3) << 6) | ((im_palette[ i * 3 + 2 ] >> 3) << 1) | 1
          plt[ i * 2 + 0 ] = ( grb_word >> 8 ) & 0xff
          plt[ i * 2 + 1 ] = ( grb_word >> 0 ) & 0xff

        frame_index = n + frame_index_offset
        frame_group = n // 500

        grm_file_name = f"im{frame_group:02d}/Tx{frame_index:05d}"
        plt_file_name = f"im{frame_group:02d}/Tp{frame_index:05d}"

        os.makedirs(f"im{frame_group:02d}", exist_ok=True)

        with open(grm_file_name, "wb") as f:
          f.write(grm)

        with open(plt_file_name, "wb") as f:
          f.write(plt)

        print(".", end="", flush=True)

        n += 1

      print("Done.")


def main():

    parser = argparse.ArgumentParser()
    parser.add_argument("infile", help="input gif file")
    parser.add_argument("-sw", "--screen_width", help="screen area width (default:256)", type=int, default=256)
    parser.add_argument("-sh", "--screen_height", help="screen area height (default:256)", type=int, default=256)
    parser.add_argument("-vw", "--view_width", help="view area width (default:256)", type=int, default=256)
    parser.add_argument("-vh", "--view_height", help="view area height (default:256)", type=int, default=256)
    parser.add_argument("-cx", "--crop_x", help="source x crop offset (default:0)", type=int, default=0)
    parser.add_argument("-cy", "--crop_y", help="source y crop offset (default:0)", type=int, default=0)
    parser.add_argument("-vp", "--variable_palette", help="use variable palette", action='store_true', default=False)

    args = parser.parse_args()

    if args.variable_palette:
      convert_gif_to_tx_variable_palette(args.infile, args.screen_width, args.screen_height, args.view_width, args.view_height, args.crop_x, args.crop_y)
    else:
      convert_gif_to_tx_fixed_palette(args.infile, args.screen_width, args.screen_height, args.view_width, args.view_height, args.crop_x, args.crop_y)


if __name__ == "__main__":
    main()
