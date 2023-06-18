#!/usr/bin/env bash
#
#   xmkmcs1.sh - X680x0 MACS data cross builder #1
#
#   version 2023.06.18 tantan
#
#   Prerequisites:
#     - Linux/macOS or similar OS environment (WSL2 on Windows may also work?)
#     - xdev68k environment (bash, HAS060.X on run68)
#     - ffmpeg
#     - unix2dos (dos2unix)
#     - lze
#     - macs_sch.h
#     - Python Pillow library (pip install pillow)
#
#   How to use:
#     1. Create a new project folder.
#     2. Copy xmkmcs1.sh, gif2tx.py, pcm2adpcm.py, xmkmcs2.bat, macs_sch.h to the folder.
#     3. Edit parameters in xmkmcs1.sh.
#     4. Run xmkmcs1.sh.
#     5. Update macs_src.s on XEiJ.
#     6. Run xmkmcs2.bat on XEiJ 060turbo mode. (060turbo.sys -xm with 256MB high memory)
#

set -u

python_exec=`which python3`
if [ $? -ne 0 ]; then
  python_exec=`which python`
  if [ $? -ne 0 ]; then
    echo "python is not installed."
    exit 1
  fi
fi

ffmpeg_exec=`which ffmpeg`
if [ $? -ne 0 ]; then
  echo "ffmpeg is not installed."
  exit 1
fi

unix2dos_exec=`which unix2dos`
if [ $? -ne 0 ]; then
  echo "unix2dos is not installed."
  exit 1
fi

lze_exec=`which lze`
if [ $? -ne 0 ]; then
  echo "lze is not installed."
  exit 1
fi

run68_exec=`which run68`
if [ $? -ne 0 ]; then
  echo "run68 is not installed."
  exit 1
fi

unix2dox_exec=`which unix2dos`
if [ $? -ne 0 ]; then
  echo "unix2dos is not installed."
  exit 1
fi


#
#  [STAGE 1] movie to gif/pcm conversion
#    input: 
#      - movie file (avi/mov/mp4/m4v/etc.)
#    output:
#      - animated GIF file
#      - 16bit (big endian) PCM file at 48000/44100/22050Hz
#      - 16bit (big endian) PCM file at 15625Hz
#
function stage1() {

  date
  echo "[STAGE 1] started."

  ffopt_paletteuse="paletteuse=dither=bayer:bayer_scale=${bayer_scale}"

  # movie to gif,pcm and pcm2
  $ffmpeg_exec -y \
    $source_cut_ss $source_cut_to -i "$source_file" $source_cut_offset $source_cut_length \
    -filter_complex \
    "[0:v] scale=${view_width}:${view_height},split [a][b];[a] palettegen [p];[b][p] ${ffopt_paletteuse}" \
    "$gif_file" \
    -f s16be -acodec pcm_s16be -filter:a "volume=$pcm_volume" -ar $pcm_freq -ac 2 $source_cut_offset $source_cut_length $pcm_file \
    -f s16be -acodec pcm_s16be -filter:a "volume=$pcm_volume" -ar $adpcm_freq -ac 1 $source_cut_offset $source_cut_length $pcm_file2

  if [ $? != 0 ]; then
    echo "error: ffmpeg failed."
    exit 1
  fi

  # pcm2 to adpcm
  $python_exec $pcm2adpcm $pcm_file2 $adpcm_freq 1 $adpcm_file $adpcm_freq
  if [ $? != 0 ]; then
    echo "error: adpcm conversion failed."
    exit 1
  fi

  date
  echo "[STAGE 1] completed."
}


#
#  [STAGE 2] gif to tx(raw)/tp conversion
#    input:
#      - animated GIF file
#    output:
#      - tx(raw) files
#      - tp files
#
function stage2() {

  date
  echo "[STAGE 2] started."

  # gif to tx/tp
  $python_exec $gif2tx -sw $screen_width -sh $screen_height -vw $view_width -vh $view_height $crop_x $crop_y $num_frames "$gif_file"
  if [ $? != 0 ]; then
    echo "error: gif to tx conversion failed."
    exit 1
  fi

  date
  echo "[STAGE 2] completed."
}

