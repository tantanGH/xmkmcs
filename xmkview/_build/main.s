* NO_APP
RUNS_HUMAN_VERSION	equ	3
	.cpu 68000
	.include doscall.inc
	.include iocscall.inc
* X68 GCC Develop
	.file	"main.c"			
						
						
						
						
						
	.text					
	.data					
_?LC0:						
	.dc.b $75,$73,$61,$67,$65,$3a,$20,$78
	.dc.b $6d,$6b,$76,$69,$65,$77,$20,$5b
	.dc.b $6f,$70,$74,$69,$6f,$6e,$73,$5d
	.dc.b $20,$3c,$6f,$75,$74,$70,$75,$74
	.dc.b $2d,$74,$78,$74,$3e
	.dc.b $00				
_?LC1:						
	.dc.b $6f,$70,$74,$69,$6f,$6e,$73,$3a
	.dc.b $00				
_?LC2:						
	.dc.b $20,$20,$20,$20,$20,$2d,$68,$20
	.dc.b $2e,$2e,$2e,$20,$73,$68,$6f,$77
	.dc.b $20,$68,$65,$6c,$70,$20,$6d,$65
	.dc.b $73,$73,$61,$67,$65
	.dc.b $00				
	.text					
	.align	2				
						
_show_help_message:				
	move.l a3,-(sp)				
						
	pea _?LC0				
	lea _puts,a3				
	jbsr (a3)				
						
	move.l #_?LC1,(sp)			
	jbsr (a3)				
						
	move.l #_?LC2,(sp)			
	jbsr (a3)				
	addq.l #4,sp				
						
	move.l (sp)+,a3				
	rts					
						
	.align	2				
						
_wait_vsync:					
	move.l a3,-(sp)				
	lea _B_BPEEK,a3				
_?L4:						
						
	move.l #15237121,-(sp)			
	jbsr (a3)				
	addq.l #4,sp				
						
	btst #4,d0				
	jbeq _?L4				
_?L5:						
						
	move.l #15237121,-(sp)			
	jbsr (a3)				
	addq.l #4,sp				
						
	btst #4,d0				
	jbne _?L5				
						
	move.l (sp)+,a3				
	rts					
						
	.data					
_?LC3:						
	.dc.b $65,$72,$72,$6f,$72,$3a,$20,$75
	.dc.b $6e,$6b,$6e,$6f,$77,$6e,$20,$6f
	.dc.b $70,$74,$69,$6f,$6e,$20,$28,$25
	.dc.b $73,$29,$2e,$0a
	.dc.b $00				
_?LC4:						
	.dc.b $65,$72,$72,$6f,$72,$3a,$20,$6d
	.dc.b $65,$6d,$6f,$72,$79,$20,$61,$6c
	.dc.b $6c,$6f,$63,$61,$74,$69,$6f,$6e
	.dc.b $20,$65,$72,$72,$6f,$72,$2e
	.dc.b $00				
_?LC5:						
	.dc.b $58,$4d,$4b,$56,$49,$45,$57,$20
	.dc.b $2d,$20,$4d,$41,$43,$53,$20,$54
	.dc.b $58,$20,$56,$49,$45,$57,$45,$52
	.dc.b $20,$76,$65,$72,$73,$69,$6f,$6e
	.dc.b $20,$32,$30,$32,$33,$2e,$30,$36
	.dc.b $2e,$32,$34
	.dc.b $00				
_?LC6:						
	.dc.b $5b,$45,$53,$43,$5d,$3a,$45,$58
	.dc.b $49,$54,$20,$5b,$52,$49,$47,$48
	.dc.b $54,$2f,$4c,$45,$46,$54,$5d,$3a
	.dc.b $4d,$4f,$56,$45,$20,$46,$52,$41
	.dc.b $4d,$45,$20,$5b,$53,$50,$2f,$42
	.dc.b $5d,$3a,$4a,$55,$4d,$50,$20,$46
	.dc.b $52,$41,$4d,$45
	.dc.b $00				
_?LC7:						
	.dc.b $5b,$53,$48,$49,$46,$54,$2b,$53
	.dc.b $5d,$3a,$53,$41,$56,$45,$20,$5b
	.dc.b $4d,$2f,$53,$5d,$3a,$4d,$41,$52
	.dc.b $4b,$20,$53,$54,$41,$52,$54,$20
	.dc.b $5b,$45,$5d,$3a,$4d,$41,$52,$4b
	.dc.b $20,$45,$4e,$44,$20,$5b,$43,$52
	.dc.b $5d,$3a,$41,$44,$44,$20,$53,$43
	.dc.b $45,$4e,$45
	.dc.b $00				
_?LC8:						

	.dc.b $00				
