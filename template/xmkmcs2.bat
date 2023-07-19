set MACS_NAME=sample1

has060 -l -t . -u schedule.s

060high 1
hlk.r --makemcs -t -o %MACS_NAME%.MCS schedule listpcm im00/list00 im01/list01 im02/list02 im03/list03 im04/list04
060high 0
