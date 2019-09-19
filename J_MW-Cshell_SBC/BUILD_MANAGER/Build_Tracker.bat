@echo OFF
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: 	Name of File: Build_Tracker.bat
::
:: 	Ver: 0.1	Date:01/16/2019
::
::	Author: Syed M Hussain @ DRS
::
::      SEE HELP FOR USAGE
::
::
::+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
SET me=%~n0
SET parent=%~dp0
SET argCount=0

SET Rls=%~1
SET RleaseNum=%~2
Set Toskip=%~3
SET WIND_BASE=C:\WindRiver\vxworks-6.9
SET ProjBase=C:\data\Tracker139\T2
SET ProjBin=%ProjBase%\bin
SET ProjlibDir=%ProjBase%\libT2
SET ProjbldDir=%ProjBase%\tracker\%ReleaseNum%
SET CygwinInstallDir=C:\Apps\cygwin64
SET CygwinbinDir=%CygwinInstallDir%\bin
SET CleanCMD=make clean
SET BuildCMD=make vxworks
SET MdfyPathCMD=%CygwinbinDir%;%PATH%
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: Display Information for Build 
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
cls
echo ***
echo User: %USERNAME% 	Home: %UserProfile% 		Host: %computername%
echo ***

:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: Verify Input 
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo. 
echo Inputs verified: Release: %Rls% Src: %RleaseNum% Build: %Toskip%
echo.
echo Project BUILD DIR: %ProjbldDir%

:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: Time Stamp Start of Process
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo ++++++++++++++++++++++++++++++++++++++++++++++++++++
echo "Processing Started @"
Call :Tstamp
SET tStr=%Time%

if S==%3 goto SkipComp
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:BLD

:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

echo "**************** Processing !Project! ****************"
CALL :EnvSetup 
:: if /I "%ERRORLEVEL%" EQU "1" (goto END)
 CALL :BuildLib %ProjlibDir% 
:: if /I "%ERRORLEVEL%" EQU "1" (goto END)
CALL :BuildProject
::if /I "%ERRORLEVEL%" EQU "1" (goto END)
echo ++++++++++++++++++++++++++++++++++++++++++++++++++++
echo "Processing Complete @"
Call :Tstamp
echo ++++++++++++++++++++++++++++++++++++++++++++++++++++
goto END

:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: Time Stamp End of Process
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Call :Tstamp
set tStr=%Time%
echo ++++++++++++++++++++++++++++++++++++++++++++++++++++
EXIT /B %ERRORLEVEL%
::End of main logic
goto END

:: REM ++++++++++++++++++++++++++++++++++++++++++++
:: REM ***** Only functions below this line *****
:: REM ++++++++++++++++++++++++++++++++++++++++++++
::

:: REM ++++++++++++++++++++++++++++++++++++++++++++
:EnvSetup
:: REM ++++++++++++++++++++++++++++++++++++++++++++
:: Modify the current PATH to Build on WINDOWS PLATFORM
:: echo %parent%
C:
:: echo moving to %ProjlibDir%
cd %ProjlibDir%
:: echo Error=%ERRORLEVEL%
if /I "%ERRORLEVEL%" EQU "1" (Call :MoveError %ProjlibDir%)
if /I "%ERRORLEVEL%" EQU "1" (SET ERRORLEVEL=1)
if /I "%ERRORLEVEL%" EQU "1" (EXIT /B)
:: echo Current PATH:
:: PATH
:: echo Adding %CygwinbinDir% to the Front of PATH
SET PATH=%MdfyPathCMD%
:: echo Modified PATH 
:: PATH
:: echo moving back to %parent%
goto End
Exit /B
GOTO END

:: REM ++++++++++++++++++++++++++++++++++++++++++++
:BuildLib
:: REM ++++++++++++++++++++++++++++++++++++++++++++
:: echo Building Library - libT2
C:
:: echo Moving to Library %ProjlibDir% 
cd %ProjlibDir%
if /I "%ERRORLEVEL%" EQU "1" (Call :MoveError libT2)
if /I "%ERRORLEVEL%" EQU "1" (SET ERRORLEVEL=1)
if /I "%ERRORLEVEL%" EQU "1" (EXIT /B) 