_?LC9:						
	.dc.b $53,$43,$45,$4e,$45,$20,$53,$54
	.dc.b $41,$52,$54,$20,$3d,$20,$25,$64
	.dc.b $00				
_?LC10:						
	.dc.b $53,$43,$45,$4e,$45,$20,$45,$4e
	.dc.b $44,$20,$20,$20,$3d,$20,$25,$64
	.dc.b $00				
_?LC11:						
	.dc.b $53,$43,$20,$25,$30,$35,$64,$3a
	.dc.b $25,$30,$35,$64,$0d,$0a
	.dc.b $00				
_?LC12:						
	.dc.b $77
	.dc.b $00				
_?LC13:						
	.dc.b $66,$69,$78,$5f,$70,$61,$6c,$65
	.dc.b $74,$74,$65,$20,$25,$64,$20,$25
	.dc.b $64,$0a
	.dc.b $00				
_?LC14:						
	.dc.b $53,$41,$56,$45,$44,$2e
	.dc.b $00				
	.globl	___divsi3			
_?LC15:						
	.dc.b $69,$6d,$25,$30,$32,$64,$5c,$54
	.dc.b $78,$25,$30,$35,$64
	.dc.b $00				
_?LC16:						
	.dc.b $69,$6d,$25,$30,$32,$64,$5c,$54
	.dc.b $70,$25,$30,$35,$64
	.dc.b $00				
_?LC17:						
	.dc.b $46,$52,$41,$4d,$45,$20,$4e,$4f
	.dc.b $2e,$20,$3d,$20,$25,$30,$35,$64
	.dc.b $00				
_?LC18:						
	.dc.b $72,$62
	.dc.b $00				
	.text					
	.align	2				
	.xref __main	* workaround for libc.
	.globl	_main				
						
_main:						
	lea (-1556,sp),sp			
	movem.l d3/d4/d5/d6/d7/a3/a4/a5/a6,-(sp)
	move.l 1596(sp),d4			
	move.l 1600(sp),a3			
						
	jbsr _himem_isavailable			
	move.l d0,d3				
						
	pea _funckey_original_settings		
	clr.l -(sp)				
	jbsr _FNCKEYGT				
	addq.l #8,sp				
						
	pea -1.w				
	jbsr _C_FNKMOD				
	addq.l #4,sp				
						
	move.l d0,_funckey_original_mode	
						
	moveq #1,d0				
	cmp.l d4,d0				
	jbge _?L12				
						
	moveq #1,d5				
	move.w #1,a0				
						
	lea _strlen,a4				
_?L16:						
						
	add.l a0,a0				
	add.l a0,a0				
	move.l (a3,a0.l),a5			
						
	cmp.b #45,(a5)				
	jbeq _?L111				
_?L13:						
	addq.w #1,d5				
						
	move.w d5,a0				
	cmp.l a0,d4				
	jbgt _?L16				
						
	move.l a5,68(sp)			
	clr.l -(sp)				
	move.l #98304,-(sp)			
	lea _himem_malloc,a3			
	jbsr (a3)				
	addq.l #8,sp				
	move.l d0,36(sp)			
						
	jbeq _?L18				
						
	clr.l -(sp)				
	pea 1024.w				
	jbsr (a3)				
	addq.l #8,sp				
	move.l d0,a5				
						
	tst.l d0				
	jbeq _?L18				
						
	tst.l d3				
	sne d0					
	ext.w d0				
	ext.l d0				
	neg.l d0				
	move.l d0,72(sp)			
						
	move.l d0,-(sp)				
	move.l #196608,-(sp)			
	jbsr (a3)				
	addq.l #8,sp				
	move.l d0,40(sp)			
						
	jbeq _?L18				
						
	move.l #196608,-(sp)			
	clr.l -(sp)				
	move.l d0,-(sp)				
	jbsr _memset				
	lea (12,sp),sp				
						
	move.l 72(sp),-(sp)			
	move.l #64000,-(sp)			
	jbsr (a3)				
	addq.l #8,sp				
	move.l d0,56(sp)			
						
	move.l #64000,-(sp)			
	clr.l -(sp)				
	move.l d0,-(sp)				
	jbsr _memset				
						
	addq.l #8,sp				
	moveq #12,d0				
	move.l d0,(sp)				
	jbsr _CRTMOD				
	addq.l #4,sp				
						
	jbsr _G_CLR_ON				
						
	jbsr _C_CUROFF				
						
	pea 3.w					
	jbsr _C_FNKMOD				
						
	moveq #16,d1				
	move.l d1,(sp)				
	pea 14.w				
	pea 64.w				
	pea 392.w				
	jbsr _B_CONSOL				
	lea (16,sp),sp				
						
	move.l sp,d3				
	add.l #880,d3				
	pea 712.w				
	clr.l -(sp)				
	move.l d3,-(sp)				
	jbsr _memset				
	lea (12,sp),sp				
						
	move.b #5,1520(sp)			
						
	move.b #21,1526(sp)			
						
	move.b #7,1538(sp)			
						
	move.b #1,1544(sp)			
						
	move.b #19,1550(sp)			
						
	move.b #4,1556(sp)			
						
	move.b #6,1562(sp)			
						
	move.l d3,-(sp)				
	clr.l -(sp)				
	jbsr _FNCKEYST				
						
	addq.l #4,sp				
	move.l #_?LC5,(sp)			
	pea 64.w				
	clr.l -(sp)				
	clr.l -(sp)				
	pea 6.w					
	jbsr _B_PUTMES				
						
	lea (16,sp),sp				
	move.l #_?LC6,(sp)			
	pea 64.w				
	pea 29.w				
	clr.l -(sp)				
	pea 1.w					
	jbsr _B_PUTMES				
						
	lea (16,sp),sp				
	move.l #_?LC7,(sp)			
	pea 64.w				
	pea 30.w				
	clr.l -(sp)				
	pea 1.w					
	jbsr _B_PUTMES				
	lea (20,sp),sp				
						
	moveq #-1,d1				
	move.l d1,44(sp)			
	move.l d1,48(sp)			
						
	move.l d1,60(sp)			
						
	move.w #10000,a6			
						
	clr.w 66(sp)				
						
	move.w #-1,64(sp)			
	move.l 36(sp),d1			
	add.l #98688,d1				
	move.l d1,84(sp)			
	move.l 36(sp),d7			
	add.l #65792,d7				
