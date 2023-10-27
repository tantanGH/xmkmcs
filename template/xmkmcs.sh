#!/usr/bin/env bash

set -u

#
#  source movie file
#
source_file="./xxxxx.mp4"

#
#  source movie cut start/to timestamps
#    note: ffmpeg cuts movie at each key frame, so you should set 'rough' time range for these parameters.
#
source_cut_ss="-ss 00:00:00.000"
source_cut_to="-to 00:03:50.000"

#
#  source movie cut start offset and length
#    note: this is applied AFTER the source movie is cut at key frames.
#
source_cut_offset="-ss 00:00:00.000"
source_cut_length="-t  00:03:44.000"

#
#  FPS generic
#
fps=24.0        # SET_FPS24
#fps=23.976     # SET_FPS24_NTSC
#fps=29.97      # SET_FPS30_NTSC

#
#  FPS for 256 mode (vsync 55.458Hz)
#
#fps=13.865     # SET_FPS15_X68
#fps=18.486     # SET_FPS20_X68
#fps=22.183     # SET_FPS 22.183 (24fps)
#fps=27.729     # SET_FPS30_X68

#
#  FPS for 384 mode (vsync 56.272Hz)
#
#fps=14.068     # SET_FPS 14068 (15fps)
#fps=18.757     # SET_FPS 18757 (20fps)
#fps=22.509     # SET_FPS 22509 (24fps)
#fps=28.136     # SET_FPS 28136 (30fps)

#
#  use variable palette (1) or fixed palette (0)
#
#variable_palette=0
variable_palette=1

#
#  screen size (384x256 or 256x256)
#
screen_width=384
#screen_width=256
screen_height=256

#
#  view size (must be within the screen size)
#
view_width=384
#view_width=256
view_height=200

#
#  LZE compression (0:no 1:yes)
#
lze_compression=0
#lze_compression=1

#
#  dither options (0-5, 0:more grains 5:more bands)
#
bayer_scale=4
#bayer_scale=5

#
#  16bit PCM frequency (48000/44100/22050)
#
pcm_freq=48000
#pcm_freq=44100
#pcm_freq=22050

#
#  ADPCM frequency (15625)
#
adpcm_freq=15625

#
#  PCM volume
#
pcm_volume=1.0

#
#  check execution module path
#
python_exec=`which python`
if [ $? -ne 0 ]; then
  python_exec=`which python3`
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

pcm2adpcm=`which pcm2adpcm`
if [ $? -ne 0 ]; then
  echo "pcm2adpcm is not installed."
  exit 1    
fi

gif2tx=`which gif2tx`
if [ $? -ne 0 ]; then
  echo "gif2tx is not installed."
  exit 1
fi  
  
pymcslk=`which pymcslk`
if [ $? -ne 0 ]; then
  echo "pymcslk is not installed."
  exit 1    
fi

lze_exec=""
if [ "$lze_compression" == "1" ]; then
  lze_exec=`which lze`
  if [ $? -ne 0 ]; then
    echo "lze is not installed."
    exit 1
  fi
fi


#
#  [STAGE 1] source movie to gif/pcm conversion
#    input: 
#      - movie file (avi/mov/mp4/m4v/etc.)
#    output:
#      - animated GIF file
#      - 16bit (big endian) PCM files
#
function stage1() {

  date
  echo "[STAGE 1] started."

  if [ "$variable_palette" == "1" ]; then
    palette_filter=",split [a][b];[a] palettegen=stats_mode=single [p];[b][p] paletteuse=new=1:dither=bayer:bayer_scale=${bayer_scale}"
  else
    palette_filter=",split [a][b];[a] palettegen=stats_mode=diff [p];[b][p] paletteuse=dither=bayer:bayer_scale=${bayer_scale}"
  fi  

  $ffmpeg_exec -y \
    $source_cut_ss $source_cut_to -i "$source_file" $source_cut_offset $source_cut_length \
    -filter_complex \
    "[0:v] fps=${fps},scale=${view_width}:${view_height} ${palette_filter}" \
    "$gif_file" \
    -f s16be -acodec pcm_s16be -filter:a "volume=$pcm_volume" -ar $pcm_freq   -ac 2 $source_cut_offset $source_cut_length $pcm_file \
    -f s16be -acodec pcm_s16be -filter:a "volume=$pcm_volume" -ar $adpcm_freq -ac 1 $source_cut_offset $source_cut_length $pcm_file2

  if [ $? != 0 ]; then
    echo "error: ffmpeg failed."
    exit 1
  fi

  $pcm2adpcm -p 95 $pcm_file2 $adpcm_freq 1 $adpcm_file $adpcm_freq
  if [ $? != 0 ]; then
    echo "error: adpcm conversion failed."
    exit 1
  fi

  date
  echo "[STAGE 1] completed."
}


