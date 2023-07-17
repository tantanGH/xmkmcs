.include macs_sch.h

SET_OFFSET

USE_DUALPCM 'S22'		

TITLE   'MACS sample'
COMMENT '256x216 256colors variable palette 24.0fps raw:lze=50:50'
;COMMENT '256x216 256colors lze'
;COMMENT '384x216 256colors raw'
;COMMENT '384x216 256colors lze'

SCREEN_ON_G256
;SCREEN_ON_G384

SET_FPS24
;SET_FPS30

SET_VIEWAREA_Y 216
;SET_VIEWAREA_Y 256

DRAW_DATA_RP 10000

PCM_PLAY_S22 pcmdat,pcmend-pcmdat
PCM_PLAY_SUBADPCM adpcmdat,adpcmend-adpcmdat

; set last frame index at the 2nd argument
DRAW_DATA 10001,12145

WAIT 60
PCM_STOP

EXIT