_?L19:						
						
	jbsr _B_KEYSNS				
						
	tst.l d0				
	jbeq _?L36				
						
	jbsr _B_KEYINP				
						
	move.l d0,d3				
	asr.l #8,d3				
						
	jbsr _B_SFTSNS				
						
	btst #0,d0				
	jbeq _?L22				
						
	add.w #256,d3				
_?L22:						
						
	btst #1,d0				
	jbeq _?L23				
						
	add.w #512,d3				
_?L23:						
						
	cmp.w #1,d3				
	jbeq _?L24				
	cmp.w #78,d3				
	jbgt _?L25				
	cmp.w #16,d3				
	jble _?L36				
	move.w d3,d0				
	add.w #-17,d0				
	cmp.w #61,d0				
	jbhi _?L36				
	and.l #65535,d0				
	add.l d0,d0				
	move.w _?L28(pc,d0.l),d0		
	jmp 2(pc,d0.w)				
	.align 2,0x284c				
						
_?L28:						
	.dc.w _?L24-_?L28			
	.dc.w _?L36-_?L28			
	.dc.w _?L34-_?L28			
	.dc.w _?L36-_?L28			
	.dc.w _?L36-_?L28			
	.dc.w _?L36-_?L28			
	.dc.w _?L36-_?L28			
	.dc.w _?L36-_?L28			
	.dc.w _?L36-_?L28			
	.dc.w _?L36-_?L28			
	.dc.w _?L36-_?L28			
	.dc.w _?L36-_?L28			
	.dc.w _?L27-_?L28			
	.dc.w _?L36-_?L28			
	.dc.w _?L32-_?L28			
	.dc.w _?L36-_?L28			
	.dc.w _?L36-_?L28			
	.dc.w _?L36-_?L28			
	.dc.w _?L36-_?L28			
	.dc.w _?L36-_?L28			
	.dc.w _?L36-_?L28			
	.dc.w _?L36-_?L28			
	.dc.w _?L36-_?L28			
	.dc.w _?L36-_?L28			
	.dc.w _?L36-_?L28			
	.dc.w _?L36-_?L28			
	.dc.w _?L36-_?L28			
	.dc.w _?L36-_?L28			
	.dc.w _?L36-_?L28			
	.dc.w _?L33-_?L28			
	.dc.w _?L36-_?L28			
	.dc.w _?L32-_?L28			
	.dc.w _?L36-_?L28			
	.dc.w _?L36-_?L28			
	.dc.w _?L36-_?L28			
	.dc.w _?L36-_?L28			
	.dc.w _?L31-_?L28			
	.dc.w _?L36-_?L28			
	.dc.w _?L36-_?L28			
	.dc.w _?L36-_?L28			
	.dc.w _?L36-_?L28			
	.dc.w _?L36-_?L28			
	.dc.w _?L30-_?L28			
	.dc.w _?L36-_?L28			
	.dc.w _?L29-_?L28			
	.dc.w _?L36-_?L28			
	.dc.w _?L36-_?L28			
	.dc.w _?L36-_?L28			
	.dc.w _?L36-_?L28			
	.dc.w _?L36-_?L28			
	.dc.w _?L36-_?L28			
	.dc.w _?L36-_?L28			
	.dc.w _?L36-_?L28			
	.dc.w _?L36-_?L28			
	.dc.w _?L36-_?L28			
	.dc.w _?L36-_?L28			
	.dc.w _?L36-_?L28			
	.dc.w _?L36-_?L28			
	.dc.w _?L36-_?L28			
	.dc.w _?L36-_?L28			
	.dc.w _?L36-_?L28			
	.dc.w _?L27-_?L28			
