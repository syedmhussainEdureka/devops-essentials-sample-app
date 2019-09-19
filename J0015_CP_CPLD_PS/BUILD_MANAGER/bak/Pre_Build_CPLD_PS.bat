@echo off & setlocal
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: 	Name of File: Pre_Build_CP_PS.bat
::
:: 	Ver: 0.1	Date:03/12/2019
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
set Toskip=%~4

if "%1"=="" (call :help && exit /b 1)

set ProjBase=C:\DAIRCM\BUILDS\j0015_cp_cpld_ps

set ProjbldDir=%ProjBase%\BUILD_MANAGER

set SVNLST=svn ls  
set SVNINFO=svn info 
set SVN_CNTRLREPO=https://davms120131.core.drs.master/svn/System_Binaries/System_Tools/OFP_Utility
set SVNEXPCMD=svn export --force -q %SVN_CNTRLREPO% .

:: Time Stamp Start of Process
echo Input:  Repo: %1 ReleaseNum:%2 DEBUG:%3 Skip:%4
echo "Processing Started @"
Call :Tstamp
echo. 
echo ***
whoami
echo ***
:: env|grep USER>C:\TEMP\User.log 2>&1

if S==%4 goto SkipComp
:: Verify and Validate the Input Strings
:: First: SVN Repo
set tStr=%Time%
set str="%~1"
set LBL=ONE
goto CheckInput 
:ONE
set SVNREPO_PATH=%str1%
if "%1"=="D" (set SVNREPO_PATH=https://davms120131.core.drs.master/svn/System_Binaries) 
if "%3"=="D" (set DBG=)
set RLSNUM=%2
:: Second: Release 
set str="%~2"
set LBL=TWO
goto CheckInput 

:TWO
set SVNDIR=%str2%

:STRT

:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: Initialize - Check to see if SVN Repo is Available
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Call :Init_Repo
if /I "%ERRORLEVEL%" EQU "1" (goto END)
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
::  Check to see if Release is Available in SVN
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Call :Check_Release
if "%str%"=="E200009" (goto END)
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
::  Check to see if Release DIR is Available For
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Call :CheckDir
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
::  Import Ofp_Util from SVN
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Call :SvnImport
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

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
echo ::		This batch file will create the Release Dir on build machine
echo ::     set up the directory structure for the New Release and Download 
echo ::		ofp_util from the SVN REPO
echo ::
echo :: 	Inputs Required: 
echo ::		1. The SVN Repository Name and Path
echo ::		2. Release
echo ::	    3. Debug ON or OFF D is ON
echo ::	    4. Skip - DO NOTHING
echo :: 		
echo ::		You can choice the Default repository or Enter the Name
echo ::
echo ::		Example
echo ::		%me%.bat D 2125 D S
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
:Init_Repo 
setlocal
set SVNLST=svn ls  
set LSTCMD="%SVNLST%%SVNREPO_PATH%"
%DBG% echo Check to see if SVN Repo is Available: %LSTCMD% 
%DBG% echo.
for /f "tokens=* delims= " %%a in (' !LSTCMD! ') do  (if /I "%ERRORLEVEL%" EQU "1"  call :Init_fail) 
endlocal
exit /b 
goto END
::
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: Rountine  Check to see if Release is Available
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:Check_Release
setlocal
set SVNLST=svn ls  
set LSTCMD="%SVNLST%%SVNREPO_PATH%/SBC/%RLSNUM% >Err.log 2>&1"
%DBG% echo Check to see if Release is Available  %LSTCMD% 
%DBG% echo.

for /f "tokens=* delims= " %%a in (' !LSTCMD!') do  (if /I "%ERRORLEVEL%" EQU "1"  call :Release_fail) 
for /f "tokens=* delims= " %%a in (Err.log) do (set str=%%a)
set str=%str:~5,7%
%DBG% echo %result%
if "%str%"=="E200009" (call :Release_fail)
endlocal
exit /b 
goto END
::
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: Rountine Check to see if Release Dir is Available
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: set ProjBase=C:\DAIRCM\BUILDS\OFPS\
:: set ProjbldDir=%ProjBase%%1\BUILD_MANAGER
:CheckDir
%DBG%  echo Checking Release Dir 
C:
%DBG% echo moving to %ProjBase%

cd %ProjBase%
if EXIST %RLSNUM% (rd /S /Q %RLSNUM%)

md %RLSNUM%
%DBG% echo Created Dir %RLSNUM%
:: chmod 777 %RLSNUM%
icacls  %RLSNUM% /reset /t /c /q 

md %RLSNUM%\mv3\OFP
md %RLSNUM%\mv3\RRT

md %RLSNUM%\mv4\OFP
md %RLSNUM%\mv4\RRT

md %RLSNUM%\BUILD_MANAGER
%DBG% echo Created Dir %RLSNUM%\BUILD_MANAGER
cd %ProjBase%\%RLSNUM%
exit /b 

::
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: Import the Ofp_util from SVN_Repo
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:SvnImport
%DBG% echo Executing %SVNEXPCMD%
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
:SkipComp
echo "Skipping Build as requested: @"
Call :Tstamp
goto END

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


:SvnErr
Echo SVN Export Error
goto END
::

:EOF
ENDLOCAL
endlocal
:: Exit from the Program
:END 
ENDLOCAL