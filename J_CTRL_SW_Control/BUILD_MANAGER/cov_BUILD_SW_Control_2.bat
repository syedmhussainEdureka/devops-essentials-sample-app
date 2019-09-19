@ECHO OFF
SETLOCAL ENABLEEXTENSIONS
SETLOCAL ENABLEDELAYEDEXPANSION
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: 	Name of File: cov_BUILD_SW_Control.bat
::
:: 	Ver: 0.1	Date:05/17/2019
::
::	Author: Syed M Hussain @ DRS
::
::  Description: 
::  	This file runs the Coverity commands and generates the coverity reports for this CSCI.
::      This file can be used for the other CSCI's also as long as the following Variables
::      are changed:
::      set rlsNUM=Cur
::      set CSCI=J_CTRL_SW_Control    
::      set projONE=omap_arm
::      set projTWO=bareMetalDSP
::
::      SEE HELP FOR USAGE
::
::+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

set me=%~n0
set parent=%~dp0
set argCount=0

for %%x in (%*) do (
   SET /A argCount+=1
)

if "%1"=="" (call :help && exit /b 1)
if "%2"=="" (call :help && exit /b 1)


:: ===================================================================================
:: Modify the lines below if any of the values change
:: ===================================================================================

set rlsNUM=%~1
set bldTYP=%~2

set CSCI=J_CTRL_SW_Control
set ProjectLIST=bareMetalDSP omap_arm
set projDMY=omap_arm 
set csciBASE=C:\DAIRCM\BUILDS\
set covEXE="C:\Program Files\Coverity\Coverity Static Analysis\bin
set covCFG="C:\Program Files\Coverity\Coverity Static Analysis\config\coverity_config.xml"
set wkspDIR=%csciBASE%\%CSCI%\%rlsNUM%\WORKSPACES

set DisableCheckers=--disable UNUSED_VALUE --disable NO_EFFECT --disable DEADCODE --disable CHECKED_RETURN --disable UNINIT
set ParseWarnFile=parse_warnings.conf
set ParseWarnPath=%ParseWarnFile%
set ParseWarnCmd=--parse-warnings-config %ParseWarnPath%

set todoLIST=anzyleProj 
:: set todoLIST=cleanProj buildProj anzyleProj
:: set todoLIST=deployProj 

:: ===================================================================================
::  Main Section
:: ===================================================================================

cls
:: goto anzyleProj

:STEP1

for %%x in (%ProjectLIST%)  do (
    for %%y in (%todoLIST%)  do (
	echo CALL: %%y %%x
    CALL :%%y %%x
    )	

   	)
