data_top:	dc.b	'MACSDATA'
		dc.w	$01_30
		dc.l	0

EXIT		macro
		dc.w	$0
		endm
SET_OFFSET	macro
offset_pos:	dc.w	$1
		endm
WAIT		macro	time
		dc.w	$2
		dc.w	time
		endm
DRAW		macro	addr
		dc.w	$3
		dc.l	addr-offset_pos
		endm
SET_POSITION	macro	apage,vpage
		dc.w	$4
		dc.w	apage,vpage
		endm
CHANGE_POSITION	macro
		dc.w	$5
		endm
BEFORE_COPY	macro
		dc.w	$6
		endm
PALETTE		macro	addr
		dc.w	$7
		dc.l	addr-offset_pos
		endm
SCREEN_ON	macro
		dc.w	$8
		endm
SCREEN_OFF	macro
		dc.w	$9
		endm
PCM_PLAY	macro	addr,size
		dc.w	$A
		dc.l	addr-offset_pos
		dc.l	size
		endm
PCM_STOP	macro
		dc.w	$B
		endm
PAN		macro	pos
		dc.w	$C
		dc.w	pos
		endm
GOTO		macro	addr
		dc.w	$D
		dc.l	addr-offset_pos
		endm
CALL		macro	addr
		dc.w	$E
		dc.l	addr-offset_pos
		endm
CALL1		macro	addr,dat1
		dc.w	$F
		dc.l	addr-offset_pos
		dc.l	dat1
		endm
CALL2		macro	addr,dat1,dat2
		dc.w	$10
		dc.l	addr-offset_pos
		dc.l	dat1
		dc.l	dat2
		endm
CALL3		macro	addr,dat1,dat2,dat3
		dc.w	$11
		dc.l	addr-offset_pos
		dc.l	dat1
		dc.l	dat2
		dc.l	dat3
		endm


SCREEN_ON_G64K	macro				;256x256 65536色 グラフィックVRAM
		dc.w	$17
		endm
SCREEN_ON_G256	macro				;256x256 256色 GVRAM
		dc.w	$16
		endm
SCREEN_ON_G384	macro				;384x256 256色 GVRAM
		dc.w	$29
		endm
SCREEN_ON_T512	macro				;512x512 16色 テキストVRAM
		dc.w	$25
		endm
SCREEN_ON_T512_C4	macro			;512x512 4色 TVRAM
		dc.w	$1c
		endm
SCREEN_ON_T768	macro				;768x512 1色 TVRAM
		dc.w	$20
		endm
SCREEN_ON_T512_V256	macro			;512x256 16色 TVRAM
		dc.w	$35
		endm
SCREEN_ON_T256	macro				;256x256 16色 TVRAM (※改造版)
		dc.w	$37
		endm
SCREEN_ON_G256_V128	macro			;256x128 256色 GVRAM
		dc.w	$39
		endm
SCREEN_ON_G384_V128	macro			;384x128 256色 GVRAM
		dc.w	$3a
		endm


PCM_PLAY_8PP	macro	addr,size,ch,freq,v_freq
		dc.w	$18
		dc.l	addr-offset_pos
		dc.l	size
		dc.w	ch
		dc.l	freq
		dc.l	v_freq
		endm
PCM_PLAY_S44	macro	addr,size		;44100Hz 16bit Stereo 2ch
		dc.w	$18
		dc.l	addr-offset_pos
		dc.l	size
		dc.w	$0000
		dc.l	$00081d03
		dc.l	$0
		endm
PCM_PLAY_S48	macro	addr,size		;48000Hz 16bit Stereo 2ch
		dc.w	$18
		dc.l	addr-offset_pos
		dc.l	size
		dc.w	$0000
		dc.l	$00081e03
		dc.l	$0
		endm
PCM_PLAY_S22	macro	addr,size		;22050Hz 16bit Stereo 2ch
		dc.w	$18
		dc.l	addr-offset_pos
		dc.l	size
		dc.w	$0000
		dc.l	$00081a03
		dc.l	$0
		endm
PCM_STOP_8PP	macro
		dc.w	$19
		endm


TITLE		macro	word
		.local	l1,l2
		dc.w	$2c
		dc.w	l2-l1
l1:		dc.b	'TITLE:'
		dc.b	word
		dc.b	0
		.even
l2:
		endm

COMMENT		macro	word
		.local	l1,l2
		dc.w	$2c
		dc.w	l2-l1
l1:		dc.b	'COMMENT:'
		dc.b	word
		dc.b	0
		.even
l2:
		endm

