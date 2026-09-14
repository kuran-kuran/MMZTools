if exist "output" goto :START
mkdir output
:START
z80as -x -mGVRAMTOOL80B -ooutput\GVRAMTOOL80B.mzt MAIN80B.ASM
rem z80as -x -mGVRAMTOOL80B -ooutput\GVRAMTOOL80B-4.mzt MAIN80B-MONO.ASM
rem z80as -x -mGVRAMTOOL80B -ooutput\GVRAMTOOL80B-2.mzt MAIN80B-16x8.ASM
rem z80as -x -mGVRAMTOOL80B -ooutput\GVRAMTOOL80B-3.mzt MAIN80B-32x4.ASM
pause
goto :START
