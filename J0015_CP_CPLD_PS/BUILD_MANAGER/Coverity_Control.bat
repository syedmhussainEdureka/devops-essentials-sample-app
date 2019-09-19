@ECHO OFF

SETLOCAL ENABLEEXTENSIONS
SETLOCAL ENABLEDELAYEDEXPANSION

set rlsNUM=2131
set CSCI=J0015_Sensor_FPGA
set csciBASE=C:\DAIRCM\BUILDS\
set covEXE="C:\Program Files\Coverity\Coverity Static Analysis\bin
set vivdEXE=C:\Apps\Vivado\2016.4\bin\Vivado 
set appSTR=-log d2s_top.vdi
set wkspDIR=Batch_mode.tcl
set bldDIR="C:\Temp\J0015_CP_CPLD_PS\cov-build"

set ccsPROJ1=d2s_top
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



cls
cd C:\DAIRCM\BUILDS\J0015_CP_CPLD_PS\v2131\cpld_top\syn\impl1

::cov-build.exe --add-arg --c99 --dir %bldDIR% --delete-stale-tus --return-emit-failures --fs-capture-search C:\DAIRCM\BUILDS\J0015_CP_CPLD_PS\v2131\cpld_top\syn\impl1\Lattice_Build_CMD_Full.bat 

:: echo 'vivado -log d2s_top.vdi -applog -m64 -product Vivado -messageDb vivado.pb -mode batch -source Batch_mode.tcl -notrace'
echo.
:STEP1
echo - STEP1

echo - VIVADO COMMAND - %covEXE%\cov-build.exe" --no-log-server --dir "C:\Temp\J0015_Sensor_FPGA\cov-build" C:\Apps\Vivado\2016.4\bin\Vivado -log d2s_top.vdi -applog -m64 -product Vivado -messageDb Vivado.pb -mode batch -source Batch_mode.tcl -notrace
echo.
echo - Lattice CCOMMAND - %covEXE%\cov-build.exe" --no-log-server --dir "C:\Temp\J0015_Sensor_FPGA\cov-build" cmd /c "Lattice_Build_CMD_Full.cmd && exit /b"
goto END
%covEXE%\cov-build.exe" --no-log-server --dir "C:\Temp\J0015_Sensor_FPGA\cov-build" cmd /c "Lattice_Build_CMD_Full.cmd && exit /b"
::echo - %covEXE%\cov-build.exe" %cmdOPT00% %bldDIR% %vivdEXE% %cmdOPT0% %ccsPROJ1%.vdi %cmdOPT1% %cmdOPT2% %cmdOPT3% Vivado %cmdOPT4% Vivado.pb %cmdOPT5%  batch %cmdOPT6% %wkspDIR% %cmdOPT7%
::%covEXE%\cov-build.exe" %cmdOPT00% %bldDIR% %vivdEXE% %cmdOPT0% %ccsPROJ1%.vdi %cmdOPT1% %cmdOPT2% %cmdOPT3% Vivado %cmdOPT4% Vivado.pb %cmdOPT5%  batch %cmdOPT6% %wkspDIR% %cmdOPT7%
:: if /I "%ERRORLEVEL%" EQU "1" EXIT /B 1




:STEP3
echo STEP3
echo %covEXE%\cov-analyze.exe" --dir %bldDIR% --all --enable-fnptr --enable-callgraph-metrics --strip-path %csciBASE%\%CSCI%\%rlsNUM%\d2s_top --aggressiveness-level medium 
%covEXE%\cov-analyze.exe" --dir %bldDIR% --all --enable-fnptr --enable-callgraph-metrics --strip-path %csciBASE%\%CSCI%\%rlsNUM%\d2s_top --aggressiveness-level medium 
if /I "%ERRORLEVEL%" EQU "1" EXIT /B 1


:STEP4
echo STEP4
echo %covexe%\cov-commit-defects.exe" --dir %bldDIR% --host DAL1vCOVC01P.core.drs.master --port 8009 --user coverity --password system --stream 2131
%covexe%\cov-commit-defects.exe" --dir %bldDIR% --host DAL1vCOVC01P.core.drs.master --port 8009 --user coverity --password system --stream 2131
if /I "%ERRORLEVEL%" EQU "1" EXIT /B 1


:END