USE_PCM8PP	macro	word
		.sizem	sz,cnt
		.local	l1,l2
		dc.w	$2c
		dc.w	l2-l1
l1:		dc.b	'PCM8PP'
		.if	cnt=1
		dc.b	':',word
		.endif
		dc.b	0
		.even
l2:
		endm
USE_PCM8PP_S44	macro
		.local	l1,l2
		dc.w	$2c
		dc.w	l2-l1
l1:		dc.b	'PCM8PP:S44',0
		.even
l2:
		endm
USE_PCM8PP_S48	macro
		.local	l1,l2
		dc.w	$2c
		dc.w	l2-l1
l1:		dc.b	'PCM8PP:S48',0
		.even
l2:
		endm
USE_PCM8PP_S22	macro
		.local	l1,l2
		dc.w	$2c
		dc.w	l2-l1
l1:		dc.b	'PCM8PP:S22',0
		.even
l2:
		endm
USE_ADPCM	macro	word
		.sizem	sz,cnt
		.local	l1,l2
		dc.w	$2c
		dc.w	l2-l1
l1:		dc.b	'ADPCM'
		.if	cnt=1
		dc.b	':',word
		.endif
		dc.b	0
		.even
l2:
		endm
USE_DUALPCM	macro	word
		.sizem	sz,cnt
		.local	l1,l2
		dc.w	$2c
		dc.w	l2-l1
l1:		dc.b	'DUALPCM/PCM8PP'
		.if	cnt=1
		dc.b	':',word
		.endif
		dc.b	0
		.even
l2:
		endm


PCM_PLAY_SUBADPCM	macro	addr,size
		dc.w	$2d
		dc.l	addr-offset_pos
		dc.l	size
		endm

SET_VIEWAREA_Y		macro	size
		dc.w	$38
		dc.w	4
		dc.w	size
		endm

GOTO_CALLSETTING	macro	switch,addr
		dc.w	$3d
		dc.w	switch
		dc.l	addr-offset_pos
		endm
CALLSETTING_GOTO	macro	switch,addr
		dc.w	$3d
		dc.w	switch
		dc.l	addr-offset_pos
		endm

INKEY_GOTO	macro	keycode,addr
		dc.w	$3c
		dc.w	keycode
		dc.l	addr-offset_pos
		endm

TIME_GOTO	macro	time1,time2,addr
		dc.w	$45
		dc.w	l2-l1
		dc.l	addr-offset_pos
l1:		dc.b	time1
		dc.b	0
		dc.b	time2
		dc.b	0
		.even
l2:
		endm

WEEK_GOTO	macro	week,addr
		dc.w	$46
		dc.w	week
		dc.l	addr-offset_pos
		endm

DATE_GOTO	macro	date,addr
		dc.w	$47
		dc.w	date
		dc.l	addr-offset_pos
		endm

MONTH_GOTO	macro	month,addr
		dc.w	$48
		dc.w	month
		dc.l	addr-offset_pos
		endm

YEAR_GOTO	macro	year,addr
		dc.w	$49
		dc.w	year
		dc.l	addr-offset_pos
		endm


RANDOM_GOTO	macro	addr1,addr2,addr3,addr4,addr5,addr6,addr7,addr8,addr9,addr10,addr11,addr12,addr13,addr14,addr15,addr16,addr17,addr18,addr19,addr20
		.sizem	sz,cnt
		.if cnt>0
		dc.w	$44
		dc.w	cnt
		dc.l	addr1-offset_pos
		.if cnt>1
		dc.l	addr2-offset_pos
		.endif
		.if cnt>2
		dc.l	addr3-offset_pos
		.endif
		.if cnt>3
		dc.l	addr4-offset_pos
		.endif
		.if cnt>4
		dc.l	addr5-offset_pos
		.endif
		.if cnt>5
		dc.l	addr6-offset_pos
		.endif
		.if cnt>6
		dc.l	addr7-offset_pos
		.endif
		.if cnt>7
		dc.l	addr8-offset_pos
		.endif
		.if cnt>8
		dc.l	addr9-offset_pos
		.endif
		.if cnt>9
		dc.l	addr10-offset_pos
		.endif
		.if cnt>10
		dc.l	addr11-offset_pos
		.endif
		.if cnt>11
		dc.l	addr12-offset_pos
		.endif
		.if cnt>12
		dc.l	addr13-offset_pos
		.endif
		.if cnt>13
		dc.l	addr14-offset_pos
		.endif
		.if cnt>14
		dc.l	addr15-offset_pos
		.endif
		.if cnt>15
		dc.l	addr16-offset_pos
		.endif
		.if cnt>16
		dc.l	addr17-offset_pos
		.endif
		.if cnt>17
		dc.l	addr18-offset_pos
		.endif
		.if cnt>18
		dc.l	addr19-offset_pos
		.endif
		.if cnt>19
		dc.l	addr20-offset_pos
		.endif
		.endif
		endm

