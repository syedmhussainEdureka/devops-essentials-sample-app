@ECHO OFF

SETLOCAL ENABLEEXTENSIONS
SETLOCAL ENABLEDELAYEDEXPANSION


set rlsNUM=2131
set CSCI=J_CTRL_SW_Control
set csciBASE=C:\DAIRCM\BUILDS\

set ccsPROJ=omap_arm
set ccsCFG=Debug
set bldcln=clean
set bldFull=Full

set covEXE="C:\Program Files\Coverity\Coverity Static Analysis\bin
set tiCMD1=C:\ti\ccsv5\eclipse\eclipsec -noSplash -data %csciBASE%\%CSCI%\%rlsNUM%\WORKSPACES -application com.ti.ccstudio.apps.projectBuild -ccs.projects %ccsPROJ% -ccs.buildType %bldcln%   -ccs.configuration %ccsCFG% -ccs.autoImport
set tiCMD2=C:\ti\ccsv5\eclipse\eclipsec -noSplash -data %csciBASE%\%CSCI%\%rlsNUM%\WORKSPACES -application com.ti.ccstudio.apps.projectBuild -ccs.projects %ccsPROJ% -ccs.buildType %bldFull%  -ccs.configuration %ccsCFG% -ccs.autoImport

set wkspDIR=%csciBASE%\%CSCI%\%rlsNUM%\WORKSPACES
set bldDIR="C:\Temp\J_CTRL_SW_Control\cov-build"

set ccsPROJ=bareMetalDSP


::goto STEP3


cls
goto STEP4
:STEP1
echo STEP1
echo "C:\Program Files\Coverity\Coverity Static Analysis\bin\cov-build.exe"  --no-log-server --dir %bldDIR% %tiCMD1%
"C:\Program Files\Coverity\Coverity Static Analysis\bin\cov-build.exe"  --no-log-server --dir %bldDIR% %tiCMD1%
if /I "%ERRORLEVEL%" EQU "1" EXIT /B 1


:STEP2
echo STEP2
echo %covEXE%\cov-build.exe" %cmdOPT1% %bldDIR% %tiEXE% %cmdOPT2% %wkspDIR% %appSTR% %cmdOPT3% omap_arm %cmdOPT4% full %cmdOPT5% Debug -ccs.autoImport
%covEXE%\cov-build.exe" %cmdOPT1% %bldDIR% %tiEXE% %cmdOPT2% %wkspDIR% %appSTR% %cmdOPT3% omap_arm %cmdOPT4% full %cmdOPT5% Debug -ccs.autoImport
if /I "%ERRORLEVEL%" EQU "1" EXIT /B 1
goto END



:STEP3
echo STEP3
echo %covEXE%\cov-analyze.exe" --dir %bldDIR% --all --enable-fnptr --enable-callgraph-metrics --strip-path %csciBASE%\%CSCI%\%rlsNUM%\ARM_ONLY --aggressiveness-level medium 
%covEXE%\cov-analyze.exe" --dir %bldDIR% --all --enable-fnptr --enable-callgraph-metrics --strip-path %csciBASE%\%CSCI%\%rlsNUM%\ARM_ONLY --aggressiveness-level medium 
if /I "%ERRORLEVEL%" EQU "1" EXIT /B 1


:STEP4
echo STEP4
echo %covexe%\cov-commit-defects.exe" --dir %bldDIR% --host DAL1vCOVC01P.core.drs.master --port 8009 --user coverity --password system --stream 2131
%covexe%\cov-commit-defects.exe" --dir %bldDIR% --host DAL1vCOVC01P.core.drs.master --port 8009 --user coverity --password system --stream 2131
if /I "%ERRORLEVEL%" EQU "1" EXIT /B 1


:END