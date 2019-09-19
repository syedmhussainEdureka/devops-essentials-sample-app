@ECHO OFF
SETLOCAL ENABLEEXTENSIONS
SETLOCAL ENABLEDELAYEDEXPANSION
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: 	Name of File: cov_BUILD_CShell_SBC.bat
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
   set /A argCount+=1
)

if NOT "%argCount%" == "0" (call :help && exit /b 1)

:: cov-build.exe --add-arg --c99 --dir %CovDir%/%ProjDir% --delete-stale-tus --return-emit-failures --fs-capture-search %WS3Path%/%ProjDir%\PENTIUM4diab_SMP make
:: cov-analyze.exe --all --dir %CovDir%/%ProjDir% --strip-path %WS3Path%/%ProjDir%\PENTIUM4diab_SMP --aggressiveness-level high --enable-fb %DisableCheckers% --enable-parse-warnings !ParseWarnCmd!

:: ===================================================================================
:: Modify the lines below if any of the values change
:: ===================================================================================

set rlsNUM=Cur
set CSCI=J_MW_Cshell_SBC
set ProjectLIST=Reprogrammer T3AppTracker UDFDecoder
:: set ProjectLIST=Reprogrammer
set projDMY=Reprogrammer

set csciBASE=C:\DAIRCM\BUILDS\
set covEXE="C:\Program Files\Coverity\Coverity Static Analysis\bin

set wkspDIR=%csciBASE%\%CSCI%\%rlsNUM%\WORKSPACES\%projDMY%\PENTIUM4diab_SMP
set bldDIR="C:\Temp\%CSCI%\cov-build"\%projDMY%
set DisableCheckers=--disable UNUSED_VALUE --disable NO_EFFECT --disable DEADCODE --disable CHECKED_RETURN --disable UNINIT
set ParseWarnFile=daircm_parse_warnings.conf
set ParseWarnPath=%CovDir%/%ParseWarnFile%
set ParseWarnCmd=--parse-warnings-config %ParseWarnPath%

:: set todoLIST=cleanProj buildProj anzyleProj deployProj 

set todoLIST=cleanProj buildProj anzyleProj 
:: ===================================================================================
::  Main Section
:: ===================================================================================

cls
echo CLEAN ALL
rd /S /Q %bldDIR%

:STEP1
for %%x in (%ProjectLIST%)  do (
    for %%y in (%todoLIST%)  do (
	echo CALL: %%y %%x
    CALL :%%y %%x
    )	

   	)

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
set wkspDIR=%csciBASE%\%CSCI%\%rlsNUM%\WORKSPACES\%projDMY%\PENTIUM4diab_SMP
set bldDIR="C:\Temp\%CSCI%\cov-build"\%projDMY%

echo WKS: %wkspDIR%
cd %wkspDIR%
echo %covEXE%\cov-build.exe" --no-log-server --dir %bldDIR% make _clean --no-print-directory BUILD_SPEC=PENTIUM4diab_SMP DEBUG_MODE=1
%covEXE%\cov-build.exe" --no-log-server --dir %bldDIR% make _clean --no-print-directory BUILD_SPEC=PENTIUM4diab_SMP DEBUG_MODE=1
if /I "%ERRORLEVEL%" EQU "1" goto clnERR
EXIT /B %ERRORLEVEL%
::++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:buildProj
::++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo ===================================================================================
echo		%me%.bat Building Project %~1
echo ===================================================================================
set projDMY=%~1
set wkspDIR=%csciBASE%\%CSCI%\%rlsNUM%\WORKSPACES\%projDMY%\PENTIUM4diab_SMP
set bldDIR="C:\Temp\%CSCI%\cov-build"\%projDMY%
echo WKS: %wkspDIR%
cd %wkspDIR%
echo %covEXE%\cov-build.exe" --no-log-server --dir %bldDIR% make --no-print-directory BUILD_SPEC=PENTIUM4diab_SMP DEBUG_MODE=1
%covEXE%\cov-build.exe" --no-log-server --dir %bldDIR% make  BUILD_SPEC=PENTIUM4diab_SMP DEBUG_MODE=1
if /I "%ERRORLEVEL%" EQU "1" goto bldERR
EXIT /B %ERRORLEVEL%
::++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:anzyleProj
::++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo ===================================================================================
echo 		%me%.bat Analyzing Project  %~1
echo ===================================================================================
set projDMY=%~1
set wkspDIR=%csciBASE%\%CSCI%\%rlsNUM%\WORKSPACES\%projDMY%\PENTIUM4diab_SMP
set bldDIR="C:\Temp\%CSCI%\cov-build"\%projDMY%
echo STEP3

echo %covEXE%\cov-analyze.exe" --dir %bldDIR% --all  --strip-path %csciBASE%\%CSCI%\%rlsNUM%\%projDMY% --aggressiveness-level medium
%covEXE%\cov-analyze.exe" --dir %bldDIR% --all --enable-fnptr --enable-callgraph-metrics --strip-path %csciBASE%\%CSCI%\%rlsNUM%\%projDMY% --aggressiveness-level medium
if /I "%ERRORLEVEL%" EQU "1" anzERR
EXIT /B %ERRORLEVEL%
::++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:deployProj
::++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo ===================================================================================
echo 		%me%.bat Deploying Project  %~1
echo ===================================================================================

set projDMY=%~1
set bldDIR="C:\Temp\%CSCI%\cov-build"\%projDMY%
echo %covexe%\cov-commit-defects.exe" --dir %bldDIR% --host coverity.core.drs.master --port 8009 --user coverity --password system --stream CM_DAIRCM_J_MW_Cshell
%covexe%\cov-commit-defects.exe" --dir %bldDIR% --host coverity.core.drs.master --port 8009 --user coverity --password system --stream CM_DAIRCM_J_MW_Cshell
echo E:%ERRORLEVEL%
if /I "%ERRORLEVEL%" EQU "1" goto dplyERR
EXIT /B %ERRORLEVEL%
::++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:help
::++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
cls
echo %parent%%me%.bat *** INVALID ENTRY ***
echo ::
echo :: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo ::	Description:
echo ::		This file will generate the Coverity Reports for the ** Sensor SW (OMAP) ** given the 
echo ::		four variables that are Set as shown in the description.
echo ::
echo ::      Please read the description at the top of the file to see how it works
echo ::
echo :: 	Arguments Required: 
echo ::		1. NONE
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