KEY_MODE	macro	mode
		dc.w	$3b
		dc.w	mode
		endm

PCM_PAUSE	macro
		dc.w	$3e
		endm
PCM_UNPAUSE	macro
		dc.w	$3f
		endm

LOOP		macro	loop
		dc.w	$40
		dc.w	0
		dc.w	loop
		endm
LOOPEND		macro
		dc.w	$41
		dc.w	0
		endm

LOOP_WA		macro	loop
		dc.w	$42
		dc.w	3
		dc.w	loop
		endm
LOOPEND_WA	macro
		dc.w	$43
		dc.w	3
		endm

LOOPN		macro	num,loop
		dc.w	$40
		dc.w	num
		dc.w	loop
		endm
LOOPNEND	macro	num
		dc.w	$41
		dc.w	num
		endm

LOOPN_WA	macro	num,loop
		dc.w	$42
		dc.w	num
		dc.w	loop
		endm
LOOPNEND_WA	macro	num
		dc.w	$43
		dc.w	num
		endm


SET_FPS		macro	fps
		dc.w	$34
		dc.l	fps
		endm
SET_FPS15	macro
		dc.w	$34
		dc.l	15000			;15.0fps
		endm
SET_FPS15_X68	macro
		dc.w	$34
		dc.l	55458/4			;13.865fps 31kHz
		endm
SET_FPS20_X68	macro
		dc.w	$34
		dc.l	55458/3			;18.486fps 31kHz
		endm
SET_FPS24	macro
		dc.w	$34
		dc.l	24000			;24.0fps
		endm
SET_FPS24_NTSC	macro
		dc.w	$34
		dc.l	23976			;23.976fps
		endm
SET_FPS30	macro
		dc.w	$34
		dc.l	30000			;30.0fps
		endm
SET_FPS30_NTSC	macro
		dc.w	$34
		dc.l	29970			;29.97fps
		endm
SET_FPS30_X68	macro
		dc.w	$34
		dc.l	55458/2			;27.729fps 31kHz
		endm
SET_FPS60_X68	macro
		dc.w	$34
		dc.l	55458			;55.458fps 31kHz
		endm
SET_FPS_OFF		macro
		dc.w	$34
		dc.l	0
		endm






DRAW_DATA	macro	startp,endp
	.sizem	sz,cnt
	.if cnt=1
start=end
end=startp+1
	.else
start=startp
end=endp+1
	.endif
num=start
	.rept	end-start
DRAW Tx%num
WAIT 2
PALETTE Tp%num
CHANGE_POSITION
num=num+1
	.endm
	.endm

DRAW_DATA_RP	macro	startp,repeat_val
	.sizem	sz,cnt
	.if cnt=1
repeat=1
	.else
repeat=repeat_val
	.endif
num=startp
	.rept	repeat
DRAW Tx%num
WAIT 2
PALETTE Tp%num
CHANGE_POSITION
num=num+1
	.endm
end=num
	.endm


DRAW_SINGLEDATA	macro	startp,endp
	.sizem	sz,cnt
	.if cnt=1
start=end
end=startp
	.else
start=startp
end=endp+1
	.endif
num=start
	.rept	end-start
DRAW Tx%num
WAIT 2
PALETTE Tp%num
CHANGE_POSITION
	.endm
	.endm

DRAW_SINGLEDATA_RP	macro	startp,repeat_val
	.sizem	sz,cnt
	.if cnt=1
repeat=1
	.else
repeat=repeat_val
	.endif
num=startp
	.rept	repeat
DRAW Tx%num
WAIT 2
PALETTE Tp%num
CHANGE_POSITION
	.endm
end=num
	.endm



DRAW_DATA_INKEY	macro	startp,endp,keycode,addr
start=startp
end=endp+1
num=start
	.rept	end-start
DRAW Tx%num
WAIT 2
PALETTE Tp%num
CHANGE_POSITION
num=num+1
INKEY_GOTO keycode,addr
	.endm
	.endm

DRAW_SDATA_INKEY	macro	startp,endp,keycode,addr
start=startp
end=endp+1
num=start
	.rept	end-start
DRAW Tx%num
WAIT 2
PALETTE Tp%num
CHANGE_POSITION
INKEY_GOTO keycode,addr
	.endm
	.endm
