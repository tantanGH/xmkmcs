echo off

rem
rem  xmkmcs2.bat - X680x0 MACS data cross builder #2
rem
rem  version 2023.07.12 tantan
rem
rem    Prerequisites:
rem     - XEiJ 0.23.07.11 or above, 060turbo mode with high memory 512MB
rem     - HAS060.X 3.09+91 or above
rem     - HLK Evolution 3.01+18 or above
rem
rem    How to use:
rem     1. Complete xmkmcs1.sh
rem     2. Edit schedule.s
rem     3. Confirm listpcm.o file in the current directory
rem     4. Confirm listXX.o files in imXX sub directories
rem     5. Update imXX/listXX args in this file if needed
rem     6. Run xmkmcs2.bat
rem

set MACS_NAME=sample1

has060 -l -t . -u schedule.s

060high 1
hlk.r -t --makemcs -o %MACS_NAME%.MCS schedule listpcm im00/list00 im01/list01 im02/list02 im03/list03 im04/list04

060high 0