#
#  [STAGE 2] animated gif to tx/tp conversion
#    input:
#      - animated GIF file
#    output:
#      - tx files
#      - tp files
#
function stage2() {

  date
  echo "[STAGE 2] started."

  $gif2tx -sw $screen_width -sh $screen_height -vw $view_width -vh $view_height "$gif_file"
  if [ $? != 0 ]; then
    echo "error: gif to tx conversion failed."
    exit 1
  fi

  date
  echo "[STAGE 2] completed."
}


#
#  [STAGE 2a (optional)] apply fix palette frames
#    input:
#      - movie file
#      - palette fix start frame number
#      - palette fix end frame number
#    output:
#      - tx files
#      - tp files
#
function fix_palette() {

  start_frame=$1
  end_frame=$2
  end_frame2=`expr $end_frame + 30`

  date
  echo "[STAGE 2a] started for ${start_frame} - ${end_frame}."

  palette_filter=",split [a][b];[a] palettegen=stats_mode=diff [p];[b][p] paletteuse=dither=bayer:bayer_scale=${bayer_scale}"
  trim_filter="trim=start_frame=${start_frame}:end_frame=${end_frame2}"
  
  $ffmpeg_exec -y \
    $source_cut_ss $source_cut_to -i "$source_file" $source_cut_offset $source_cut_length \
    -filter_complex "[0:v] fps=${fps},${trim_filter},scale=${view_width}:${view_height} ${palette_filter},setpts=PTS-STARTPTS[v0]" \
    -map [v0] "_wip_${start_frame}_${end_frame}.gif"

  if [ $? != 0 ]; then
    echo "error: ffmpeg failed."
    exit 1
  fi

  $gif2tx -sw $screen_width -sh $screen_height -vw $view_width -vh $view_height -fs $start_frame -fe $end_frame "_wip_${start_frame}_${end_frame}.gif"
  if [ $? != 0 ]; then
    echo "error: gif to tx conversion failed."
    exit 1
  fi

  date
  echo "[STAGE 2a] completed."
}

#
#  [STAGE 3] tx(raw) to tx(lze) compression
#    input:
#      - tx(raw) files
#    output:
#      - tx(lze) files
#
function stage3() {

  date
  echo "[STAGE 3] started."

  for i in 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23; do

    if [ -d "im${i}" ]; then

      echo im${i}
      cd im${i}

      frame_index_min=99999
      frame_index_max=10000

      for raw_file in `ls Tx?????`; do
        if [ "$lze_compression" != "0" ]; then
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

      cd ..

    fi

  done

  date
  echo "[STAGE 3] completed."
}

#
#  temporary gif file name
#
gif_file="_wip.gif"

#
#  temporary 16bit pcm file name
#
pcm_file="_wip_pcm.dat"

#
#  temporary 16bit pcm file name 2 (for adpcm conversion)
#
pcm_file2="_wip_pcm2.dat"

#
#  temporary adpcm file name
#
adpcm_file="_wip_adpcm.dat"


# STAGE1 ffmpeg
stage1

# STAGE2 gif2tx
stage2

# STAGE3 lze
stage3

date
echo "finished."
echo "last frame index = $frame_index_max"
