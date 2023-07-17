* NO_APP
RUNS_HUMAN_VERSION	equ	3
	.cpu 68000
	.include doscall.inc
	.include iocscall.inc
* X68 GCC Develop
	.file	"crtc.c"			
						
						
						
						
						
	.text					
	.align	2				
	.globl	_crtc_set_extra_mode		
						
_crtc_set_extra_mode:				
_?L2:						
						
	move.b 15237121,d0			
	btst #4,d0				
	jbeq _?L2				
_?L3:						
						
	move.b 15237121,d0			
	btst #4,d0				
	jbne _?L3				
						
	move.w #137,15204352			
						
	move.w #14,15204354			
						
	move.w #28,15204356			
						
	move.w #124,15204358			
						
	move.w #567,15204360			
						
	move.w #5,15204362			
						
	move.w #40,15204364			
						
	move.w #552,15204366			
						
	move.w #27,15204368			
						
	tst.l 4(sp)				
	jbne _?L4				
						
	move.w #790,15204392			
						
	move.w #3,15213568			
						
	move.w #47,15214080			
						
	move.w #0,15204376			
						
	move.w #0,15204378			
						
	move.w #0,15204380			
						
	move.w #0,15204382			
						
	move.w #0,15204384			
						
	move.w #0,15204386			
						
	move.w #0,15204388			
						
	move.w #0,15204390			
						
	move.l #15212544,d1			
	moveq #1,d0				
_?L6:						
						
	move.l d1,a0				
	move.w d0,(a0)+				
						
	move.w d0,(a0)				
						
	add.l #514,d0				
						
	addq.l #4,d1				
	cmp.l #65793,d0				
	jbne _?L6				
						
	rts					
_?L4:						
						
	move.w #1814,15204392			
						
	move.w #7,15213568			
						
	move.w #48,15214080			
						
	move.w #0,15204376			
						
	move.w #0,15204378			
						
	move.l #15212544,d1			
	moveq #1,d0				
	jbra _?L6				
						
						
