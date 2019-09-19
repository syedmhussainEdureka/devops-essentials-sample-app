@ECHO OFF

SETLOCAL ENABLEEXTENSIONS
SETLOCAL ENABLEDELAYEDEXPANSION

set rlsNUM=v2131
set CSCI=J0015_CP_FPGA
set csciBASE=C:\DAIRCM\BUILDS\
set covEXE="C:\Program Files\Coverity\Coverity Static Analysis\bin
set vivdEXE=C:\Apps\Vivado\2016.4\bin\Vivado 
set appSTR=-log d2s_top.vdi
set wkspFIL=Batch_mode.tcl
::set wkspDIR=%csciBASE%%CSCI%\%rlsNUM%\d2s_top\
set wkspDIR=.\
set bldDIR="C:\Temp\J0015_CP_FPGA\cov-build"

set ccsPROJ1=asp_fpga
set ccsPROJ2=
set ccsCFG=Debug
set bldTYP=clean

set cmdOPT00=--no-log-server --dir
set cmdOPT0=-log
set cmdOPT1=-applog
set cmdOPT2=-m64
set cmdOPT3=-product
set cmdOPT4=-messageDb
set cmdOPT5=-mode
set cmdOPT6=-source
set cmdOPT7=-notrace
set vidCMD=%vivdEXE% -log asp_fpga.vdi -applog -m64 -product Vivado -messageDb vivado.pb -mode batch -source Batch_mode.tcl -notrace
cls

echo.
echo.
echo C:\DAIRCM\BUILDS\J0015_CP_FPGA\%rlsNUM%\asp_fpga
cd C:\DAIRCM\BUILDS\J0015_CP_FPGA\%rlsNUM%\asp_fpga


:: echo 'vivado -log asp_fpga.vdi -applog -m64 -product Vivado -messageDb vivado.pb -mode batch -source Batch_mode.tcl -notrace'
echo.
:STEP1
echo - STEP1
echo - %covEXE%\cov-build.exe" %cmdOPT00% %bldDIR% %vidCMD%
%covEXE%\cov-build.exe" %cmdOPT00% %bldDIR% %vidCMD%
:: if /I "%ERRORLEVEL%" EQU "1" EXIT /B 1



:STEP3
echo STEP3
echo %covEXE%\cov-analyze.exe" --dir %bldDIR% --all --enable-fnptr --enable-callgraph-metrics --strip-path %csciBASE%\%CSCI%\%rlsNUM%\asp_fpga --aggressiveness-level medium 
%covEXE%\cov-analyze.exe" --dir %bldDIR% --all --enable-fnptr --enable-callgraph-metrics --strip-path %csciBASE%\%CSCI%\%rlsNUM%\asp_fpga --aggressiveness-level medium 
if /I "%ERRORLEVEL%" EQU "1" EXIT /B 1


:STEP4
echo STEP4
echo %covexe%\cov-commit-defects.exe" --dir %bldDIR% --host DAL1vCOVC01P.core.drs.master --port 8009 --user coverity --password system --stream 2131
%covexe%\cov-commit-defects.exe" --dir %bldDIR% --host DAL1vCOVC01P.core.drs.master --port 8009 --user coverity --password system --stream 2131
if /I "%ERRORLEVEL%" EQU "1" EXIT /B 1


:END