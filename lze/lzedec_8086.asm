;		LZE DECODE ROUTINE
;		Copyright (C)1995,2008 GORRY.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


Distance	equ	AX
DistanceL	equ	AL
DistanceH	equ	AH
CopyCount	equ	CX
CopyCountL	equ	CL
BitCount	equ	DH
BitData		equ	DL
LZEPtr		equ	BX
DECODEPtr	equ	DI
CopyPtr		equ	SI


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;		1bitテストを行なう。結果はCyに返る。
BitTest		macro
		local	lbl1
		dec	BitCount
		jnz	lbl1
		mov	BitData,ds:[LZEPtr]
		inc	LZEPtr
		mov	BitCount,8
lbl1:
		add	BitData,BitData
		endm

;		距離データを１バイト読み出す。
LoadDistanceB	macro
		mov	DistanceL,ds:[LZEPtr]
		inc	LZEPtr
		endm

;		距離データを１ワード読み出す。
LoadDistanceW	macro
		mov	DistanceH,ds:[LZEPtr]
		inc	LZEPtr
		mov	DistanceL,ds:[LZEPtr]
		inc	LZEPtr
		endm

;		コピーカウントデータを１バイト読み出す。
LoadCopyCount	macro
		mov	CopyCountL,ds:[LZEPtr]
		inc	LZEPtr
		endm

;		(CopyPtr)から(DECODEPtr)へ1バイトコピー
Store		macro
		mov	al,ds:[LZEPtr]
		inc	LZEPtr
		stosb
		endm

;		(DECODEPtr-Distance)から(DECODEPtr)へ(CopyCount)+1バイトコピー
Copy		macro
		local	l1
		mov	CopyPtr,DECODEPtr
		add	CopyPtr,Distance
		inc	CopyCount
		mov	ax,es
		mov	ds,ax
		rep	movsb
		mov	ds,bp
		endm


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


CODE	SEGMENT
	ASSUME	CS:CODE


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


DECODE_LZE	PROC	FAR
;		LZEデータをデコードする。
;		in	ds:si	デコード前データへのポインタ
;			es:di	デコード後データへのポインタ

		push	ax
		push	bx
		push	cx
		push	dx
		push	si
		push	di
		push	bp

		mov	LZEPtr,si
		mov	bp,ds
		cld
		mov	BitCount,1

DECODE_LZE_lp0:
DECODE_LZE_1:
		Store

DECODE_LZE_lp1:
		BitTest
		jc	DECODE_LZE_1

DECODE_LZE_0:
		xor	Distance,Distance
		dec	Distance
		BitTest
		jc	DECODE_LZE_01
DECODE_LZE_00:
		xor	CopyCount,CopyCount
		BitTest
		adc	CopyCount,CopyCount
		BitTest
		adc	CopyCount,CopyCount
		LoadDistanceB
DECODE_LZE_00_1:
		inc	CopyCount
DECODE_LZE_00_2:
		Copy
		jmp	short DECODE_LZE_lp1

DECODE_LZE_01:
		LoadDistanceW
		mov	CopyCount,Distance
		shr	Distance,1
		shr	Distance,1
		shr	Distance,1
		or	DistanceH,0e0h
		and	CopyCount,7
		jnz	DECODE_LZE_00_1
		LoadCopyCount
		or	CopyCountL,CopyCountL
		jnz	DECODE_LZE_00_2

DECODE_LZE_e:
		pop	bp
		pop	di
		pop	si
		pop	dx
		pop	cx
		pop	bx
		pop	ax
		ret

DECODE_LZE	ENDP


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


		PUBLIC	_DECODE_LZE
_DECODE_LZE	PROC	FAR
;		C用インターフェース。
;		extern void	DECODE_LZE( unsigned char *in, unsigned char *out );

		push	bp
		mov	bp,sp
		push	si
		push	di
		push	ds
		push	es

		mov	si,6[bp]
		mov	ax,8[bp]
		mov	ds,ax
		mov	di,10[bp]
		mov	ax,12[bp]
		mov	es,ax
		call	DECODE_LZE

		pop	es
		pop	ds
		pop	di
		pop	si
		mov	sp,bp
		pop	bp
		ret

_DECODE_LZE	ENDP


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


CODE		ENDS


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


		END


