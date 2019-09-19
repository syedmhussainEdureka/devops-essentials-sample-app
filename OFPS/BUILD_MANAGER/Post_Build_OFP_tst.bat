@echo off & setlocal
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: 	Name of File: Pre_Build_OFP.bat
::
:: 	Ver: 0.1	Date:02/27/2019
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
set RLSNUM=%1


if "%1"=="" (call :help && exit /b 1)
if "%2"=="" (call :help && exit /b 1)
if NOT "%4"=="" (call :help && exit /b 1)

set ProjBase=C:\DAIRCM\BUILDS\OFPS\%1
set ProjbldDir=%ProjBase%\
set StageBase=K:\J0015\OFP
set StageDir=%RLSNUM%

Dir K:\J0015\OFP
 
if /I "%ERRORLEVEL%" EQU "1" (
net use T: /DELETE 
echo "Mapping \\DAVMS021100\ENG as T"
net use T:  \\DAVMS021100\ENG /persistent:yes
echo "Checking T: Drive"
set StageBase=T:\J0015\OFP
Dir T:\J0015\OFP
)


:: set XcopyCMD3=xCopy /S /Q /I %ProjbldDir%\mv3  %StageBase%\%StageDir%\mv3 >Nul
set XcopyCMD4=xCopy /S /Q /I %ProjbldDir%\mv4  %StageBase%\%StageDir%\mv4 >Nul

:: Time Stamp Start of Process
echo Input: Release: %1 Debug: %2 Skip: %3
echo "Processing Started @"
Call :Tstamp
echo. 
echo ***
whoami
echo ***
set tStr=%Time%
:: Verify and Validate the Input Strings
:: First: SVN Repo
set str="%~1"
set LBL=ONE
goto CheckInput 
:ONE
set RLSNUM=%1
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
:: Call :StageImport
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: %DBG% echo %XcopyCMD3%
:: %XcopyCMD3%
:: if /I "%ERRORLEVEL%" EQU "1" (Call :CpyErr %XcopyCMD3%)
%DBG% echo %XcopyCMD4%
%XcopyCMD4%
:: if /I "%ERRORLEVEL%" EQU "1" (Call :CpyErr %XcopyCMD4%)
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: OUTput The Inputs on Screen for Validation
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  
echo.

:PEND
   echo.
   echo "Completed Processing"  
  
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
echo ::		This batch file will generate the file_cfg_long.txt file for the OFP from the directories and files
echo ::		from the given SVN repository and the Path to the Source Directory
echo ::
echo :: 	Input Required: 
echo ::		1. The SVN Repository Name and Path
echo ::		2. Fll Path and Name of the Source Directory
echo :: 		
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
%DBG%  echo Checking Stage Dir 
K:
:: echo moving to %ProjbldDir%
cd %StageBase%
if NOT EXIST %RLSNUM% (mkdir %RLSNUM% > NUL 2> NUL)
mkdir %RLSNUM% > NUL 2> NUL
:: mkdir %RLSNUM%\mv3\OFP > NUL 2> NUL
:: mkdir %RLSNUM%\mv3\RRT > NUL 2> NUL
mkdir %RLSNUM%\mv4\OFP > NUL 2> NUL
mkdir %RLSNUM%\mv4\RRT > NUL 2> NUL

cd %StageBase%\%RLSNUM%
%DBG%  echo Moving to  %StageBase%\%RLSNUM%
goto END
::
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: Import the Ofp_util from the Build Machine
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:StageImport

!SVNEXPCMD!
if /I "%ERRORLEVEL%" EQU "1" goto SvnErr

echo "Ofp_Util" Imported Successfully

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
echo %DATE% %TIME%
goto EOF
::
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: 
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
::
:SpaceErr
echo %parent%%me%
@echo in %0  ********************* Space Error - NO spaces in File name allowed ********************* 
 exit /b 1 
::
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: Routine to Display Error Mesg for the Svn INITFAIL
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:Init_fail
    echo on
    echo  Error on Initialize: Check to See if SVN REPO is Available
    exit /b 
    goto :EOF
    goto END
::
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: Routine to Display Error Mesg for the Svn INITFAIL
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:Release_fail
    
    echo  Error on Release: Check to See if %RLSNUM% is Available
	echo off
    exit /b 
    goto :EOF
    goto END
::
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: Routine to Skip
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:SkipComp
echo "Skipping Build as requested: @"
Call :Tstamp
goto END
::
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: Routine For Mount Error
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:MountErr
echo Error: %ERRORLEVEL%
echo "Mount Error on K: Drive: @"
Call :Tstamp
goto END
:CpyErr
echo XCopy Error %1
goto END
::

:EOF
ENDLOCAL
endlocal
:: Exit from the Program

:END 
ENDLOCAL