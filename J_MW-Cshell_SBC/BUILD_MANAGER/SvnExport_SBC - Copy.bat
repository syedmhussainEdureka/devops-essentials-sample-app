@echo OFF
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: 	Name of File: SvnExport_SBC.bat
::
:: 	Ver: 0.1	Date:01/9/2019
::
::	Author: Syed M Hussain @ DRS
::
::      SEE HELP FOR DETAILS
::
::
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
::
SET me=%~n0
SET parent=%~dp0
SET argCount=0
SET tld=no
SET "xstr=^^^&" 

:loop 
if "%1"=="" (call :help && exit /b 1)
if "%1"=="" (goto END)

:: echo Inputs verified: %1 %2 %3 %4 %5 %6 %7
SET /A argCount+=1

::if "%argCount%"=="6" goto Fwd
::shift
::goto :loop
:::Fwd

:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: SET Up the variables required for this batch file
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
SET SVN_CNTRLREPO=https://davms120131.core.drs.master/svn/J_MW_Cshell
SET SVN_CNTRLREPO2=https://davms120131.core.drs.master/svn/J_MW_Cshell
SET SVN_CNTRLREPO3=https://davms120131.core.drs.master/svn/J_MW_Tracker/branches/INTEGRATION/VxWorks/VxWorks/
SET SVNLSTCMD=svn ls %SVN_CNTRLREPO%
SET ProjBldDir=C:\DAIRCM\BUILDS\J_MW_Cshell_SBC\
SET SVNEXPCMD=svn export --force %SVN_CNTRLREPO%
SET SVNEXPCMDF=svn export --force %SVN_CNTRLREPO%
SET SVNEXPCMD2=svn export %SVN_CNTRLREPO2%
SET SVNEXPCMD3=svn export --force %SVN_CNTRLREPO3%

SET WindRiverDir=C:\WindRiver\

SET Vx=VxWorks-6.9
SET WRC=WindRiver_Components
SET Components=components\

SET FilePath=C:\Temp\
SET FileName=Errlog.txt
SET SvnStr=E170013

:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: Display Information for Build 
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
cls
echo ***
echo User: %USERNAME% 	Home: %UserProfile% 		Host: %computername%
echo ***
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: Time Stamp Start of Process
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo Version:0.1 %me%.bat
echo "Processing Started @"
Call :Tstamp
SET tStr=%Time%

if S==%7 goto SkipComp


:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: Verify and Validate the Input Strings
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

:: First: Branch or Tag or Dir
SET SVNDIR=%1
::Call :ChkIput %SVNDIR%

:: Second: Release NUM or Dir Name
SET SVNREL=%2
::Call :ChkIput %SVNREL%


:: Third: Release SRC - Under Tracker139
::Call :ChkIput %~3
SET RELNUM=%3

::Call :ChkIput %~4
SET PHS4=%4
::Call :ChkIput %~5
SET PHS5=%5
::Call :ChkIput %~6
SET PHS6=%6
SET SKPA=%7

echo. 
echo Inputs verified: %SVNDIR% %SVNREL% %RELNUM% %PHS4% %PHS5% %PHS6% %SKPA%

:: echo Initilaizing SVN Repo: Connect
Call :SvnIni
:: goto END

:STRT
:: echo Init-Repo: Connected

:: echo Calling Phase-1
:: echo.
if S==%4 echo ** Skipped Phase-1 - %SVNREL% - **
if S==%4 goto PH2
cd %ProjBldDir%
Call :Proc 1 0 1


:PH1
Call :Phase1

:PH2
:: echo.
:: echo Calling Phase-2
:: echo.
if S==%5 echo ** Skipped Phase-2 - %WindRiverDir%%Vx% - **
if S==%5 goto :PH3
Call :Phase2
 
:PH3
:: echo.
:: echo Calling Phase-3
:: echo.
if S==%6  echo ** Skipped Phase-3 - Tracker.vx - **
if S==%6 goto :PH4
Call :Phase3

:PH4
::if S==%6
echo. 
echo ** Completed Processing as requested - **
Call :Tstamp
SET tStr=%Time%

::End of main logic

EXIT /B %ERRORLEVEL%

goto END
:: REM ++++++++++++++++++++++++++++++++++++++++++++
:: REM ***** Only functions below this line *****
:: REM ++++++++++++++++++++++++++++++++++++++++++++


