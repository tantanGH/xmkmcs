set MACS_NAME=macs_src
has060 -t . -u %MACS_NAME%.s

rem update the below line before run (hlk exec name, im folders)
060high 1
hlkev -t -r %MACS_NAME% listpcm im00/list00 im01/list01 im02/list02 im03/list03 im04/list04

060high 0
makemcs %MACS_NAME%
