* NO_APP
RUNS_HUMAN_VERSION	equ	3
	.cpu 68000
	.include doscall.inc
	.include iocscall.inc
* X68 GCC Develop
	.file	"himem.c"			
						
						
						
						
						
	.text					
	.align	2				
	.globl	___himem_getsize		
						
___himem_getsize:				
	link.w a6,#-112				
						
	clr.l -104(a6)				
	clr.l -100(a6)				
	clr.l -96(a6)				
	clr.l -92(a6)				
	clr.l -88(a6)				
	clr.l -84(a6)				
	clr.l -80(a6)				
	clr.l -76(a6)				
	clr.l -72(a6)				
	clr.l -68(a6)				
	clr.l -64(a6)				
	clr.l -60(a6)				
						
	clr.l -56(a6)				
	clr.l -52(a6)				
	clr.l -48(a6)				
	clr.l -44(a6)				
	clr.l -40(a6)				
	clr.l -36(a6)				
	clr.l -32(a6)				
	clr.l -28(a6)				
	clr.l -24(a6)				
	clr.l -20(a6)				
	clr.l -16(a6)				
	clr.l -12(a6)				
	clr.l -8(a6)				
	clr.l -4(a6)				
						
	move.l #248,-112(a6)			
						
	moveq #3,d0				
	move.l d0,-108(a6)			
						
	pea -56(a6)				
	pea -112(a6)				
	jbsr _TRAP15				
	addq.l #8,sp				
						
	move.l -56(a6),d0			
	unlk a6					
	rts					
						
	.align	2				
	.globl	___himem_resize			
						
___himem_resize:				
	link.w a6,#-112				
						
	clr.l -96(a6)				
	clr.l -92(a6)				
	clr.l -88(a6)				
	clr.l -84(a6)				
	clr.l -80(a6)				
	clr.l -76(a6)				
	clr.l -72(a6)				
	clr.l -68(a6)				
	clr.l -64(a6)				
	clr.l -60(a6)				
						
	clr.l -56(a6)				
	clr.l -52(a6)				
	clr.l -48(a6)				
	clr.l -44(a6)				
	clr.l -40(a6)				
	clr.l -36(a6)				
	clr.l -32(a6)				
	clr.l -28(a6)				
	clr.l -24(a6)				
	clr.l -20(a6)				
	clr.l -16(a6)				
	clr.l -12(a6)				
	clr.l -8(a6)				
	clr.l -4(a6)				
						
	move.l #248,-112(a6)			
						
	moveq #4,d0				
	move.l d0,-108(a6)			
						
	move.l 8(a6),-104(a6)			
						
	move.l 12(a6),-100(a6)			
						
	pea -56(a6)				
	pea -112(a6)				
	jbsr _TRAP15				
	addq.l #8,sp				
						
	move.l -56(a6),d0			
	unlk a6					
	rts					
						
	.align	2				
	.globl	_himem_malloc			
						
_himem_malloc:					
	link.w a6,#-112				
						
	tst.l 12(a6)				
	jbeq _?L6				
						
	clr.l -100(a6)				
	clr.l -96(a6)				
	clr.l -92(a6)				
	clr.l -88(a6)				
	clr.l -84(a6)				
	clr.l -80(a6)				
	clr.l -76(a6)				
	clr.l -72(a6)				
	clr.l -68(a6)				
	clr.l -64(a6)				
	clr.l -60(a6)				
						
	clr.l -56(a6)				
	clr.l -52(a6)				
	clr.l -48(a6)				
	clr.l -44(a6)				
	clr.l -40(a6)				
	clr.l -36(a6)				
	clr.l -32(a6)				
	clr.l -28(a6)				
	clr.l -24(a6)				
	clr.l -20(a6)				
	clr.l -16(a6)				
	clr.l -12(a6)				
	clr.l -8(a6)				
	clr.l -4(a6)				
						
	move.l #248,-112(a6)			
						
	moveq #1,d0				
	move.l d0,-108(a6)			
						
	move.l 8(a6),-104(a6)			
						
	pea -56(a6)				
	pea -112(a6)				
	jbsr _TRAP15				
	addq.l #8,sp				
						
	tst.l -56(a6)				
	jbne _?L11				
	move.l -24(a6),d0			
_?L5:						
						
	unlk a6					
	rts					
_?L6:						
						
	move.l 8(a6),-(sp)			
	jbsr _MALLOC				
	addq.l #4,sp				
						
	cmp.l #-2130706433,d0			
	jbls _?L5				
_?L11:						
	moveq #0,d0				
						
	unlk a6					
	rts					
						
	.align	2				
	.globl	_himem_free			
						
_himem_free:					
	link.w a6,#-112				
	move.l 8(a6),d0				
						
	tst.l 12(a6)				
	jbne _?L22				
						
	tst.l d0				
	jbeq _?L14				
						
	move.l d0,8(a6)				
						
	unlk a6					
						
	jbra _MFREE				