_?L111:						
						
	move.l a5,-(sp)				
	jbsr (a4)				
	addq.l #4,sp				
						
	moveq #1,d1				
	cmp.l d0,d1				
	jbcc _?L13				
						
	move.l a5,68(sp)			
	cmp.b #104,1(a5)			
	jbeq _?L12				
						
	move.l 68(sp),-(sp)			
	pea _?LC3				
	jbsr _printf				
	addq.l #8,sp				
						
	moveq #-1,d0				
	movem.l (sp)+,d3/d4/d5/d6/d7/a3/a4/a5/a6
	lea (1556,sp),sp			
	rts					
_?L12:						
						
	jbsr _show_help_message			
						
	moveq #-1,d0				
	movem.l (sp)+,d3/d4/d5/d6/d7/a3/a4/a5/a6
	lea (1556,sp),sp			
	rts					
_?L29:						
						
	addq.l #1,a6				
_?L36:						
						
	cmp.l 60(sp),a6				
	jbne _?L112				
_?L42:						
						
	move.l 60(sp),a6			
	jbra _?L19				
_?L112:						
						
	pea 500.w				
	pea -10000(a6)				
	jbsr ___divsi3				
	addq.l #8,sp				
						
	move.w d0,a3				
	move.l a6,-(sp)				
	move.l a3,-(sp)				
	pea _?LC15				
	pea 380(sp)				
	jbsr _sprintf				
						
	lea (12,sp),sp				
	move.l a6,(sp)				
	move.l a3,-(sp)				
	pea _?LC16				
	pea 636(sp)				
	jbsr _sprintf				
						
	lea (12,sp),sp				
	move.l a6,(sp)				
	pea _?LC17				
	lea (120,sp),a4				
	move.l a4,-(sp)				
	jbsr _sprintf				
						
	addq.l #8,sp				
	move.l #_?LC18,(sp)			
	pea 372(sp)				
	jbsr _fopen				
	addq.l #8,sp				
	move.l d0,d4				
						
	pea _?LC18				
	pea 628(sp)				
	jbsr _fopen				
	addq.l #8,sp				
	move.l d0,d5				
						
	tst.l d4				
	jbeq _?L43				
						
	tst.l d0				
	jbeq _?L44				
						
	move.w 64(sp),d0			
	subq.w #2,d0				
						
	cmp.w #1,d0				
	jbhi _?L113				
	lea _wait_vsync,a3			
	moveq #96,d3				
	add.l sp,d3				
						
	cmp.w #3,64(sp)				
	jbeq _?L47				
	move.l d4,-(sp)				
	move.l #65536,-(sp)			
	pea 1.w					
	move.l 48(sp),-(sp)			
	move.l #_fread,d6			
	move.l d6,a0				
	jbsr (a0)				
						
	lea (12,sp),sp				
	move.l d5,(sp)				
	pea 256.w				
	pea 2.w					
	move.l a5,-(sp)				
	move.l d6,a0				
	jbsr (a0)				
	lea (16,sp),sp				
	move.l 40(sp),d2			
	move.l 36(sp),d1			
	add.l #256,d1				
	move.l d2,d6				
	add.l #131072,d6			
_?L69:						
	move.l d1,a0				
	lea (-256,a0),a0			
						
	move.l d2,a1				
_?L52:						
						
	moveq #0,d0				
	move.b (a0)+,d0				
	add.l d0,d0				
						
	move.w (a5,d0.l),(a1)+			
						
	cmp.l d1,a0				
	jbne _?L52				
						
	add.l #512,d2				
	add.l #256,d1				
	cmp.l d6,d2				
	jbne _?L69				
						
	move.w #16,96(sp)			
	move.w #48,98(sp)			
	move.w #271,100(sp)			
	move.w #303,102(sp)			
	move.l 40(sp),104(sp)			
						
	move.l 40(sp),d1			
	add.l #131071,d1			
	move.l d1,108(sp)			
						
	jbsr (a3)				
						
	move.l d3,-(sp)				
	move.l #_PUTGRM,56(sp)			
	lea _PUTGRM,a0				
	jbsr (a0)				
						
	move.l a4,(sp)				
	pea 18.w				
	pea 2.w					
	clr.l -(sp)				
	pea 1.w					
	jbsr _B_PUTMES				
						
	lea (16,sp),sp				
	move.l d4,(sp)				
	lea _fclose,a4				
	jbsr (a4)				
	addq.l #4,sp				
	move.w #2,64(sp)			
						
	move.l d5,-(sp)				
	jbsr (a4)				
	addq.l #4,sp				
	move.l a6,60(sp)			
