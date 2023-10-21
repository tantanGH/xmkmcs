.include macs_sch.h

SET_OFFSET

;
;  16bit PCM format
;
USE_DUALPCM 'S48'
;USE_DUALPCM 'S44'
;USE_DUALPCM 'S22'

;
;  title
;
TITLE   'xxxxxxxxx'

;
;  comment
;
COMMENT '384x200 256êF 24.0fps raw'

;
;  screen mode
;
SCREEN_ON_G384
;SCREEN_ON_G256

;
;  FPS generic
;
SET_FPS24	; 24.000
;SET_FPS24_NTSC	; 23.976
;SET_FPS30_NTSC	; 29.970

;
;  FPS for 256 mode (vsync 55.458Hz)
;
;SET_FPS15_X68  ; 15fps (13.865)
;SET_FPS20_X68  ; 20fps (18.486)
;SET_FPS 22183  ; 24fps (22.183)
;SET_FPS30_X68  ; 30fps (27.729)

;
;  FPS for 384 mode (vsync 56.272Hz)
;
;SET_FPS 14068  ; 15fps (14.068)
;SET_FPS 18757  ; 20fps (18.757)
;SET_FPS 22509  ; 24fps (22.509)
;SET_FPS 28136  ; 30fps (28.136)

;
;  view area size
;
;SET_VIEWAREA_Y 256
SET_VIEWAREA_Y 200

;
;  draw 1st frame
;
DRAW_DATA_RP 10000

;
;  start PCM playback
;
PCM_PLAY_S48 pcmdat,pcmend-pcmdat
;PCM_PLAY_S44 pcmdat,pcmend-pcmdat
;PCM_PLAY_S42 pcmdat,pcmend-pcmdat
PCM_PLAY_SUBADPCM adpcmdat,adpcmend-adpcmdat

;
;  draw frames
;
DRAW_DATA 10001,19999

;
;  finish and exit
;
WAIT 60
PCM_STOP
EXIT