:: echo %CleanCMD%
%CleanCMD%
if /I "%ERRORLEVEL%" EQU "1" (Call :CleanError libT2)
if /I "%ERRORLEVEL%" EQU "1" (goto END)

:: echo %BuildCMD% 
%BuildCMD%
if /I "%ERRORLEVEL%" EQU "1" (Call :BuildError libT2)
if /I "%ERRORLEVEL%" EQU "1" (goto END)
echo SuccessFull Build - libT2
cd ..
Exit /B
GOTO END
:: REM ++++++++++++++++++++++++++++++++++++++++++++
:BuildProject
:: REM ++++++++++++++++++++++++++++++++++++++++++++
 echo Building Tracker.vx RL: %RleaseNum% P:%~1
 echo Moving to Project Build Dir: %ProjbldDir%\%RleaseNum%

cd %ProjbldDir%\%RleaseNum%
echo %CleanCMD%

%CleanCMD%

if /I "%ERRORLEVEL%" EQU "1" (Call :CleanError - Tracker.vx)
if /I "%ERRORLEVEL%" EQU "1" (goto END)

:: echo %BuildCMD% 
%BuildCMD%
:: echo ERROR=%ERRORLEVEL%
if /I "%ERRORLEVEL%" EQU "1" (Call :BuildError - Tracker.vx)
if /I "%ERRORLEVEL%" EQU "1" (goto END)

cd %ProjBase%\bin
cp tracker_1.3.25.vx Tracker.vx
echo ++++++++++++++++++++++++++++++++++++++++++++++++++++
echo SuccessFull Build - Tracker.vx
echo Please verify and Validate Tracker.vx in the %ProjBase%\bin)
echo ++++++++++++++++++++++++++++++++++++++++++++++++++++
Exit /B
GOTO END

:: REM +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: Rountine for Verify the Inputs
:: REM +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:CheckInput <string>
set space=no
set str=%~1
for /f "tokens=2" %%a in ("%str%") do (set char=%%b)
if "!char!"=="" goto :cntue
set space=yes
@echo on
if "%space%"=="yes" (echo  Input Contains Space, No spaces Allowed)
@echo off
set space=no
   
:cntue
goto %LBL%
goto EOF
:: REM +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: Routine for Time Stamp
:: REM +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:Tstamp
echo %DATE% %TIME%
goto :EOF
:EOF
:Help
echo %parent%%me%.bat *** INVALID ENTRY ***
echo ::
echo :: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo ::	Description:
echo ::		This batch file will build the complete ** Sensor SW (OMAP) ** given the 
echo ::		The Release and the Project
echo ::
echo :: 	Input Required: 
echo ::		1. Release - Release String
echo ::		2. Project Name
echo :: 		
echo ::		
echo ::
echo ::		Example:
echo ::		%me%.bat v3426_ARM_Laser_warning ARM
echo ::		%me%.bat v3426_ARM_Laser_warning DSP-v500
echo ::		%me%.bat v3426_ARM_Laser_warning AIS
echo ::		
echo ::
echo :: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
goto END
  		 
:: REM ++++++++++++++++++++++++++++++++++++++++++++
:: ERROR HANDLING
:: REM ++++++++++++++++++++++++++++++++++++++++++++
:ImportError
echo "Error: " %ERRORLEVEL%
echo "Import Error" - Exiting
goto ENDERR

:CleanError
echo "Error: " %ERRORLEVEL%
echo "Clean Error" - %~1
goto ENDERR

:BuildError
echo "Error: " %ERRORLEVEL%
echo "Build Error" - %~1
goto ENDERR

:CfgErr
echo "Error: " %ERRORLEVEL%
echo "CFG File missing" - Exiting
goto ENDERR

:MoveError 
echo "Error: " %ERRORLEVEL%
echo "Failed to Change Directory to LibT2 - Exiting"
goto ENDERR

:SkipComp
echo "Skipping Build as requested: @"
Call :Tstamp
goto END

:InpError
echo "Input Error - Exiting"
goto ENDERR

:ENDERR
SET ERRORLEVEL=1
EXIT /B 1
:END