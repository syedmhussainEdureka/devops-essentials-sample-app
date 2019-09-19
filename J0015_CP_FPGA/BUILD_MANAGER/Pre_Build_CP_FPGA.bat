@echo off & setlocal
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: 	Name of File: Pre_Build_CP_FPGA.bat
::
:: 	Ver: 0.1	Date:03/20/2019
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

:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: Check & Display User 
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo ***
whoami
echo ***

:: C:\DAIRCM\BUILDS\J0015_CP_FPGA\BUILD_MANAGER
set ProjBase=C:\DAIRCM\BUILDS\J0015_CP_FPGA\

set ProjbldDir=%ProjBase%\BUILD_MANAGER

set SVNLST=svn ls  
set SVNINFO=svn info 
set SVN_CNTRLREPO=https://davms120131.core.drs.master/svn/J0015_CP_FPGA/trunk_%2
set SVNEXPCMD=svn export --force -q %SVN_CNTRLREPO% .


:: Time Stamp Start of Process
echo Input:  Repo: %1 ReleaseNum:%2 DEBUG:%3 Skip:%4
echo.
echo ++++++++++++++++++++++++++++++++++++++++++++++++++++ 
echo "Processing Started @"
Call :Tstamp
echo. 

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
if "%1"=="D" (set SVNREPO_PATH=https://davms120131.core.drs.master/svn/J0015_CP_FPGA/trunk_%2) 
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
%DBG% echo Call :Init_Repo
Call :Init_Repo
if /I "%ERRORLEVEL%" EQU "1" (goto End)
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
::  Check to see if Release is Available in SVN
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%DBG% echo Check_Release
Call :Check_Release
if "%str%"=="E200009" (goto End)
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
::  Check to see if Release DIR is Available For
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%DBG% echo Call :CheckDir
Call :CheckDir
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
::  Importfrom SVN
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%DBG% echo Call :SvnImport
Call :SvnImport
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

%DBG% echo Call FixFiles 
Call :FixFiles
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: OUTput The Inputs on Screen for Validation
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  
echo.

:PEnd
   echo.
   echo ++++++++++++++++++++++++++++++++++++++++++++++++++++
   echo "Completed Pre-Build Processing"  
  
Call :Tstamp

EndLOCAL
exit /b 0
go to End
EndLOCAL
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
for /f "tokens=* delims= " %%a in (Err.log) do (set str=%%a)
set str=%str:~5,7%
%DBG% echo %result%
if "%str%"=="E170013" (call :Init_fail)
if "%str%"=="E175013" (call :Init_fail)
Endlocal
exit /b 
goto End
::
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: Rountine  Check to see if Release is Available
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:Check_Release
setlocal
set SVNLST=svn ls  
set LSTCMD="%SVNLST%%SVNREPO_PATH%>Err.log 2>&1"
%DBG% echo Check to see if Release is Available  %LSTCMD% 
%DBG% echo.

for /f "tokens=* delims= " %%a in (' !LSTCMD!') do  (if /I "%ERRORLEVEL%" EQU "1"  call :Release_fail) 
for /f "tokens=* delims= " %%a in (Err.log) do (set str=%%a)
set str=%str:~5,7%
%DBG% echo %result%
if "%str%"=="E200009" (call :Release_fail)
Endlocal
exit /b 
goto End
::
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: Rountine Check to see if Release Dir is Available
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

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

:: md %RLSNUM%\BUILD_MANAGER
:: %DBG% echo Created Dir %RLSNUM%\BUILD_MANAGER

 cd %ProjBase%\%RLSNUM%
:: exit /b 

:: REM ++++++++++++++++++++++++++++++++++++++++++++
:: Modify the current PATH to Build on WINDOWS 
:: REM ++++++++++++++++++++++++++++++++++++++++++++
:: echo %parent%
if EXIST Path.txt (rm Path.txt) >NUL
%DBG% echo Check ENV Path
PATH|Findstr "Vivado" >Path.txt
for %%a in ("Path.txt") do (set FileSize=%%~za)
%DBG% echo FZ: !FileSize! FZ2: %FileSize% 
cd %ProjBase%

if NOT %FileSize%==0 goto :Sypath
%DBG%  echo modifying Path to add Vivado
PATH=C:\Apps\Vivado\2016.4\tps\win64\git-1.9.5\bin;C:\Apps\Vivado\2016.4\bin;C:\Apps\Vivado\2016.4\lib\win64.o;%PATH%
 if /I "%ERRORLEVEL%" EQU "1" (Call :PathError ) 
:Sypath

exit /b 
goto End

::
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: Import the CP_FPGA from SVN_Repo
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:SvnImport
C:
cd %ProjBase%\%RLSNUM%
%DBG% echo Executing %SVNEXPCMD%
!SVNEXPCMD!
if /I "%ERRORLEVEL%" EQU "1" goto SvnErr
echo ++++++++++++++++++++++++++++++++++++++++++++++++++++
echo "CP FPGA" Imported Successfully
echo ++++++++++++++++++++++++++++++++++++++++++++++++++++
exit /b 
goto End
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
echo ++++++++++++++++++++++++++++++++++++++++++++++++++++
goto EOF
::
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: Routine to Fix Files from the SVN Repo %ProjBase%\%RLSNUM%\asp_fpga
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:FixFiles
%DBG% echo Moving to %ProjBase%\%RLSNUM%\asp_fpga
C:

cd %ProjBase%\%RLSNUM%\asp_fpga

%DBG% echo Delete Line 6 sed '6s/.*//' asp_fpga.xpr > %RLSNUM%a.xpr
sed '6s/.*//' asp_fpga.xpr > %RLSNUM%a.xpr
%DBG% echo Insert Line 6 sed -i "6i\<Project Version=\"7\" Minor=\"17\" Path="%ProjBase2%\%RLSNUM%\\d2s_top\\d2s_top.xpr\">\" %RLSNUM%a.xpr
sed -i -r "6i<Project Version=\"7\" Minor=\"17\" Path="C:/DAIRCM/BUILDS/J0015_CP_FPGA/%RLSNUM%\/asp_fpga.xpr">" %RLSNUM%a.xpr
sed '7s/.*//' %RLSNUM%a.xpr > asp_fpga.xpr

%DBG% echo Moving to %ProjBase%\BUILD_MANAGER
cd %ProjBase%\BUILD_MANAGER
fart -q "Batch_mode.tcl" 1400 %RLSNUM% >NUL
goto End
::
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: 
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:SkipComp
echo "Skipping Build as requested: @"
Call :Tstamp
goto End

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
    @echo on
    echo  Error on Initialize: Check to See if SVN REPO is Available
    exit /b 
	@echo off
    goto :EOF
    goto End

::
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: Routine to Display Error Mesg for the Svn INITFAIL
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:Release_fail
    
    echo  Error on Release: Check to See if %RLSNUM% is Available
	echo off
    exit /b 
    goto :EOF
    goto End

:SvnErr
echo SVN Export Error
goto End
::

:EOF
EndLOCAL
Endlocal
:: Exit from the Program
:End 
EndLOCAL