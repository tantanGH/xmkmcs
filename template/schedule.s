.include macs_sch.h

SET_OFFSET

;USE_DUALPCM 'S48'
;USE_DUALPCM 'S44'
USE_DUALPCM 'S22'		

TITLE   'MACS sample'
COMMENT '256x216 256colors variable palette 24.0fps raw:lze=50:50'

;SCREEN_ON_G384
SCREEN_ON_G256

;SET_FPS15_X68
;SET_FPS15
;SET_FPS20_X68
;SET_FPS24_NTSC
SET_FPS24
;SET_FPS30_X68
;SET_FPS30_NTSC
;SET_FPS30
;SET_FPS60_X68

;fps=13.865     # SET_FPS15_X68
;fps=15.0       # SET_FPS15
;fps=18.486     # SET_FPS20_X68
;fps=23.976     # SET_FPS24_NTSC
;fps=24.0       # SET_FPS24
;fps=27.729     # SET_FPS30_X68
;fps=29.97      # SET_FPS30_NTSC
;fps=30.0       # SET_FPS30
;fps=55.458     # SET_FPS60_X68

SET_VIEWAREA_Y 216
;SET_VIEWAREA_Y 256

DRAW_DATA_RP 10000

;PCM_PLAY_S48 pcmdat,pcmend-pcmdat
;PCM_PLAY_S44 pcmdat,pcmend-pcmdat
PCM_PLAY_S22 pcmdat,pcmend-pcmdat
PCM_PLAY_SUBADPCM adpcmdat,adpcmend-adpcmdat

; set last frame index at the 2nd argument
DRAW_DATA 10001,12145

WAIT 60
PCM_STOP

EXIT