#
#  [STAGE 3] tx(raw) to tx(lze) compression
#    input:
#      - tx(raw) files
#    output:
#      - tx(lze) files
#      - list files
#
function stage3() {

  date
  echo "[STAGE 3] started."

  for i in 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15; do

    if [ -d "im${i}" ]; then

      echo im${i}
      cd im${i}

      frame_index_min=99999
      frame_index_max=10000

      for raw_file in `ls Tx?????`; do
        if [ "$lze_compression" == "1" ]; then
          lze_file="${raw_file}.lze"
          $lze_exec e $raw_file $lze_file > /dev/null
        fi
        frame_index=${raw_file:2:5}
        if [ $frame_index -lt $frame_index_min ]; then
          frame_index_min=$frame_index
        fi
        if [ $frame_index -gt $frame_index_max ]; then
          frame_index_max=$frame_index
        fi
      done

      num_frames=`expr $frame_index_max - $frame_index_min + 1`

      list_file="list${i}.s"
      echo "i=${frame_index_min}" > $list_file
      echo ".rept ${num_frames}" >> $list_file
      echo ".quad" >> $list_file
      if [ "$lze_compression" == "1" ]; then
        echo "Tx%i:: .insert Tx%i.lze" >> $list_file
      else
        echo "Tx%i:: .insert Tx%i" >> $list_file
      fi
      echo ".even" >> $list_file
      echo "Tp%i:: .insert Tp%i" >> $list_file
      echo "i=i+1" >> $list_file
      echo ".endm" >> $list_file

      $unix2dos_exec $list_file

      cd ..

    fi

  done

  listpcm_file="listpcm.s"

	echo ".even" > $listpcm_file
  echo "pcmdat:: .insert ${pcm_file}" >> $listpcm_file
  echo "pcmend::" >> $listpcm_file
	echo ".even" >> $listpcm_file
  echo "adpcmdat:: .insert ${adpcm_file}" >> $listpcm_file
  echo "adpcmend::" >> $listpcm_file

  unix2dos $listpcm_file

  echo "last frame index = $frame_index_max"

  date
  echo "[STAGE 3] completed."
}

#
#  [STAGE 4] list file assemble
#    input:
#      - list files
#      - tx(lze/raw) files
#      - tp files
#    output:
#      - list object files
#
function stage4() {

  date
  echo "[STAGE 4] started."

  for i in 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15; do

    if [ -d "im${i}" ]; then

      cd im${i}

      echo "$run68_exec $has060 -t . list${i}.s &"
      $run68_exec $has060 -t . list${i}.s &

      cd ..

    fi

  done

  if [ -e "listpcm.s" ]; then
    echo "$run68_exec $has060 -t . listpcm.s &"
    $run68_exec $has060 -t . listpcm.s &
  fi

  wait

  date
  echo "[STAGE 4] completed."
}

#
#  main - update the below settings before execution
#

# gif2tx.py path
gif2tx=./gif2tx.py

# pcm2adpcm.py path
pcm2adpcm=./pcm2adpcm.py

# HAS060.X path
has060=/opt/xdev68k/x68k_bin/HAS060.X 

# source movie file
source_file="../MadokaMagicaOp.m4v"

# source movie cut start/to timestamps
#   note: ffmpeg cuts movie at each key frame, so you should set 'rough' time range for these parameters.
source_cut_ss="-ss 00:02:57.500"
source_cut_to="-to 00:04:29.000"

# source movie cut start offset and length
#   note: this is applied AFTER the source movie is cut at key frames.
source_cut_offset="-ss 00:00:00.800"
source_cut_length="-t  00:01:29.500"

# macs screen size (384x256 or 256x256)
#screen_width=384
screen_width=256
screen_height=256

# macs view size (must be within the screen size)
#view_width=384
view_width=256
view_height=216

# crop offset (optional, in case you want to crop certain part of the source movie frame)
#crop_x="-cx 0"
#crop_y="-cy 0"
crop_x=
crop_y=

# total frames (optional, for debug)
#num_frames="-n 2500"
num_frames=

# dither options (0-5, 0:more grains 5:more bands)
#bayer_scale=4
bayer_scale=5

# output PCM frequency (48000/44100/22050)
#pcm_freq=48000
#pcm_freq=44100
pcm_freq=22050

# output PCM volume ratio
pcm_volume=1.0

# output ADPCM frequency
adpcm_freq=15625

# LZE compression (0:no 1:yes)
#lze_compression=0
lze_compression=1

# temporary gif file name
gif_file="_wip.gif"

# temporary 16bit pcm file name
pcm_file="_wip_pcm.dat"

# temporary 16bit pcm file name 2 (for adpcm conversion)
pcm_file2="_wip_pcm2.dat"

# temporary adpcm file name
adpcm_file="_wip_adpcm.dat"

# STAGE1 ffmpeg / pcm2adpcm
stage1

# STAGE2 gif2tx
stage2

# STAGE3 lze
stage3

# STAGE4 has060
stage4