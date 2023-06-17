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

// 1bitテストを行なう。結果は1または0で返る。
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

// 距離データを１バイト読み出す。
static __inline void LoadDistanceB( void )
{
	Distance = -256+((int)*(LZEPtr++));
//printf( "LoadDistanceB %d\n", Distance );
}

// 距離データを１ワード（２バイト）読み出す。
static __inline void LoadDistanceW( void )
{
	Distance = -65536+((int)*(LZEPtr++)<<8);
	Distance += (int)*(LZEPtr++);
//printf( "LoadDistanceW %d\n", Distance );
}

// コピーカウントデータを１バイト読み出す。
static __inline void LoadCopyCount( void )
{
	CopyCount = (int)*(LZEPtr++);
}

// (CopyPtr)から(DECODEPtr)へ1バイトコピー
static __inline void Store( void )
{
//printf( "Store\n" );
	*(DECODEPtr++) = *(LZEPtr++);
}

// (DECODEPtr-Distance)から(DECODEPtr)へ(CopyCount)+1バイトコピー
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

//	C用インターフェース。
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
//			Distance = -1;  // Cの場合は不要
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
