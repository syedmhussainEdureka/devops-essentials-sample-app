@echo off & setlocal
SETLOCAL ENABLEEXTENSIONS
SETLOCAL ENABLEDELAYEDEXPANSION

set NFOCMD="svn info  https://davms120131.core.drs.master/svn/J0015_Sensor_FPGA/tags/D2S_FPGA_v0407/d2s_top/d2s_top.srcs/sources_1/02_clocks_&_resets/|Find "Rev:" "
::echo NFOCMD1: !NFOCMD!
:: set NFOCMD=!NFOCMD:^&=^^^&!
::echo NFOCMD2: !NFOCMD!
:: for /f "tokens=* delims= " %%a in ('Type Filelist.txt') do (set "str=%%a"
echo A:
set /a i=0

for /f "tokens=* delims=" %%a in ('Type Filelist.txt') do (set "str=%%a"
echo STR: !str!

echo I= %i%
svn info %%a |Find "Rev:" >>Revlst.txt
set /a i+=1
if "i"=="5" (goto END
echo %str%)
:END
endlocal