_?L55:						
	move.l 60(sp),d1			
	add.l #-10002,d1			
	move.l d1,76(sp)			
	move.l 56(sp),d4			
	move.l d4,d1				
	add.l #1000,d1				
	move.l d1,80(sp)			
						
	move.l a3,88(sp)			
	move.l a5,a3				
	move.l d3,92(sp)			
	move.l 84(sp),d3			
_?L68:						
						
	pea 500.w				
	move.l 80(sp),-(sp)			
	jbsr ___divsi3				
	addq.l #8,sp				
						
	move.w d0,a4				
	move.l 76(sp),d5			
	add.l #10000,d5				
	move.l d5,-(sp)				
	move.l a4,-(sp)				
	pea _?LC15				
	pea 380(sp)				
	jbsr _sprintf				
						
	lea (12,sp),sp				
	move.l d5,(sp)				
	move.l a4,-(sp)				
	pea _?LC16				
	pea 636(sp)				
	jbsr _sprintf				
						
	lea (12,sp),sp				
	move.l #_?LC18,(sp)			
	pea 372(sp)				
	jbsr _fopen				
	addq.l #8,sp				
	move.l d0,d5				
						
	pea _?LC18				
	pea 628(sp)				
	jbsr _fopen				
	addq.l #8,sp				
	move.l d0,a6				
						
	tst.l d5				
	jbeq _?L74				
						
	tst.l d0				
	jbeq _?L74				
						
	cmp.w #3,64(sp)				
	jbeq _?L57				
						
	move.l d5,-(sp)				
	move.l #65536,-(sp)			
	pea 1.w					
	move.l 48(sp),-(sp)			
	jbsr _fread				
						
	lea (12,sp),sp				
	move.l a6,(sp)				
	pea 256.w				
	pea 2.w					
	move.l a3,-(sp)				
	jbsr _fread				
	lea (16,sp),sp				
	move.l 36(sp),d1			
	add.l #256,d1				
	move.l d4,d2				
_?L58:						
	move.l d1,a0				
	lea (-256,a0),a0			
						
	move.l d2,a1				
_?L64:						
						
	moveq #0,d0				
	move.b (a0),d0				
	add.l d0,d0				
						
	move.w (a3,d0.l),(a1)+			
						
	addq.l #4,a0				
	cmp.l a0,d1				
	jbne _?L64				
						
	add.l #1000,d2				
	add.l #1024,d1				
	cmp.l d7,d1				
	jbne _?L58				
_?L61:						
						
	move.l d5,-(sp)				
	lea _fclose,a4				
	jbsr (a4)				
	addq.l #4,sp				
						
	move.l a6,-(sp)				
	jbsr (a4)				
	addq.l #4,sp				
_?L67:						
						
	addq.l #1,76(sp)			
	add.l #200,d4				
	cmp.l 80(sp),d4				
	jbne _?L68				
						
	move.l a3,a5				
	move.l 88(sp),a3			
	move.l 92(sp),d3			
	jbsr (a3)				
						
	move.w #6,96(sp)			
	move.w #316,98(sp)			
	move.w #505,100(sp)			
	move.w #379,102(sp)			
	move.l 56(sp),104(sp)			
						
	move.l 56(sp),d1			
	add.l #65535,d1				
	move.l d1,108(sp)			
						
	move.l d3,-(sp)				
	move.l 56(sp),a0			
	jbsr (a0)				
	addq.l #4,sp				
						
	move.l 60(sp),a6			
	jbra _?L19				
_?L25:						
	cmp.w #287,d3				
	jbne _?L36				
						
	tst.w 66(sp)				
	jble _?L36				
						
	pea _?LC12				
	move.l 72(sp),-(sp)			
	jbsr _fopen				
	addq.l #8,sp				
	move.l d0,d3				
	lea _scenes,a4				
						
	clr.w d4				
	lea _fprintf,a3				
_?L40:						
						
	move.l 4(a4),d0				
	add.l #-10000,d0			
	move.l d0,-(sp)				
	move.l (a4),d1				
	add.l #-10000,d1			
	move.l d1,-(sp)				
	pea _?LC13				
	move.l d3,-(sp)				
	jbsr (a3)				
	lea (16,sp),sp				
	addq.w #1,d4				
						
	addq.l #8,a4				
	cmp.w 66(sp),d4				
	jbne _?L40				
						
	move.l d3,-(sp)				
	jbsr _fclose				
						
	move.l #_?LC14,(sp)			
	pea 20.w				
	pea 27.w				
	clr.l -(sp)				
	pea 3.w					
	jbsr _B_PUTMES				
	lea (20,sp),sp				
						
	lea _ONTIME,a4				
	jbsr (a4)				
	move.w #50,a3				
	add.l d0,a3				