:OUT
echo ===================================================================================
echo				%me%.bat Completed Processing
echo ===================================================================================
goto END 
::++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:cleanProj
::++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo ===================================================================================
echo	%me%.bat Cleaning Project %~1
echo ===================================================================================
set projDMY=%~1
echo projDMY=%projDMY%
set bldDIR=C:\Temp\%CSCI%\cov-build
set wkspDIR=%csciBASE%\%CSCI%\%rlsNUM%\INTEGERATION
echo WKS: %wkspDIR%
echo CLEAN ALL
rmdir /S /Q %bldDIR%
cd %wkspDIR%
echo %covEXE%\cov-build.exe" --no-log-server --config %covCFG% --dir %bldDIR%  c:\ti_5.1.1\ccsv5\eclipse\eclipsec -noSplash -data %wkspDIR% -application com.ti.ccstudio.apps.projectBuild -ccs.projects %projDMY% -ccs.clean -ccs.configuration %bldTYP% -ccs.autoImport
%covEXE%\cov-build.exe" --no-log-server --config %covCFG% --dir %bldDIR%  C:\ti_5.1.1\ccsv5\eclipse\eclipsec -noSplash -data %wkspDIR% -application com.ti.ccstudio.apps.projectBuild -ccs.projects %projDMY% -ccs.clean -ccs.configuration %bldTYP% -ccs.autoImport 
if /I "%ERRORLEVEL%" EQU "1" goto clnERR
EXIT /B %ERRORLEVEL%
::++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:buildProj
::++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo ===================================================================================
echo		%me%.bat Building Project %~1
echo ===================================================================================
set projDMY=%~1
set wkspDIR=%csciBASE%\%CSCI%\%rlsNUM%\INTEGRATION\
set bldDIR=C:\Temp\%CSCI%\cov-build
echo WKS: %wkspDIR%
cd %wkspDIR%
echo %covEXE%\cov-build.exe" --no-log-server --config %covCFG% --dir %bldDIR% C:\ti_5.1.1\ccsv5\eclipse\eclipsec -noSplash -data %wkspDIR% -application com.ti.ccstudio.apps.projectBuild -ccs.projects %projDMY% -ccs.buildType full -ccs.configuration %bldTYP% -ccs.autoImport
%covEXE%\cov-build.exe" --no-log-server --config %covCFG% --dir %bldDIR% C:\ti_5.1.1\ccsv5\eclipse\eclipsec -noSplash -data %wkspDIR% -application com.ti.ccstudio.apps.projectBuild -ccs.projects %projDMY% -ccs.buildType full -ccs.configuration %bldTYP% -ccs.autoImport 
:: %covEXE%\cov-build.exe" --add-arg --c99 --delete-stale-tus --return-emit-failures --fs-capture-search  --dir %bldDIR% C:\ti_5.1.1\ccsv5\eclipse\eclipsec -noSplash -data %wkspDIR% -application com.ti.ccstudio.apps.projectBuild -ccs.projects %projDMY% -ccs.buildType full -ccs.configuration %bldTYP% -ccs.autoImport 
if /I "%ERRORLEVEL%" EQU "1" goto bldERR
EXIT /B %ERRORLEVEL%
::++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:anzyleProj
::++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo ===================================================================================
echo 		%me%.bat Analyzing Project  %~1
echo ===================================================================================
set projDMY=%~1
set wkspDIR=%csciBASE%\%CSCI%\%rlsNUM%\INTEGRATION\
set bldDIR="C:\Temp\%CSCI%\cov-build"
echo STEP3
echo %covEXE%\cov-analyze.exe" --dir %bldDIR%  --config %covCFG% --all --enable-fnptr --strip-path %csciBASE%\%CSCI%\%rlsNUM%\ --aggressiveness-level medium --enable-fb %DisableCheckers% --enable-parse-warnings !ParseWarnCmd!
 
 %covEXE%\cov-analyze.exe" --dir %bldDIR%  --config %covCFG% --all --enable-fnptr --enable-callgraph-metrics --strip-path %csciBASE%\%CSCI%\%rlsNUM%\ --aggressiveness-level medium 
:: %covEXE%\cov-analyze.exe" --dir %bldDIR% --strip-path %csciBASE%\%CSCI%\%rlsNUM%\ --aggressiveness-level high --enable-fb %DisableCheckers% --enable-parse-warnings !ParseWarnCmd!

if /I "%ERRORLEVEL%" EQU "1" anzERR
EXIT /B %ERRORLEVEL%
::++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:deployProj
::++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo ===================================================================================
echo 		%me%.bat Deploying Project  %~1
echo ===================================================================================

set projDMY=%~1
set bldDIR="C:\Temp\%CSCI%\cov-build"\
echo %covexe%\cov-commit-defects.exe" --dir %bldDIR% --host coverity.core.drs.master --port 8009 --user coverity --password system --stream CM_DAIRCM_J_CTRL_SW
%covexe%\cov-commit-defects.exe" --dir %bldDIR% --host coverity.core.drs.master --port 8009 --user coverity --password system --stream CM_DAIRCM_J_CTRL_SW
echo E:%ERRORLEVEL%
if /I "%ERRORLEVEL%" EQU "1" goto dplyERR
EXIT /B %ERRORLEVEL%
goto END 
::++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:help
::++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
cls
echo %parent%%me%.bat *** INVALID ENTRY ***
echo ::
echo :: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo ::	Description:
echo ::		This file will generate the Coverity Reports for the ** CNTRL SW CSCI ** given the 
echo ::		four variables that are Set as shown in the description.
echo ::
echo ::      Please read the description at the top of the file to see how it works
echo ::
echo :: 	Arguments Required: 
echo ::		1. Two 
echo ::         a. RelNUM
echo ::         b. Type of Build
echo ::		 
echo :: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
goto END
:: +++++++++++++++++++++++++++++++++++++++++++++++
:: ERROR HANDLING
:: +++++++++++++++++++++++++++++++++++++++++++++++
:bldERR
echo "Build Error" - Exiting
goto END
:clnERR
echo "Clean Error" - Exiting
goto END
:anzERR
echo "Analyze Error" - Exiting
goto END
:dplyERR
echo "Deploy Error" - Exiting


:END