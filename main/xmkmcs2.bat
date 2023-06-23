echo off

rem
rem  xmkmcs2.bat - X680x0 MACS data cross builder #2
rem
rem  version 2023.06.21 tantan
rem
rem    Prerequisites:
rem     - XEiJ 060turbo 384MB high memory WITHOUT 060turbo.sys
rem     - install TS16DRVp.X on behalf of 060turbo.sys for full 384MB high memory use
rem     - has060.x
rem     - hlk.r evolution by TcbnErik, himem patched by Hau
rem     - makemcs.x
rem
rem    How to use:
rem     1. Complete xmkmcs1.sh
rem     2. Confirm listpcm.o file in the current directory
rem     3. Confirm listXX.o files in imXX sub directories
rem     4. Add imXX/listXX to hlk.r line in this file if needed
rem     5. Edit schedule.s
rem     6. Run xmkmcs2.bat
rem

set MCS_NAME=MACSsample

has060 -t . -u schedule.s

hlk.r -t -r -o %MACS_NAME%.r schedule listpcm im00/list00 im01/list01 im02/list02 im03/list03 im04/list04

makemcs %MACS_NAME%