_?L41:						
						
	jbsr (a4)				
						
	cmp.l a3,d0				
	jbcs _?L41				
						
	pea _?LC8				
	pea 20.w				
	pea 27.w				
	clr.l -(sp)				
	pea 3.w					
	jbsr _B_PUTMES				
	lea (20,sp),sp				
						
	cmp.l 60(sp),a6				
	jbeq _?L42				
	jbra _?L112				
_?L30:						
						
	cmp.w #0,a6				
	jble _?L36				
						
	subq.l #1,a6				
						
	cmp.l 60(sp),a6				
	jbeq _?L42				
	jbra _?L112				
_?L31:						
						
	lea (20,a6),a6				
						
	cmp.l 60(sp),a6				
	jbeq _?L42				
	jbra _?L112				
_?L24:						
						
	clr.l -(sp)				
	move.l 40(sp),-(sp)			
	lea _himem_free,a3			
	jbsr (a3)				
						
	addq.l #4,sp				
	clr.l (sp)				
	move.l a5,-(sp)				
	jbsr (a3)				
	addq.l #8,sp				
						
	move.l 72(sp),-(sp)			
	move.l 44(sp),-(sp)			
	jbsr (a3)				
	addq.l #8,sp				
						
	move.l 72(sp),-(sp)			
	move.l 60(sp),-(sp)			
	jbsr (a3)				
	addq.l #8,sp				
						
	pea 16.w				
	jbsr _CRTMOD				
	addq.l #4,sp				
						
	jbsr _G_CLR_ON				
						
	jbsr _C_CURON				
						
	pea _funckey_original_settings		
	clr.l -(sp)				
	jbsr _FNCKEYST				
						
	addq.l #4,sp				
	move.l _funckey_original_mode,(sp)	
	jbsr _C_FNKMOD				
	addq.l #4,sp				
_?L15:						
						
	moveq #-1,d0				
	movem.l (sp)+,d3/d4/d5/d6/d7/a3/a4/a5/a6
	lea (1556,sp),sp			
	rts					
_?L18:						
						
	pea _?LC4				
	jbsr _puts				
	addq.l #4,sp				
						
	moveq #-1,d0				
	movem.l (sp)+,d3/d4/d5/d6/d7/a3/a4/a5/a6
	lea (1556,sp),sp			
	rts					
_?L33:						
						
	moveq #20,d0				
	cmp.l a6,d0				
	jbge _?L36				
						
	lea (-20,a6),a6				
						
	cmp.l 60(sp),a6				
	jbeq _?L42				
	jbra _?L112				
_?L32:						
						
	cmp.l 48(sp),a6				
	jbeq _?L114				
						
	move.l a6,-(sp)				
	pea _?LC9				
	moveq #120,d3				
	add.l sp,d3				
	move.l d3,-(sp)				
	jbsr _sprintf				
						
	addq.l #8,sp				
	move.l d3,(sp)				
	pea 20.w				
	pea 25.w				
	clr.l -(sp)				
	pea 3.w					
	jbsr _B_PUTMES				
	lea (20,sp),sp				
						
	move.l a6,48(sp)			
						
	cmp.l 60(sp),a6				
	jbeq _?L42				
	jbra _?L112				
_?L27:						
						
	tst.l 48(sp)				
	jblt _?L36				
						
	move.l 44(sp),a0			
	cmp.l 48(sp),a0				
	jble _?L36				
						
	move.w 66(sp),d0			
	ext.l d0				
						
	lsl.l #3,d0				
	move.l d0,a1				
	add.l #_scenes,a1			
						
	move.l 48(sp),(a1)			
	move.l a0,4(a1)				
						
	move.l a0,-(sp)				
	lea _scenes,a1				
	move.l (a1,d0.l),-(sp)			
	pea _?LC11				
	moveq #124,d3				
	add.l sp,d3				
	move.l d3,-(sp)				
	jbsr _sprintf				
						
	lea (12,sp),sp				
	move.l d3,(sp)				
	jbsr _B_PRINT				
						
	addq.w #1,70(sp)			
						
	move.l #_?LC8,(sp)			
	pea 20.w				
	pea 25.w				
	clr.l -(sp)				
	pea 3.w					
	jbsr _B_PUTMES				
						
	lea (16,sp),sp				
	move.l #_?LC8,(sp)			
	pea 20.w				
	pea 26.w				
	clr.l -(sp)				
	pea 3.w					
	jbsr _B_PUTMES				
	lea (20,sp),sp				
						
	moveq #-1,d1				
	move.l d1,44(sp)			
						
	move.l d1,48(sp)			
						
	cmp.l 60(sp),a6				
	jbeq _?L42				
	jbra _?L112				
