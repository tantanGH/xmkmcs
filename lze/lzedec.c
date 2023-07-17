//	LZE DECODE ROUTINE
//	Copyright (C)1995,2008 GORRY.

// ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

static int Distance;
static int CopyCount;
static int BitCount;
static int BitData;
static unsigned char *LZEPtr;
static unsigned char *DECODEPtr;
static unsigned char *CopyPtr;

// ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

// 1bit�e�X�g���s�Ȃ��B���ʂ�1�܂���0�ŕԂ�B
static __inline int BitTest( void )
{
	if ( (--BitCount) == 0 )
	{
		BitData = (int)*(LZEPtr++);
		BitCount = 8;
	}
	BitData <<= 1;
//printf( "BitTest %d\n", (BitData&256) != 0 );
	return ( (BitData&256) != 0 );
}

// �����f�[�^���P�o�C�g�ǂݏo���B
static __inline void LoadDistanceB( void )
{
	Distance = -256+((int)*(LZEPtr++));
//printf( "LoadDistanceB %d\n", Distance );
}

// �����f�[�^���P���[�h�i�Q�o�C�g�j�ǂݏo���B
static __inline void LoadDistanceW( void )
{
	Distance = -65536+((int)*(LZEPtr++)<<8);
	Distance += (int)*(LZEPtr++);
//printf( "LoadDistanceW %d\n", Distance );
}

// �R�s�[�J�E���g�f�[�^���P�o�C�g�ǂݏo���B
static __inline void LoadCopyCount( void )
{
	CopyCount = (int)*(LZEPtr++);
}

// (CopyPtr)����(DECODEPtr)��1�o�C�g�R�s�[
static __inline void Store( void )
{
//printf( "Store\n" );
	*(DECODEPtr++) = *(LZEPtr++);
}

// (DECODEPtr-Distance)����(DECODEPtr)��(CopyCount)+1�o�C�g�R�s�[
static __inline void Copy( void )
{
	int i;

//printf( "Copy %d, %d\n", Distance, CopyCount );
	CopyPtr = DECODEPtr + Distance;
	for ( i=0; i<CopyCount; i++ )
	{
		*(DECODEPtr++) = *(CopyPtr++);
	}
}

// ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

//	C�p�C���^�[�t�F�[�X�B
//	extern void	DECODE_LZE( unsigned char *in, unsigned char *out );

void DECODE_LZE( unsigned char *in, unsigned char *out )
{
	LZEPtr = in;
	DECODEPtr = out;
	BitCount = 1;

	Store();
	while (!0)
	{
		if ( BitTest() )
		{
			Store();
		}
		else
		{
//			Distance = -1;  // C�̏ꍇ�͕s�v
			if ( !BitTest() )
			{
				CopyCount = BitTest() << 1;
				CopyCount |= BitTest();
				LoadDistanceB();
				CopyCount += 2;
				Copy();
			}
			else
			{
				LoadDistanceW();
				CopyCount = Distance;
				Distance >>= 3;
				CopyCount &= 7;
				if ( CopyCount == 0 )
				{
					LoadCopyCount();
					if ( CopyCount == 0 ) goto decode_end;
					CopyCount++;
				}
				else
				{
					CopyCount += 2;
				}
				Copy();
			}
		}
	}
  decode_end:;
	return;
}
