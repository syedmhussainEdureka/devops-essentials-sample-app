@ECHO OFF

SETLOCAL ENABLEEXTENSIONS
SETLOCAL ENABLEDELAYEDEXPANSION

set WORKSPACES=ARM_ONLY
set rlsNUM=Cur
set CSCI=J_CTRL_SW_Control
set csciBASE=C:\DAIRCM\BUILDS\
set covEXE="C:\Program Files\Coverity\Coverity Static Analysis\bin
set tiCMD1=C:\ti\ccsv5\eclipse\eclipsec -noSplash -data %csciBASE%\%CSCI%\%rlsNUM%\WORKSPACES -application com.ti.ccstudio.apps.projectBuild -ccs.projects omap_arm -ccs.clean -ccs.configuration Debug -ccs.autoImport
set tiCMD2=C:\ti\ccsv5\eclipse\eclipsec -noSplash -data %csciBASE%\%CSCI%\%rlsNUM%\WORKSPACES -application com.ti.ccstudio.apps.projectBuild -ccs.projects omap_arm -ccs.FullBuild -ccs.configuration Debug -ccs.autoImport

set wkspDIR=%csciBASE%\%CSCI%\%rlsNUM%\WORKSPACES
set bldDIR="C:\Temp\J_CTRL_SW_Control\cov-build"

set ccsPROJ=omap_arm
set ccsCFG=Debug
set bldTYP=clean

set ProjectList="bareMetalDSP omap_arm AIS"

::goto STEP3
:: C:\ti\ccsv5\eclipse\eclipsec -noSplash -data C:\DAIRCM\BUILDS\J_CTRL_SW_Control\Cur\WORKSPACES -application com.ti.ccstudio.apps.projectBuild -ccs.projects omap_arm -ccs.clean -ccs.configuration Debug -ccs.autoImport

cls
echo CLEAN ALL
rd /S/Q %bldDIR%
C:\ti\ccsv5\eclipse\eclipsec -noSplash -data C:\DAIRCM\BUILDS\J_CTRL_SW_Control\Cur\WORKSPACES -application com.ti.ccstudio.apps.projectBuild -ccs.projects omap_arm -ccs.clean -ccs.configuration Debug -ccs.autoImport
:STEP1

echo STEP1 
echo %covEXE%\cov-build.exe" --no-log-server --dir %bldDIR%  %tiCMD1%  
%covEXE%\cov-build.exe" --no-log-server --dir %bldDIR% C:\ti\ccsv5\eclipse\eclipsec -noSplash -data C:\DAIRCM\BUILDS\J_CTRL_SW_Control\Cur\WORKSPACES -application com.ti.ccstudio.apps.projectBuild -ccs.projects omap_arm -ccs.clean -ccs.configuration Debug -ccs.autoImport
if /I "%ERRORLEVEL%" EQU "1" EXIT /B 1
%covEXE%\cov-build.exe" --no-log-server --dir %bldDIR% C:\ti\ccsv5\eclipse\eclipsec -noSplash -data C:\DAIRCM\BUILDS\J_CTRL_SW_Control\Cur\WORKSPACES -application com.ti.ccstudio.apps.projectBuild -ccs.projects omap_arm -ccs.FullBuild -ccs.configuration Debug -ccs.autoImport
if /I "%ERRORLEVEL%" EQU "1" EXIT /B 1
 

:STEP2
echo STEP2
echo %covEXE%\cov-build.exe" --no-log-server --dir %bldDIR%  C:\ti\ccsv5\eclipse\eclipsec -noSplash -data C:\DAIRCM\BUILDS\J_CTRL_SW_Control\Cur\WORKSPACES -application com.ti.ccstudio.apps.projectBuild -ccs.projects bareMetalDSP -ccs.clean -ccs.configuration Debug -ccs.autoImport 
%covEXE%\cov-build.exe" --no-log-server --dir %bldDIR% C:\ti\ccsv5\eclipse\eclipsec -noSplash -data C:\DAIRCM\BUILDS\J_CTRL_SW_Control\Cur\WORKSPACES -application com.ti.ccstudio.apps.projectBuild -ccs.projects bareMetalDSP -ccs.clean -ccs.configuration Debug -ccs.autoImport 
if /I "%ERRORLEVEL%" EQU "1" EXIT /B 1
%covEXE%\cov-build.exe" --no-log-server --dir %bldDIR% C:\ti\ccsv5\eclipse\eclipsec -noSplash -data C:\DAIRCM\BUILDS\J_CTRL_SW_Control\Cur\WORKSPACES -application com.ti.ccstudio.apps.projectBuild -ccs.projects bareMetalDSP -ccs.FullBuild -ccs.configuration Debug -ccs.autoImport 
if /I "%ERRORLEVEL%" EQU "1" EXIT /B 1


:STEP3
echo STEP3
echo %covEXE%\cov-build.exe" --no-log-server --dir %bldDIR%  C:\ti\ccsv5\eclipse\eclipsec -noSplash -data C:\DAIRCM\BUILDS\J_CTRL_SW_Control\Cur\WORKSPACES -application com.ti.ccstudio.apps.projectBuild -ccs.projects AIS -ccs.FullBuild -ccs.configuration Debug -ccs.autoImport 
%covEXE%\cov-build.exe" --no-log-server --dir %bldDIR% C:\ti\ccsv5\eclipse\eclipsec -noSplash -data C:\DAIRCM\BUILDS\J_CTRL_SW_Control\Cur\WORKSPACES -application com.ti.ccstudio.apps.projectBuild -ccs.projects AIS -ccs.clean -ccs.configuration Debug -ccs.autoImport 
if /I "%ERRORLEVEL%" EQU "1" EXIT /B 1
%covEXE%\cov-build.exe" --no-log-server --dir %bldDIR% C:\ti\ccsv5\eclipse\eclipsec -noSplash -data C:\DAIRCM\BUILDS\J_CTRL_SW_Control\Cur\WORKSPACES -application com.ti.ccstudio.apps.projectBuild -ccs.projects AIS -ccs.FullBuild -ccs.configuration Debug -ccs.autoImport 
if /I "%ERRORLEVEL%" EQU "1" EXIT /B 1



:STEP4
echo STEP4
echo %covEXE%\cov-analyze.exe" --dir %bldDIR% --all --enable-fnptr --enable-callgraph-metrics --strip-path %csciBASE%\%CSCI%\%rlsNUM%\ARM_ONLY --aggressiveness-level medium 
%covEXE%\cov-analyze.exe" --dir %bldDIR% --all --enable-fnptr --enable-callgraph-metrics --strip-path %csciBASE%\%CSCI%\%rlsNUM%\ARM_ONLY --aggressiveness-level medium 
if /I "%ERRORLEVEL%" EQU "1" EXIT /B 1


:STEP4
echo STEP4
echo %covexe%\cov-commit-defects.exe" --dir %bldDIR% --host DAL1vCOVC01P.core.drs.master --port 8009 --user coverity --password system --stream Cur
%covexe%\cov-commit-defects.exe" --dir %bldDIR% --host DAL1vCOVC01P.core.drs.master --port 8009 --user coverity --password system --stream Cur
if /I "%ERRORLEVEL%" EQU "1" EXIT /B 1


:END