@ECHO OFF

SETLOCAL ENABLEEXTENSIONS
SETLOCAL ENABLEDELAYEDEXPANSION
set me=%~n0
set parent=%~dp0
:: ===================================================================================
:: 
:: ===================================================================================

set rlsNUM=Cur
set CSCI=J0015_Sensor_OMAP
set projONE=ARM
set projTWO=DSP-v500

set csciBASE=C:\DAIRCM\BUILDS\
set covEXE="C:\Program Files\Coverity\Coverity Static Analysis\bin
set tiCMD1=C:\ti\ccsv5\eclipse\eclipsec -noSplash -data %csciBASE%\%CSCI%\%rlsNUM%\WORKSPACES -application com.ti.ccstudio.apps.projectBuild -ccs.projects ARM -ccs.clean -ccs.configuration Debug -ccs.autoImport
set tiCMD2=C:\ti\ccsv5\eclipse\eclipsec -noSplash -data %csciBASE%\%CSCI%\%rlsNUM%\WORKSPACES -application com.ti.ccstudio.apps.projectBuild -ccs.projects ARM -ccs.FullBuild -ccs.configuration Debug -ccs.autoImport

set wkspDIR=%csciBASE%\%CSCI%\%rlsNUM%\WORKSPACES
set bldDIR="C:\Temp\%CSCI%\cov-build"
:: ===================================================================================
:: 
:: ===================================================================================





set ProjectList="ARM DSP-v500"

cls
echo CLEAN ALL
rd /S/Q %bldDIR%

:STEP1
echo ===================================================================================
echo	%me%.bat Cleaning Projects
echo ===================================================================================

echo STEP1 
echo %covEXE%\cov-build.exe" --no-log-server --dir %bldDIR%  C:\ti\ccsv5\eclipse\eclipsec -noSplash -data %wkspDIR% -application com.ti.ccstudio.apps.projectBuild -ccs.projects %projONE% -ccs.clean -ccs.configuration Debug -ccs.autoImport
%covEXE%\cov-build.exe" --no-log-server --dir %bldDIR% C:\ti\ccsv5\eclipse\eclipsec -noSplash -data %wkspDIR% -application com.ti.ccstudio.apps.projectBuild -ccs.projects %projONE% -ccs.clean -ccs.configuration Debug -ccs.autoImport 
if /I "%ERRORLEVEL%" EQU "1" EXIT /B 1
echo %covEXE%\cov-build.exe" --no-log-server --dir %bldDIR%  C:\ti\ccsv5\eclipse\eclipsec -noSplash -data %wkspDIR% -application com.ti.ccstudio.apps.projectBuild -ccs.projects %projTWO% -ccs.clean -ccs.configuration Debug -ccs.autoImport 
%covEXE%\cov-build.exe" --no-log-server --dir %bldDIR% C:\ti\ccsv5\eclipse\eclipsec -noSplash -data %wkspDIR% -application com.ti.ccstudio.apps.projectBuild -ccs.projects %projTWO% -ccs.clean -ccs.configuration Debug -ccs.autoImport 
if /I "%ERRORLEVEL%" EQU "1" EXIT /B 1

 

:STEP2
echo ===================================================================================
echo		%me%.bat Building Projects
echo ===================================================================================
echo STEP2
echo %covEXE%\cov-build.exe" --no-log-server --dir %bldDIR% C:\ti\ccsv5\eclipse\eclipsec -noSplash -data %wkspDIR% -application com.ti.ccstudio.apps.projectBuild -ccs.projects %projONE% -ccs.FullBuild -ccs.configuration Debug -ccs.autoImport
%covEXE%\cov-build.exe" --no-log-server --dir %bldDIR% C:\ti\ccsv5\eclipse\eclipsec -noSplash -data %wkspDIR% -application com.ti.ccstudio.apps.projectBuild -ccs.projects %projONE% -ccs.FullBuild -ccs.configuration Debug -ccs.autoImport 
if /I "%ERRORLEVEL%" EQU "1" EXIT /B 1
echo %covEXE%\cov-build.exe" --no-log-server --dir %bldDIR% C:\ti\ccsv5\eclipse\eclipsec -noSplash %wkspDIR% -application com.ti.ccstudio.apps.projectBuild -ccs.projects %projTWO% -ccs.FullBuild -ccs.configuration Debug -ccs.autoImport 
%covEXE%\cov-build.exe" --no-log-server --dir %bldDIR% C:\ti\ccsv5\eclipse\eclipsec -noSplash %wkspDIR% -application com.ti.ccstudio.apps.projectBuild -ccs.projects %projTWO% -ccs.FullBuild -ccs.configuration Debug -ccs.autoImport 
if /I "%ERRORLEVEL%" EQU "1" EXIT /B 1



:STEP3
echo ===================================================================================
echo 		%me%.bat Analyzing Projects
echo ===================================================================================
echo STEP3
echo %covEXE%\cov-analyze.exe" --dir %bldDIR% --all --enable-fnptr --enable-callgraph-metrics --strip-path %csciBASE%\%CSCI%\%rlsNUM%\ --aggressiveness-level medium 
%covEXE%\cov-analyze.exe" --dir %bldDIR% --all --enable-fnptr --enable-callgraph-metrics --strip-path %csciBASE%\%CSCI%\%rlsNUM%\ --aggressiveness-level medium 
if /I "%ERRORLEVEL%" EQU "1" EXIT /B 1


:STEP4
echo ===================================================================================
echo 		%me%.bat Deploying Projects
echo ===================================================================================
echo STEP4
echo %covexe%\cov-commit-defects.exe" --dir %bldDIR% --host DAL1vCOVC01P.core.drs.master --port 8009 --user coverity --password system --stream Cur
%covexe%\cov-commit-defects.exe" --dir %bldDIR% --host DAL1vCOVC01P.core.drs.master --port 8009 --user coverity --password system --stream Cur
echo E:%ERRORLEVEL%
if /I "%ERRORLEVEL%" EQU "1" EXIT /B 1

echo ===================================================================================
echo				%me%.bat Completed Processing
echo ===================================================================================
:END