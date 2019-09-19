@ECHO OFF
setLOCAL ENABLEEXTENSIONS
setLOCAL ENABLEDELAYEDEXPANSION

:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: 	Name of File: SvnExport.bat
::
:: 	Ver: 0.1	Date:01/03/2019
::
::	Author: Syed M Hussain @ DRS
::
::      SEE HELP FOR DETAILS
::
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
::
set me=%~n0
set parent=%~dp0
set argCount=0
set tld=no
set "xstr=^^^&" 
for %%x in (%*) do (
   set /A argCount+=1
)

set SVN_CNTRLREPO=https://davms120131.core.drs.master/svn/J0015_Sensor_OMAP
::             E:\DAIRCM\BUILDS\Sensor_SW_CSCI\J0015_Sensor_OMAP\DSP_OMAP_code\v3426_ARM_laser_warning        
set ProjBldDir=C:\DAIRCM\BUILDS\J0015_Sensor_OMAP\
set SVNEXPCMD=svn export --force %SVN_CNTRLREPO%


if "%1"=="" (call :help && exit /b 1)
if "%2"=="" (call :help && exit /b 1)
::if "%3"=="" (call :help && exit /b 1)
::if NOT "%4"=="" (call :help && exit /b 1)

:: Time Stamp Start of Process
cls
echo "Processing Started @"
Call :Tstamp
set tStr=%Time%
set f1name=!tStr!_null
set f2name=!tStr!_null

:: Verify and Validate the Input Strings
:: First: Branch\trunk\tag\Dir

set str1=%~1
set LBL=ONE
goto CheckInput 

:ONE
set SVNDIR=%str1%
::echo Processed Var1 %SVNDIR%

:: Second: Release NUM\Dir Name
set str2=%~2
set LBL=TWO
goto CheckInput 

:TWO
set SVNREL=%~2
::echo Processed Var2 %SVNREL%


set str3=%~3
set BRGDIR=%str3%
set LBL=THREE
goto CheckInput 
:THREE
::echo Processed Var3 %BRGDIR%

:STRT

cd %ProjBldDir%
:: Check to See if Dir Exists- Then Remove it

if EXIST %ProjBldDir%%SVNREL% (

rd /Q /S  %ProjBldDir%%SVNREL% >NUL
if /I "%ERRORLEVEL%" EQU "1" goto DelErr
echo.
)
if NOT EXIST %ProjBldDir%%SVNREL% (
md %ProjBldDir%%SVNREL%
if /I "%ERRORLEVEL%" EQU "1" goto MkErr
echo.
) 

:: echo Processing: svn export --force  "%SVN_CNTRLREPO%/%SVNDIR%" "%ProjBldDir%%SVNREL%" 
echo Importing %SVNREL% from SVN REPO
svn export --force "%SVN_CNTRLREPO%/%SVNDIR%/%SVNREL%" %ProjBldDir%%SVNREL% >Nul
if /I "%ERRORLEVEL%" EQU "1" goto SvnErr


cd %ProjBldDir%%SVNREL%
for /f %%a in (' Dir *.* /B ') do (set projDIR=%%a)

:: echo XCOPY /Q /I /E %ProjBldDir%BUILD_MANAGER\WORKSPACES %ProjBldDir%%SVNREL%\WORKSPACES
XCOPY /I /E /Q %ProjBldDir%BUILD_MANAGER\WORKSPACES %ProjBldDir%%SVNREL%\%projDIR%\WORKSPACES >NUL

:SKP
ECHO "%SVNREL%" Imported Successfully

Echo "Completed Processing" 

Call :Tstamp
set tStr=%Time%

::End of main logic

EXIT /B %ERRORLEVEL%


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
echo ::		This batch file will generate the cfg.txt file for the OFP from the directories and files
echo ::		from the given SVN repository and the Path to the Source Directory
echo ::
echo :: 	Input Required: 
echo ::		1. Release NUM\Dir Name
echo ::		2. Branch\trunk\tag\dir
echo ::		3. Project
echo ::
echo ::		Example:
echo ::		         Build.bat 2129 v1440_ARM_Laser_warning AIS
echo ::		
echo ::
echo :: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
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
goto :EOF
:SvnErr
Echo SVN Export Error
goto END
::
:DelErr
Echo Error on Deleting %SVNREL%
goto END
:CrtErr
Echo Error on Creating %SVNREL%\WORKSPACES
goto END
:EOF
:END