_?L34:						
						
	cmp.l 44(sp),a6				
	jbeq _?L115				
						
	move.l a6,-(sp)				
	pea _?LC10				
	moveq #120,d3				
	add.l sp,d3				
	move.l d3,-(sp)				
	jbsr _sprintf				
						
	addq.l #8,sp				
	move.l d3,(sp)				
	pea 20.w				
	pea 26.w				
	clr.l -(sp)				
	pea 3.w					
	jbsr _B_PUTMES				
	lea (20,sp),sp				
						
	move.l a6,44(sp)			
						
	cmp.l 60(sp),a6				
	jbeq _?L42				
	jbra _?L112				
_?L113:						
						
	pea 2.w					
	clr.l -(sp)				
	move.l d4,-(sp)				
	lea _fseek,a3				
	jbsr (a3)				
						
	addq.l #8,sp				
	move.l d4,(sp)				
	jbsr _ftell				
	move.l d0,d3				
						
	clr.l (sp)				
	clr.l -(sp)				
	move.l d4,-(sp)				
	jbsr (a3)				
	lea (12,sp),sp				
						
	lea _wait_vsync,a3			
						
	cmp.l #65536,d3				
	jbls _?L46				
						
	jbsr (a3)				
						
	move.w #202,96(sp)			
	move.w #382,98(sp)			
	move.w #305,100(sp)			
	move.w #383,102(sp)			
	move.w #14798,104(sp)			
						
	moveq #96,d3				
	add.l sp,d3				
	move.l d3,-(sp)				
	jbsr _FILL				
	addq.l #4,sp				
_?L47:						
						
	move.l d4,-(sp)				
	move.l #98304,-(sp)			
	pea 1.w					
	move.l 48(sp),-(sp)			
	move.l #_fread,d6			
	move.l d6,a0				
	jbsr (a0)				
						
	lea (12,sp),sp				
	move.l d5,(sp)				
	pea 256.w				
	pea 2.w					
	move.l a5,-(sp)				
	move.l d6,a0				
	jbsr (a0)				
	lea (16,sp),sp				
	move.l 40(sp),d2			
	move.l 36(sp),d1			
	add.l #384,d1				
	move.l d2,d6				
	add.l #196608,d6			
_?L70:						
	move.l d1,a0				
	lea (-384,a0),a0			
						
	move.l d2,a1				
_?L49:						
						
	moveq #0,d0				
	move.b (a0)+,d0				
	add.l d0,d0				
						
	move.w (a5,d0.l),(a1)+			
						
	cmp.l d1,a0				
	jbne _?L49				
						
	add.l #768,d2				
	add.l #384,d1				
	cmp.l d6,d2				
	jbne _?L70				
						
	clr.w 96(sp)				
	move.w #48,98(sp)			
	move.w #383,100(sp)			
	move.w #303,102(sp)			
	move.l 40(sp),104(sp)			
						
	move.l 40(sp),d1			
	add.l #196607,d1			
	move.l d1,108(sp)			
						
	jbsr (a3)				
						
	move.l d3,-(sp)				
	move.l #_PUTGRM,56(sp)			
	lea _PUTGRM,a0				
	jbsr (a0)				
						
	move.l a4,(sp)				
	pea 18.w				
	pea 2.w					
	clr.l -(sp)				
	pea 1.w					
	jbsr _B_PUTMES				
						
	lea (16,sp),sp				
	move.l d4,(sp)				
	lea _fclose,a4				
	jbsr (a4)				
	addq.l #4,sp				
	move.w #3,64(sp)			
						
	move.l d5,-(sp)				
	jbsr (a4)				
	addq.l #4,sp				
	move.l a6,60(sp)			
	jbra _?L55				
_?L57:						
						
	move.l d5,-(sp)				
	move.l #98304,-(sp)			
	pea 1.w					
	move.l 48(sp),-(sp)			
	jbsr _fread				
						
	lea (12,sp),sp				
	move.l a6,(sp)				
	pea 256.w				
	pea 2.w					
	move.l a3,-(sp)				
	jbsr _fread				
	lea (16,sp),sp				
	move.l 36(sp),d1			
	add.l #384,d1				
	move.l d4,d2				
	move.l d1,a0				
	lea (-384,a0),a0			
						
	move.l d2,a1				
_?L59:						
						
	moveq #0,d0				
	move.b (a0),d0				
	add.l d0,d0				
						
	move.w (a3,d0.l),(a1)+			
						
	addq.l #4,a0				
	cmp.l a0,d1				
	jbne _?L59				
						
	add.l #1000,d2				
	add.l #1536,d1				
	cmp.l d1,d3				
	jbeq _?L61				
	move.l d1,a0				
	lea (-384,a0),a0			
						
	move.l d2,a1				
	jbra _?L59				
