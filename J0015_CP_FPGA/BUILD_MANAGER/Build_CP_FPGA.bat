@echo OFF
setLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: 	Name of File: Build_CP_FPGA.bat
::
:: 	Ver: 0.1	Date:03/18/2019
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
set BuildCP_FPGA=%~2

set DBG=::
Set Toskip=%~4

set ProjBase=C:\DAIRCM\BUILDS\J0015_CP_FPGA\
set ProjB=%ProjBase%\bin
set ProjbldDir=%ProjBase%%1\BUILD_MANAGER
set ImDir=%ProjBase%\%RleaseNum%\asp_fpga\asp_fpga.runs\impl_1\

set BuildCMD=vivado -log %ImDir%asp_top.vdi -applog -m64 -product Vivado -messageDb vivado.pb -mode batch -source Batch_mode.tcl -notrace >FPGA.txt 2>&1
set SrchCMD=Findstr /B /C:"write_bitstream completed successfully"
set SwpCMD=fart -q %ProjBase%\BUILD_MANAGER\Batch_mode.tcl 1400 %RleaseNum%

if "%3"=="D" (set DBG=)

:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: Verify Input 
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo. 
echo Inputs verified: Release: %RleaseNum% Build_CP_FPGA: %BuildCP_FPGA%  DBG: %DBG% Skip: %Toskip%
echo.
echo Project BUILD DIR: %ProjbldDir%
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: Time Stamp Start of Process
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo ++++++++++++++++++++++++++++++++++++++++++++++++++++
echo %me%: "Processing Started @"
Call :Tstamp
set tStr=%Time%

if S==%5 goto SkipComp
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:BLD
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%DBG% echo Moving to %ProjBase%\%RleaseNum%
cd %ProjBase%\%RleaseNum%
:: echo "**************** %me%: Processing !Project! ****************"
%DBG% echo Calling EnvSetup
CALL :EnvSetup 
:: if /I "%ERRORLEVEL%" EQU "1" (goto End)
%DBG% echo Calling Build FPGA
CALL :BldFPGA
:: if /I "%ERRORLEVEL%" EQU "1" (goto End)
echo ++++++++++++++++++++++++++++++++++++++++++++++++++++
echo %me%: "Processing Complete @"
Call :Tstamp
goto End

:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: Time Stamp End of Process
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Call :Tstamp
set tStr=%Time%
echo ++++++++++++++++++++++++++++++++++++++++++++++++++++
EXIT /B %ERRORLEVEL%
::End of main logic
goto End

:: REM ++++++++++++++++++++++++++++++++++++++++++++
:: REM ***** Only functions below this line *****
:: REM ++++++++++++++++++++++++++++++++++++++++++++
::

:: REM ++++++++++++++++++++++++++++++++++++++++++++
:EnvSetup
:: REM ++++++++++++++++++++++++++++++++++++++++++++
:: Modify the current PATH to Build on WINDOWS PLATFORM
:: echo %parent%
%DBG% echo Check ENV Path
PATH|Findstr "Vivado" >Path.txt
for %%a in ("Path.txt") do (set FileSize=%%~za)
%DBG% echo FZ: !FileSize! FZ2: %FileSize% 

if NOT %FileSize%==0(goto Skpath)
%DBG%  echo modifying Path to add Vivado
PATH=C:\Apps\Vivado\2016.4\tps\win64\git-1.9.5\bin;C:\Apps\Vivado\2016.4\bin;C:\Apps\Vivado\2016.4\lib\win64.o;%PATH%
 if /I "%ERRORLEVEL%" EQU "1" (Call :PathError ) 
 
:Skpath

%DBG%  echo moving to %ProjBase%\%RleaseNum%
C:
%DBG%  echo moving to %ProjBase%\
cd %ProjBase%\%RleaseNum%
%DBG%  echo Error=%ERRORLEVEL%
goto END
if /I "%ERRORLEVEL%" EQU "1" (Call :MoveError %ProjbldDir%)
if /I "%ERRORLEVEL%" EQU "1" (set ERRORLEVEL=1)
if /I "%ERRORLEVEL%" EQU "1" (EXIT /B)
goto End
Exit /B
goto End
:: REM ++++++++++++++++++++++++++++++++++++++++++++
:BldFPGA
:: REM ++++++++++++++++++++++++++++++++++++++++++++
%DBG%  echo in BldFPGA
%DBG%  echo Building CP_FPGA 
C:
%DBG% echo moving to %ProjBase%\%RleaseNum%\asp_fpga\asp_fpga.runs\impl_1
cd %ProjBase%\%RleaseNum%\asp_fpga\asp_fpga.runs\impl_1

%DBG% echo SWAP CMD: !SwpCMD!
!SwpCMD!
%DBG% echo Copy CMD %ProjBase%\BUILD_MANAGER\Batch_mode.tcl  %ImDir%Batch_mode.tcl
echo.
cp %ProjBase%\BUILD_MANAGER\Batch_mode.tcl %ImDir%Batch_mode.tcl
if /I "%ERRORLEVEL%" EQU "1" (Call :CopyError Batch_mode.tcl)

%DBG% echo Build CMD: %BuildCMD%
!BuildCMD!
if /I "%ERRORLEVEL%" EQU "1" (echo "Return Code $?")

%DBG% echo before Search
%DBG% echo SrchCMD: %SrchCMD%
%SrchCMD% runme.log
if /I "%ERRORLEVEL%" EQU "1" (Call :SrchError write_bitstream)
if /I "%ERRORLEVEL%" EQU "1" (goto End)

echo SuccessFull Build - CP_FPGA

cd ..
Exit /B
goto End

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
echo ++++++++++++++++++++++++++++++++++++++++++++++++++++
echo %DATE% %TIME%
echo ++++++++++++++++++++++++++++++++++++++++++++++++++++
goto :EOF
:EOF
:Help
echo %parent%%me%.bat *** INVALID ENTRY ***
echo ::
echo :: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo ::	Description:
echo ::		This batch file will build the  OFP and RRT binaries ** CP SW (OMAP) ** given the 
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
goto End
:: REM ++++++++++++++++++++++++++++++++++++++++++++
:: ERROR HANDLING
:: REM ++++++++++++++++++++++++++++++++++++++++++++
:ImportError
echo "Error: " %ERRORLEVEL%
echo "Import Error" - Exiting
goto EndERR

:CleanError
echo "Error: " %ERRORLEVEL%
echo "Clean Error" - %~1
goto EndERR

:BuildError
echo "Error: " %ERRORLEVEL%
echo "Build Error" - %~1
goto EndERR

:SrchError
echo "Error: " %ERRORLEVEL%
echo "Search Error" - %~1 on write_bitstream
goto EndERR

:CopyError
echo "Error: " %ERRORLEVEL%
echo "Copy Error" - %~1
goto EndERR

:CfgErr
echo "Error: " %ERRORLEVEL%
echo "CFG File missing" - Exiting
goto EndERR

:MoveError 
echo "Error: " %ERRORLEVEL%
echo "Failed to Change Directory - Exiting"
goto EndERR

:PathError 
echo "Error: " %ERRORLEVEL%
echo "Failed to add Vivado PATH - Exiting"
goto EndERR


:SkipComp
echo "Skipping Build as requested: @"
Call :Tstamp
goto End

:InpError
echo "Input Error - Exiting"
goto EndERR

:EndERR
set ERRORLEVEL=1
EXIT /B 1
:End