:help
cls
@echo in %0
echo %parent%%me%
echo *** INVALID ENTRY ***
echo ::
echo :: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo :: Description:
echo ::		This script will import the Dirs and files from the given SVN Repository
echo ::		as requested:
echo ::
echo :: Input Required: 
echo ::	1. Branch or Tag or Dir
echo ::	2. Release NUM or Dir Name
echo ::	3. Release source from the Tracker139 to build		
echo ::	4. Y/N To import source for the following:
echo ::	   T3AppTracker.out, Reprogrammer.out and 
echo ::		UDFDecoder.out
echo ::	5. Y/N To import source for the WindRiver_Components 
echo ::	6. Y/N To import source for the Tracker.vx
echo ::		
echo ::	
echo :: Example:
echo ::	SvnExport_SBC.bat tags 1400 1.3.25_src Y Y Y N- Import all        
echo ::	SvnExport_SBC.bat tags 1400 1.3.25_src S S S - Skip Import ANY
echo ::	SvnExport_SBC.bat tags 1400 1.3.25_src N N N S - SKIP Import All
echo :: SvnExport_SBC.bat tags 1400 1.3.25_src S S Y N- Import ONLY Tracker139
echo ::		
echo ::
echo :: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
goto END
::
::
:: 
:Proc
if "%1"=="1" (SET txt=Processing)
if "%1"=="2" (SET txt=Deleting)

SET String=""

:LP
   if "%3"=="1" (SET String=%SVNREL%)
   if "%3"=="2" (SET String=%Vx%)
   if "%3"=="3" (SET String=%Components%)
   if "%3"=="4" (SET String=Tracker139)
   
   :: echo Proc: Command: %String% >NUL
   if "%1"=="1" (
    echo.
    echo %txt% Phase %3 :: ../%String%   
   )
   
   if "%1"=="2" (
    echo %txt%:: ../%String% 
	Call :DelFle %String%
    if /I "%ERRORLEVEL%" EQU "1" (Call :DelErr %string%)
    echo.
   )

:Ex
goto END

:SvnIni
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: SVN init
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: echo in SvnIni
:: echo %ProjBldDir%%SVNREL%
:: echo PP: %SVNLSTCMD%/%SVNDIR%/%SVNREL% :: %FilePath%%FileName%

%SVNLSTCMD%/%SVNDIR%/%SVNREL% >Nul

if /I "%ERRORLEVEL%" EQU "1"(goto RepoErr)
if /I "%ERRORLEVEL%" EQU "0"(echo SVN Repository Available/Access)
echo.
echo SVN repository Initialized 
echo.
:: echo "Connected to SVN repository at URL 'https://davms120131.core.drs.master/' "
:: echo "Processing Continues"

goto END

:Phase1
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: PHASE1
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

C:
cd %ProjBldDir%\

Call :HndlDir %ProjBldDir%%SVNREL%

:: echo Importing %SVNREL%
:: echo %SVNEXPCMD%/%SVNDIR%/%SVNREL% %SVNREL%
%SVNEXPCMD%/%SVNDIR%/%SVNREL% %SVNREL% >Nul

:Skip2
echo.
if EXIST %ProjBldDir%%SVNREL% (echo Created Successfully: "%ProjBldDir%%SVNREL%")

C:
cd %ProjBldDir%\

if NOT EXIST %ProjBldDir%%SVNREL%\WORKSPACES (goto :Mdir)
if EXIST %ProjBldDir%%SVNREL%\WORKSPACES (Call :DelFle "%ProjBldDir%%SVNREL%\WORKSPACES")
:Mdir

mkdir %ProjBldDir%%SVNREL%\WORKSPACES

if NOT EXIST %ProjBldDir%%SVNREL%\WORKSPACES (Call :CrtErr %ERRORLEVEL%)
if EXIST %ProjBldDir%%SVNREL%\WORKSPACES (echo Created Successfully: "%ProjBldDir%%SVNREL%\WORKSPACES")

C:
cd %ProjBldDir%\%SVNREL%

:: Call :HndlDir %ProjBldDir%%SVNREL%/workspace_ASP

