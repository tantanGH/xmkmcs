// LZED
// Copyright (C)1995,2008 GORRY.
/********************************************************************************/

#include	<stdio.h>
#include	<stdlib.h>
#include	<ctype.h>
#include	<limits.h>

extern void	DECODE_LZE( unsigned char *in, unsigned char *out );

unsigned long int	insize;
unsigned char	*in;
FILE	*infile;

unsigned long int	outsize;
unsigned char	*out;
FILE	*outfile;

/********************************************************************************/

void	error( char *mes )
{
	fputs( mes, stderr );
	fputs( "\n", stderr );
	exit(EXIT_FAILURE);
}

/********************************************************************************/

void	Usage( void )
{
	fprintf( stderr, "lzed infile outfile\n" );
	exit( EXIT_FAILURE );
}


/********************************************************************************/

int	main( int argc, char *argv[] )
{
#ifdef	__HUMAN68K__
	allmem();
#endif

	if ( argc != 3 ) Usage();
	infile = fopen( argv[1], "rb" );
	if ( infile == NULL ) error( "Error: Input File Open" );
	outfile = fopen( argv[2], "wb" );
	if ( outfile == NULL ) error( "Error: Output File Open" );

	fseek( infile, 0L, SEEK_END );
	insize = ftell( infile );
	if ( insize > UINT_MAX ) error( "Error: Input File overflow" );
	rewind( infile );
	in = malloc( (size_t)insize );
	if ( in == NULL ) error( "Error: Input File overflow" );
	if ( (size_t)insize != fread( in, 1, (size_t)insize, infile ) ) error( "Error: Read Input File" );

	outsize  = (((unsigned long)*(in++)) << 24 );
	outsize |= (((unsigned long)*(in++)) << 16 );
	outsize |= (((unsigned long)*(in++)) <<  8 );
	outsize |= (((unsigned long)*(in++)) <<  0 );
	if ( outsize > UINT_MAX ) error( "Error: Output File overflow" );
	printf( " In/Out: %8lu/%8lu\n", insize, outsize );
	out = malloc( (size_t)outsize );
	if ( out == NULL ) error( "Error: Output File overflow" );

	DECODE_LZE( in, out );
	if ( (size_t)outsize != fwrite( out, 1, (size_t)outsize, outfile ) ) error( "Error: Write Output File" );

	fclose( infile );
	fclose( outfile );
	return (EXIT_SUCCESS);
}
