@echo OFF
setLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: 	Name of File: Build_OFP.bat
::
:: 	Ver: 0.1	Date:02/27/2019
::
::	Author: Syed M Hussain @ DRS
::
::      SEE HELP FOR USAGE
::
::
::+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
set me=%~n0
set parent=%~dp0
set argCount=0
set RleaseNum=%~1
set BuildOFP=%~2
set BuildRRT=%~3
set DBG=::
Set Toskip=%~5

set ProjBase=C:\DAIRCM\BUILDS\OFPS\
set ProjB=%ProjBase%\bin

set ProjbldDir=%ProjBase%%1\BUILD_MANAGER
:: set OFPbuildCMD3=Call ofp_util.exe -mv3 -vv -aow file_cfg.txt
set OFPbuildCMD4=Call ofp_util.exe -mv4 -vv -aow file_cfg.txt
set RRTbuildCMD=Call ofp_util.exe -rrt

if "%4"=="D" (set DBG=)

:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: Verify Input 
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo. 
echo Inputs verified: Release: %RleaseNum% BuildOFP: %BuildOFP% BuildRRT: %BuildRRT% DBG: %DBG% Skip: %Toskip%
echo.
echo Project BUILD DIR: %ProjbldDir%
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: Time Stamp Start of Process
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo "Processing Started @"
Call :Tstamp
set tStr=%Time%

if S==%5 goto SkipComp
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:BLD
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
cd %ProjBase%\%RleaseNum%
echo "**************** Processing !Project! ****************"
CALL :EnvSetup 
:: if /I "%ERRORLEVEL%" EQU "1" (goto END)
CALL :BuildOFP %ProjbldDir%
:: if /I "%ERRORLEVEL%" EQU "1" (goto END)
::CALL :BuildRRT
::if /I "%ERRORLEVEL%" EQU "1" (goto END)
echo "Processing Complete @"
Call :Tstamp
goto END

:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: Time Stamp End of Process
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Call :Tstamp
set tStr=%Time%

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
%DBG%  echo moving to %ProjBase%\
cd %ProjBase%\%RleaseNum%
%DBG%  echo Error=%ERRORLEVEL%
if /I "%ERRORLEVEL%" EQU "1" (Call :MoveError %ProjbldDir%)
if /I "%ERRORLEVEL%" EQU "1" (set ERRORLEVEL=1)
if /I "%ERRORLEVEL%" EQU "1" (EXIT /B)
goto End
Exit /B
GOTO END
:: REM ++++++++++++++++++++++++++++++++++++++++++++
:BuildOFP
:: REM ++++++++++++++++++++++++++++++++++++++++++++
%DBG%  echo Building OFP 
C:
:: echo moving to %ProjbldDir%
cd %ProjBase%\%RleaseNum%
%DBG% echo %OFPbuildCMD3%
%OFPbuildCMD3%
if /I "%ERRORLEVEL%" EQU "1" (Call :BuildError OFP3)
if /I "%ERRORLEVEL%" EQU "1" (goto END)
echo SuccessFull Build - OFP3
Call :BuildRRT
::Call :MvFiles mv3
:: 
cd %ProjBase%\%RleaseNum%

%DBG% echo %OFPbuildCMD4%
%OFPbuildCMD4%
if /I "%ERRORLEVEL%" EQU "1" (Call :BuildError OFP4)
if /I "%ERRORLEVEL%" EQU "1" (goto END)
echo SuccessFull Build - OFP4
Call :BuildRRT
Call :MvFiles mv4
cd ..
Exit /B
GOTO END
:: REM ++++++++++++++++++++++++++++++++++++++++++++
:MvFiles
:: REM ++++++++++++++++++++++++++++++++++++++++++++
set mvdir=%1%

%DBG% echo Moving Files to Dir: %ProjBase%%RleaseNum%\%mvdir%
cd %ProjBase%%RleaseNum%

%DBG% echo RrtFile: %Rrt_File%
cp %ProjBase%%RleaseNum%\DAIRCM.ofp .\%mvdir%\OFP
cp %ProjBase%%RleaseNum%\Manifest.bin .\%mvdir%\OFP
cp %ProjBase%%RleaseNum%\Binary_Versions.txt .\%mvdir%\OFP
cp ./*.rrt .\%mvdir%\RRT
:: REM ++++++++++++++++++++++++++++++++++++++++++++
:BuildRRT
:: REM ++++++++++++++++++++++++++++++++++++++++++++
%DBG% echo Building RRT RL: %RleaseNum% P:%~1
%DBG% echo Moving to Project Build Dir: %ProjbldDir%

C:
:: echo moving to 
cd %ProjBase%\%RleaseNum%
%DBG%  echo %RRTbuildCMD%
 %RRTbuildCMD%
if /I "%ERRORLEVEL%" EQU "1" (Call :BuildError RRT)
if /I "%ERRORLEVEL%" EQU "1" (goto END)
echo SuccessFull Build - RRT
cd ..
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
echo ::		This batch file will build the  OFP and RRT binaries ** Sensor SW (OMAP) ** given the 
echo ::		The Release NUMBER
echo ::
echo :: 	Input Required: 
echo ::		1. Release - Release String
echo ::		2. Project Name: O for OFP
echo ::		3. Project Name: R for RRT
echo ::		4. Turn DUBUG ON: D for Debug
echo ::		5. Skip Entire Build
echo :: 		
echo ::
echo ::		Example:
echo ::		%me%.bat 1400 O R D S
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
echo "Failed to Change Directory - Exiting"
goto ENDERR

:SkipComp
echo "Skipping Build as requested: @"
Call :Tstamp
goto END

:InpError
echo "Input Error - Exiting"
goto ENDERR

:ENDERR
set ERRORLEVEL=1
EXIT /B 1
:END