goto SKP1
:: echo Executing xcopy /s /q /Y /I %ProjBldDir%BUILD_MANAGER\workspace_ASP %ProjBldDir%%SVNREL%
xcopy /s /q /Y /I %ProjBldDir%BUILD_MANAGER\workspace_ASP %ProjBldDir%%SVNREL%\workspace_ASP  >NUL
if EXIST %ProjBldDir%%SVNREL%\workspace_ASP (echo Created Successfully: "%ProjBldDir%%SVNREL%\workspace_ASP")
if NOT EXIST %ProjBldDir%%SVNREL%\workspace_ASP (Call :CopyErr 1)
:SKP1
echo.
echo "Completed Processing - Phase 1." 
EXIT /B %ERRORLEVEL%
goto END

:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: PHASE2
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:Phase2

C:
cd %WindRiverDir%/

Call :HndlDir %WindRiverDir%/%Vx%
:: echo.
:: echo Processing: %SVNEXPCMD%/%SVNDIR%/%SVNREL%/%Vx% %WindRiverDir%%Vx%
%SVNEXPCMD%/%SVNDIR%/%SVNREL%/%Vx% %WindRiverDir%%Vx%  >Nul
if /I "%ERRORLEVEL%" EQU "1" (Call :DelErr %Vx%)
:PH2A
if EXIST "%WindRiverDir%/%Vx%" (echo Imported ...\VxWorks-6.9)


cd %WindRiverDir%/

Call :HndlDir %WindRiverDir%%Components%
:: echo.
:: echo Ph2-Processing: %SVNEXPCMDF%/%SVNDIR%/%SVNREL%/%WRC% %WindRiverDir%%Components%
%SVNEXPCMDF%/%SVNDIR%/%SVNREL%/%WRC% %WindRiverDir% >Nul
if /I "%ERRORLEVEL%" EQU "1" (Call :DelErr %Components%)
if EXIST "%WindRiverDir%%Components%" (echo Imported ..\WindRiver Components)
:: echo.
echo "Completed Processing - Phase 2."
EXIT /B %ERRORLEVEL%
goto END

:Phase3
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: PHASE3
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

:: START Tracker139 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
C:
cd %ProjBldDir%%SVNREL%

Call :HndlDir %ProjBldDir%%SVNREL%\Tracker139

:: echo Moving to Dir: %ProjBldDir%%SVNREL%

cd %ProjBldDir%%SVNREL%
md %ProjBldDir%%SVNREL%\Tracker139
::if NOT EXIST "%ProjBldDir%%SVNREL%\Tracker139" (goto mkdrErr)
:: SET SVNEXPCMD=svn export %SVN_CNTRLREPO2%
:: echo - PH3-1 %SVNEXPCMD3% %ProjBldDir%\%SVNREL%\Tracker139
cd %ProjBldDir%%SVNREL%
cd Tracker139
:: echo %SVNEXPCMD3% %ProjBldDir%\%SVNREL%\Tracker139
%SVNEXPCMD3% %ProjBldDir%\%SVNREL%\Tracker139 >Nul
if /I "%ERRORLEVEL%" EQU "1" (Call :SvnErr2 Tracker139)
if EXIST "%ProjBldDir%%SVNREL%\Tracker139" (echo Imported ....\Tracker139)

:: END Tracker139 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

:PH3A
goto SKPW3
:: START workspace3 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
if NOT EXIST "%ProjBldDir%%SVNREL%/Tracker139/workspace3" (goto SKPW3)
:: echo Calling: %ProjBldDir%%SVNREL%\T2\workspace3

Call :DelFle %ProjBldDir%%SVNREL%/Tracker139/workspace3
echo.
if NOT EXIST "%ProjBldDir%%SVNREL%/Tracker139/workspace3" (goto SKPW3) 
if EXIST "%ProjBldDir%%SVNREL%/Tracker139/workspace3 (echo Error on Deleting File: "%ProjBldDir%%SVNREL%/Tracker139/workspace3")
if EXIST "%ProjBldDir%%SVNREL%/Tracker139/workspace3 (goto END)
:SKPW3
::echo Moving to Dir: %ProjBldDir%%SVNREL%\T2
C:
::cd %ProjBldDir%%SVNREL%\T2
cd %ProjBldDir%%SVNREL%
cd Tracker139
:: echo %SVNEXPCMD%/%SVNDIR%/%SVNREL%/T2/workspace3 workspace3
:: echo - PH3-2 %SVNEXPCMD%/%SVNDIR%/%SVNREL%/T2/workspace3 workspace3 
:: echo Executing %SVNEXPCMD%/%SVNDIR%/%SVNREL%/T2/workspace3 workspace3