_?L22:						
						
	clr.l -100(a6)				
	clr.l -96(a6)				
	clr.l -92(a6)				
	clr.l -88(a6)				
	clr.l -84(a6)				
	clr.l -80(a6)				
	clr.l -76(a6)				
	clr.l -72(a6)				
	clr.l -68(a6)				
	clr.l -64(a6)				
	clr.l -60(a6)				
						
	clr.l -56(a6)				
	clr.l -52(a6)				
	clr.l -48(a6)				
	clr.l -44(a6)				
	clr.l -40(a6)				
	clr.l -36(a6)				
	clr.l -32(a6)				
	clr.l -28(a6)				
	clr.l -24(a6)				
	clr.l -20(a6)				
	clr.l -16(a6)				
	clr.l -12(a6)				
	clr.l -8(a6)				
	clr.l -4(a6)				
						
	move.l #248,-112(a6)			
						
	moveq #2,d1				
	move.l d1,-108(a6)			
						
	move.l d0,-104(a6)			
						
	pea -56(a6)				
	pea -112(a6)				
	jbsr _TRAP15				
	addq.l #8,sp				
_?L14:						
						
	unlk a6					
	rts					
						
	.align	2				
	.globl	_himem_getsize			
						
_himem_getsize:					
	link.w a6,#-112				
						
	tst.l 8(a6)				
	jbne _?L28				
						
	moveq #0,d0				
						
	unlk a6					
	rts					
_?L28:						
						
	clr.l -104(a6)				
	clr.l -100(a6)				
	clr.l -96(a6)				
	clr.l -92(a6)				
	clr.l -88(a6)				
	clr.l -84(a6)				
	clr.l -80(a6)				
	clr.l -76(a6)				
	clr.l -72(a6)				
	clr.l -68(a6)				
	clr.l -64(a6)				
	clr.l -60(a6)				
						
	clr.l -56(a6)				
	clr.l -52(a6)				
	clr.l -48(a6)				
	clr.l -44(a6)				
	clr.l -40(a6)				
	clr.l -36(a6)				
	clr.l -32(a6)				
	clr.l -28(a6)				
	clr.l -24(a6)				
	clr.l -20(a6)				
	clr.l -16(a6)				
	clr.l -12(a6)				
	clr.l -8(a6)				
	clr.l -4(a6)				
						
	move.l #248,-112(a6)			
						
	moveq #3,d0				
	move.l d0,-108(a6)			
						
	pea -56(a6)				
	pea -112(a6)				
	jbsr _TRAP15				
	addq.l #8,sp				
						
	move.l -56(a6),d0			
						
	unlk a6					
	rts					
						
	.align	2				
	.globl	_himem_resize			
						
_himem_resize:					
	link.w a6,#-112				
	move.l 8(a6),d0				
	move.l 12(a6),d1			
						
	tst.l 16(a6)				
	jbne _?L33				
						
	unlk a6					
						
	jbra _SETBLOCK				
_?L33:						
						
	clr.l -96(a6)				
	clr.l -92(a6)				
	clr.l -88(a6)				
	clr.l -84(a6)				
	clr.l -80(a6)				
	clr.l -76(a6)				
	clr.l -72(a6)				
	clr.l -68(a6)				
	clr.l -64(a6)				
	clr.l -60(a6)				
						
	clr.l -56(a6)				
	clr.l -52(a6)				
	clr.l -48(a6)				
	clr.l -44(a6)				
	clr.l -40(a6)				
	clr.l -36(a6)				
	clr.l -32(a6)				
	clr.l -28(a6)				
	clr.l -24(a6)				
	clr.l -20(a6)				
	clr.l -16(a6)				
	clr.l -12(a6)				
	clr.l -8(a6)				
	clr.l -4(a6)				
						
	move.l #248,-112(a6)			
						
	moveq #4,d2				
	move.l d2,-108(a6)			
						
	move.l d0,-104(a6)			
						
	move.l d1,-100(a6)			
						
	pea -56(a6)				
	pea -112(a6)				
	jbsr _TRAP15				
	addq.l #8,sp				
						
	move.l -56(a6),d0			
						
	unlk a6					
	rts					
						
	.align	2				
	.globl	_himem_isavailable		
						
_himem_isavailable:				
						
	pea 504.w				
	jbsr _INTVCG				
	addq.l #4,sp				
						
	tst.l d0				
	jblt _?L38				
						
	add.l #-16646144,d0			
						
	cmp.l #131072,d0			
	scc d0					
	ext.w d0				
	ext.l d0				
	neg.l d0				
						
	rts					
_?L38:						
						
	moveq #0,d0				
						
	rts					
						
						