_?L74:						
	move.l d4,a5				
	move.l #64000,a4			
	add.l a5,a4				
						
	moveq #63,d6				
	not.b d6				
_?L65:						
						
	move.l d6,-(sp)				
	clr.l -(sp)				
	move.l a5,-(sp)				
	jbsr _memset				
	lea (12,sp),sp				
						
	lea (1000,a5),a5			
	cmp.l a4,a5				
	jbne _?L65				
						
	tst.l d5				
	jbne _?L116				
_?L63:						
						
	cmp.w #0,a6				
	jbeq _?L67				
	lea _fclose,a4				
						
	move.l a6,-(sp)				
	jbsr (a4)				
	addq.l #4,sp				
	jbra _?L67				
_?L44:						
						
	move.l d4,-(sp)				
	jbsr _fclose				
	addq.l #4,sp				
	lea _wait_vsync,a3			
	moveq #96,d3				
	add.l sp,d3				
	move.l #_PUTGRM,52(sp)			
	move.l 60(sp),d1			
	add.l #-10002,d1			
	move.l d1,76(sp)			
	move.l 56(sp),d4			
	move.l d4,d1				
	add.l #1000,d1				
	move.l d1,80(sp)			
						
	move.l a3,88(sp)			
	move.l a5,a3				
	move.l d3,92(sp)			
	move.l 84(sp),d3			
	jbra _?L68				
_?L43:						
						
	tst.l d0				
	jbne _?L72				
	lea _wait_vsync,a3			
	moveq #96,d3				
	add.l sp,d3				
	move.l #_PUTGRM,52(sp)			
	move.l 60(sp),d1			
	add.l #-10002,d1			
	move.l d1,76(sp)			
	move.l 56(sp),d4			
	move.l d4,d1				
	add.l #1000,d1				
	move.l d1,80(sp)			
						
	move.l a3,88(sp)			
	move.l a5,a3				
	move.l d3,92(sp)			
	move.l 84(sp),d3			
	jbra _?L68				
_?L46:						
						
	jbsr (a3)				
						
	move.w #202,96(sp)			
	move.w #382,98(sp)			
	move.w #273,100(sp)			
	move.w #383,102(sp)			
	move.w #14798,104(sp)			
						
	moveq #96,d3				
	add.l sp,d3				
	move.l d3,-(sp)				
	jbsr _FILL				
	addq.l #4,sp				
						
	move.l d4,-(sp)				
	move.l #65536,-(sp)			
	pea 1.w					
	move.l 48(sp),-(sp)			
	move.l #_fread,d6			
	move.l d6,a0				
	jbsr (a0)				
						
	lea (12,sp),sp				
	move.l d5,(sp)				
	pea 256.w				
	pea 2.w					
	move.l a5,-(sp)				
	move.l d6,a0				
	jbsr (a0)				
	lea (16,sp),sp				
	move.l 40(sp),d2			
	move.l 36(sp),d1			
	add.l #256,d1				
	move.l d2,d6				
	add.l #131072,d6			
	jbra _?L69				
_?L115:						
						
	pea _?LC8				
	pea 20.w				
	pea 26.w				
	clr.l -(sp)				
	pea 3.w					
	jbsr _B_PUTMES				
	lea (20,sp),sp				
						
	moveq #-1,d1				
	move.l d1,44(sp)			
						
	cmp.l 60(sp),a6				
	jbeq _?L42				
	jbra _?L112				
_?L114:						
						
	pea _?LC8				
	pea 20.w				
	pea 25.w				
	clr.l -(sp)				
	pea 3.w					
	jbsr _B_PUTMES				
	lea (20,sp),sp				
						
	moveq #-1,d1				
	move.l d1,48(sp)			
						
	cmp.l 60(sp),a6				
	jbeq _?L42				
	jbra _?L112				
_?L72:						
						
	move.l 60(sp),a6			
	lea _fclose,a4				
	lea _wait_vsync,a3			
	moveq #96,d3				
	add.l sp,d3				
	move.l #_PUTGRM,52(sp)			
						
	move.l d5,-(sp)				
	jbsr (a4)				
	addq.l #4,sp				
	move.l a6,60(sp)			
	jbra _?L55				
_?L116:						
						
	move.l d5,-(sp)				
	jbsr _fclose				
	addq.l #4,sp				
	jbra _?L63				
						
						
	.align 2	* workaround for 3 args .comm directive.
	.comm	_funckey_original_mode,4	
						
	.comm	_funckey_original_settings,712	
						
	.align 2	* workaround for 3 args .comm directive.
	.comm	_scenes,8192			
						