%SVNEXPCMD%/%SVNDIR%/%SVNREL%/T2/workspace3 workspace3>Nul

if EXIST "%ProjBldDir%%SVNREL%/Tracker139/workspace3" (echo Imported ....\workspace3)

if /I "%ERRORLEVEL%" EQU "1" (Call :SvnErr %SVNREL%)
echo.
:: END workspace3 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

if NOT EXIST "C:\DAIRCM\BUILDS\J_MW_Cshell_SBC\BUILD_MANAGER\T3TrackerSettings.h" (goto DntErr)
cp C:\DAIRCM\BUILDS\J_MW_Cshell_SBC\BUILD_MANAGER\T3TrackerSettings.h %ProjBldDir%%SVNREL%/Tracker139/workspace3/T3AppTracker/source/.

if /I "%ERRORLEVEL%" EQU "1" (Call :CopyErr2 %SVNREL%)
echo "Completed Processing - Phase 3" 

EXIT /B %ERRORLEVEL%
goto END
::
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: Rountine for Verify the Inputs
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

:ChkIput
SET space=no
SET str=%~1V
for /f "tokens=2" %%a in ("%str%") do (SET char=%%b)
if "!char!"=="" goto :cntue
SET space=yes
@echo on
if "%space%"=="yes" (echo  Input Contains Space, No spaces Allowed)
@echo off
SET space=no
   
:cntue
goto %LBL%
goto EOF

:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: Routine for Time Stamp
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

:Tstamp
echo %DATE% %TIME%
goto :EOF

:HndlDir
SET FlePthName="%1" 
if NOT EXIST %FlePthName% (goto Skip)
if EXIST %FlePthName% (Call :DelFle %FlePthName%)

if NOT EXIST %FlePthName% (goto Skip)
if EXIST %FlePthName% (Call :Proc 2 1 1) 
if EXIST %FlePthName% (Call :DelErr 2)
:Skip
EXIT /B 
goto :EOF


:DelFle 
:: echo in DelFle
:: echo received %1
:: echo Deleting Command rd /q /s %1
rd /q /s %1
echo.
:: echo ERROR="%ERRORLEVEL%"
:: if NOT EXIST %1 (echo File Deleted: %1)
if NOT EXIST %1 (goto Skp)
if EXIST %1 (Call :DelErr %1)
:Skp
EXIT /B %ERRORLEVEL%
goto :EOF
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: Routine for Time Stamp
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:SkipComp
echo ** Skipping Complete Export - As Requested - @ **
Call :Tstamp
goto End

:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: Routine for SVN ERROR MSG
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:RepoErr
SET Err="%1" 
echo SvnErr: SVN Repository NOT Available on %Err%
Call EXIT %Err%
goto END
:SvnErr 
SET Err="%1" 
echo SvnErr: SVN Export Error on Tracker139 %Err%
Call EXIT %Err%
goto END
:SvnErr2 
SET Err="%1" 
echo SvnErr: SVN Export Error on %Err%
Call EXIT %Err%
goto END
::
:DeltErr
SET err=%~1
echo DeltErr: Error on Deleting %ProjBldDir%/%SVNREL%/workspace_ASP -
Call EXIT %Err%
goto END

:DelErr 
::echo in DelErr: %1
SET err=%~1
if "%1"=="1" Set Str=%SVNREL%
if "%1"=="2" Set Str=%WindRiverDir%\%Vx% 
if "%1"=="3" Set Str=Unknown
echo DelErr: Error on Deleting %1
Call EXIT %err%
goto END

:DntErr
SET Err="%1" 
echo DOES NOT EXIST File T3TrackerSettings.h 
Call EXIT %Err%
goto END


:CopyErr2
SET Err="%1" 
echo CopyErr: Error on Copying File T3TrackerSettings.h 
Call EXIT %Err%
goto END

:CopyErr
SET Err="%1" 
echo CopyErr: Error on Copying %ProjBldDir%/%SVNREL%/workspace_ASP
Call EXIT %Err%
goto END

:mkdrErr
SET Err="%1" 
echo Mkdir: Error on Creating %ProjBldDir%/%SVNREL%/Tracker139

goto END

:CrtErr
SET Err="%1" 
echo CrtErr: Error on Creating %SVNREL%\WORKSPACES
Call EXIT %Err%
goto END

:EOF
:END

