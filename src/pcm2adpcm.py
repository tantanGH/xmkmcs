#
#  pcm2adpcm.py - 16bit raw PCM (big endian) to X68k ADPCM data converter
#
#  version 2023.06.21 by tantan
#
#   Prerequisites:
#     - Python 3
#

import os
import sys
import argparse

step_adjust = [ -1, -1, -1, -1, 2, 4, 6, 8, -1, -1, -1, -1, 2, 4, 6, 8 ]

step_size = [  16,  17,  19,  21,  23,  25,  28,  31,  34,  37,  41,  45,   50,   55,   60,   66,
               73,  80,  88,  97, 107, 118, 130, 143, 157, 173, 190, 209,  230,  253,  279,  307,
              337, 371, 408, 449, 494, 544, 598, 658, 724, 796, 876, 963, 1060, 1166, 1282, 1411, 1552 ]

def decode_adpcm(code, step_index, last_data):

  ss = step_size[ step_index ]

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

  step_index += step_adjust[ code ]

  if step_index < 0:
    step_index = 0

  if step_index > 48:
    step_index = 48

  return (estimate, step_index)

def encode_adpcm(current_data, last_estimate, step_index):

  ss = step_size[ step_index ]

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
  (estimate, adjusted_index) = decode_adpcm(code, step_index, last_estimate)

  return (code,estimate, adjusted_index)

def convert_pcm_to_adpcm(pcm_file, pcm_freq, pcm_channels, adpcm_file, adpcm_freq):

  with open(pcm_file, "rb") as pf:

    pcm_bytes = pf.read()
    pcm_data = []
    
    resample_counter = 0

    if pcm_channels == 2:
      for i in range(len(pcm_bytes) // 4):
        resample_counter += adpcm_freq
        if resample_counter >= pcm_freq:
          lch = int.from_bytes(pcm_bytes[i*4+0:i*4+2], 'big', signed=True)
          rch = int.from_bytes(pcm_bytes[i*4+2:i*4+4], 'big', signed=True)
          pcm_data.append((lch + rch) // 2)
          resample_counter -= pcm_freq
    else:
      for i in range(len(pcm_bytes) // 2):
        resample_counter += adpcm_freq
        if resample_counter >= pcm_freq:
          mch = int.from_bytes(pcm_bytes[i*2+0:i*2+2], 'big', signed=True)
          pcm_data.append(mch)
          resample_counter -= pcm_freq

    last_estimate = 0
    step_index = 0
    adpcm_data = []

    for i,x in enumerate( pcm_data ):

      # signed 16bit to 12bit, then encode to ADPCM
      xx = x // 16
      (code, estimate, adjusted_index) = encode_adpcm(xx, last_estimate, step_index) 

      # fill a byte in this order: lower 4 bit -> upper 4 bit
      if i % 2 == 0:
        adpcm_data.append(code)
      else:
        adpcm_data[-1] |= code << 4

      last_estimate = estimate
      step_index = adjusted_index

    with open(adpcm_file, 'wb') as af:
      af.write(bytes(adpcm_data))

def main():

  parser = argparse.ArgumentParser()
  parser.add_argument("pcm_file", help="input PCM file")
  parser.add_argument("pcm_freq", help="input PCM frequency", type=int)
  parser.add_argument("pcm_channels", help="input PCM channels", type=int)
  parser.add_argument("adpcm_file", help="output ADPCM file")
  parser.add_argument("adpcm_freq", help="output ADPCM frequency", type=int)
  args = parser.parse_args()

  convert_pcm_to_adpcm( args.pcm_file, args.pcm_freq, args.pcm_channels, args.adpcm_file, args.adpcm_freq)


if __name__ == "__main__":
    main()
