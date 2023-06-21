set MACS_NAME=MACSsample
has060 -t . -u schedule.s

rem make sure you install TS16DRVp.x, and use hlk.r evolution patched by TcbnErik/Hau
hlk.r -t -r -o %MACS_NAME%.r schedule listpcm im00/list00 im01/list01 im02/list02 im03/list03 im04/list04

makemcs %MACS_NAME%
