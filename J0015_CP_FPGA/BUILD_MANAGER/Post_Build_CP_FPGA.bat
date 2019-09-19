@echo off & setlocal
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: 	Name of File: Post_Build_CP_FPGA.bat
::
:: 	Ver: 0.1	Date:03/19/2019
::
::	Author: Syed M Hussain @ DRS
::
::      SEE HELP FOR DETAILS
::
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
setLOCAL ENABLEEXTENSIONS
setLOCAL ENABLEDELAYEDEXPANSION
set me=%~n0
set parent=%~dp0


set DBG=::
set Toskip=%~3
set RleaseNum=%~1

if "%1"=="" (call :help && exit /b 1)
if "%2"=="" (call :help && exit /b 1)
if NOT "%4"=="" (call :help && exit /b 1)

set ProjBase=C:\DAIRCM\BUILDS\J0015_CP_FPGA\
set ProjbldDir=%ProjBase%%1\BUILD_MANAGER
set ImDir=%ProjBase%%RleaseNum%\asp_fpga\asp_fpga.runs\impl_1\
set StageDir=%ProjBase%%RleaseNum%


set CopyCMD=cp gen_bin.tcl A.tcl
set vivadoCMD=vivado -mode tcl -source A.tcl

:: Time Stamp Start of Process
echo Input: Release: %1 Debug: %2 Skip: %3
echo %me%: "Processing Started @"
Call :Tstamp
echo. 
set tStr=%Time%
:: Verify and Validate the Input Strings
:: First: SVN Repo
set str="%~1"
set LBL=ONE
goto CheckInput 
:ONE
set RleaseNum=%~1
if "%2"=="D" (set DBG=)
if S==%3 goto SkipComp

:STRT
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: Initialize - Check to see if StageBase is Available
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Call :StageBase
if /I "%ERRORLEVEL%" EQU "1" (goto END)
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
::  Check to see if Stage DIR is Available For
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Call :StageDir
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
::  Copy Ofp_Util from Build Machine
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Call :GenFile
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: OUTput The Inputs on Screen for Validation
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  
echo.

:PEND
   echo.
   echo %me%: "Completed Processing"  
  
Call :Tstamp

ENDLOCAL
exit /b 0
go to END
ENDLOCAL
goto EOF
:: REM ++++++++++++++++++++++++++++++++++++++++++++
:: REM ***** Only functions below this line *****
:: REM ++++++++++++++++++++++++++++++++++++++++++++

:help
@echo in %0
echo %parent%%me%
echo *** INVALID ENTRY ***
echo ::
echo :: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo ::	Description:
echo ::		This batch file will generate the A.tcl file and The B.bat from the gen_bin.tcl
echo ::		it will generate the asp_fpga.bin from the asp_fpga.bit file, for the given release
echo ::
echo :: 	Input Required: 
echo ::		1. The Release - ####
echo ::		2. Dubug Option - D
echo ::		3. Skip Option - S
echo ::		You can choice the Default repository or Enter the Name
echo ::
echo ::		Example
echo ::		
echo ::		
echo ::
echo :: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
::
goto EOF
exit /b 
::
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: Routine - Check to see if SVN Repo is Available
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:StageBase 
setlocal
set LSTCMD="Dir %StageBase%"
%DBG% echo Check to see if Stage Area is Available: %LSTCMD% 
%DBG% echo.
for /f "tokens=* delims= " %%a in (' !LSTCMD! ') do  (if /I "%ERRORLEVEL%" EQU "1"  call :Init_fail) 
endlocal
exit /b 
goto END
::
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: Rountine Check to see if Release Dir is Available
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:StageDir
::%DBG%  echo Checking %StageDir%

:: echo moving to %ProjbldDir%
cd %StageDir%\

goto END

::
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: Import from the Build Machine
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:GenFile
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: Check the Path for Vivado 
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: Modify the current PATH to Build on WINDOWS PLATFORM
:: echo %parent%
%DBG% echo Check ENV Path
PATH|Findstr "Vivado" >Path.txt
for %%a in ("Path.txt") do (set FileSize=%%~za)
echo FZ: !FileSize! FZ2: %FileSize% 

if NOT %FileSize%==0(goto Skpath)
%DBG%  echo modifying Path to add Vivado
PATH=C:\Apps\Vivado\2016.4\tps\win64\git-1.9.5\bin;C:\Apps\Vivado\2016.4\bin;C:\Apps\Vivado\2016.4\lib\win64.o;%PATH%
 if /I "%ERRORLEVEL%" EQU "1" (Call :PathError ) 
 
:Skpath


%DBG% echo Moving to %ProjBase%%RleaseNum%\asp_fpga
cd %ProjBase%\%RleaseNum%\asp_fpga
%DBG% echo Copying !CopyCMD!
!CopyCMD!
%DBG% echo Adding exit to TCL file
echo exit>>A.tcl
!vivadoCMD!
if /I "%ERRORLEVEL%" EQU "1" goto VivErr

echo "asp_fpga_%RleaseNum%" Generated Successfully

exit /b 
goto END
::
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: Rountine for Verify the Inputs
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
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

:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: Routine for Time Stamp
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:Tstamp
echo ++++++++++++++++++++++++++++++++++++++++++++++++++++
echo %DATE% %TIME%
echo ++++++++++++++++++++++++++++++++++++++++++++++++++++
goto EOF
::
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: Routine to Skip
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:SkipComp
echo "Skipping Build as requested: @"
Call :Tstamp
goto END

:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:TclErr
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo Tcl File Generation Error %1
goto END
::

:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:GenErr
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo Batch File Generation Error %1
goto END
::

:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:VivErr
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo Vivado Error %1
goto END
::

:EOF
ENDLOCAL
endlocal
:: Exit from the Program
:END 
ENDLOCAL