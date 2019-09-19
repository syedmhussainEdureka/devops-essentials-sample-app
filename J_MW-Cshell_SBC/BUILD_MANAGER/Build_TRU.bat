@echo OFF
setLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: 	Name of File: Build_TRU.bat
::
:: 	Ver: 0.1	Date:01/14/2019
::
::	Author: Syed M Hussain @ DRS
::
::  Description:
::  In the first Phase we will build the following:
::
::   		T3AppTracker.out, 
::			Reprogrammer.out, & 
::			UDFDecoder.out (U)
::
::      SEE HELP FOR USAGE
::
::
::+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
set me=%~n0
set parent=%~dp0
set argCount=0

set RleaseNum=%~2
set WinRvrDIR=C:\windriver
set WrWbBin=C:\WindRiver\workbench-3.3\x86-win32\bin
set Vx=vxworks-6.9
set WinRvrUPD=wrws_update.bat
set ProjBldDir=C:\DAIRCM\BUILDS\J_MW_Cshell_SBC
set PlaceHolder=" "
set BinPath=%ProjBldDir%\%RleaseNum%\T2\workspace3\%PlaceHolder%\PENTIUM4diab_SMP\\Debug\
set WkspName=workspace_ASP
set AspFLDR=%ProjBldDir%\%RleaseNum%\%WkspName%
set Wsp3FLDR=%ProjBldDir%\%RleaseNum%\T2\workspace3

set WorkSpace=WORKSPACES
set WorkspaceDir=%ProjBldDir%\%RleaseNum%\%WorkSpace%
set LocationDir=%ProjBldDir%\%RleaseNum%\
set ProjectList=T3AppTracker Reprogrammer UDFDecoder
set ProjectListVx=vxWorks vxWorks.sym

set CpyCMD=XCOPY /Q /S /E /I  
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: Verify Input 
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo. 
echo Inputs verified: %1 %2 %3 %4

for %%x in (%*) do (
   set /A argCount+=1
)

if "%1"=="" (call :help && exit /b 1)
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
echo ++++++++++++++++++++++++++++++++++++++++++++++++++++
echo "Processing Started @"
Call :Tstamp
set tStr=%Time%

if S==%4 (Call :SkipComp)
if S==%4 (goto END)
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:wkSPACE
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: Setup the workspace for the build.
cd %WorkspaceDir%
echo "Setting up Workspace for Build" 
%CpyCMD% %AspFLDR% %WorkspaceDir% >NUL
echo "                               Workspace_Asp -- Complete"
%CpyCMD% %Wsp3FLDR% %WorkspaceDir% >NUL
echo "                               Workspace3 -- Complete"
%CpyCMD% C:\WindRiver\workspace\.metadata .metadata >NUL
echo " Workspace Complete"
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:BLD
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

echo "**************** Processing  ****************"
CALL :BuildProject 
echo "Please Check the relavent directories for the *.out Files" 
echo "**************** Completed Processing  ****************"

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
::
:: REM ++++++++++++++++++++++++++++++++++++++++++++
:BuildProject
:: REM ++++++++++++++++++++++++++++++++++++++++++++
:: Call C:\windriver\wrenv.exe -p vxworks-6.9 wrws_update.bat -data C:\DAIRCM\BUILDS\J_MW_Cshell\10_1000F000_6_8_18_AM\workspace_ASP -m -b -i
set BuildCMD=Call %WinRvrDIR%\wrenv.exe -p %Vx% %WrWbBin%\%WinRvrUPD% -data %WorkspaceDir% -m -b -i
echo Starting Build : %BuildCMD%

%BuildCMD%
if /I "%ERRORLEVEL%" EQU "0" goto Ext
if /I "%ERRORLEVEL%" EQU "1" goto BuildErr
:Ext
echo ++++++++++++++++++++++++++++++++++++++++++++++++++++
for %%x in (%ProjectList%)  do (
   	echo Checking for %%x.out>NUL
    if NOT EXIST %WorkspaceDir%\%%x\PENTIUM4diab_SMP\%%x\Debug\%%x.out (Call :BldErr %%x.out )
	echo ** File Processed %%x.out **
	)
echo ++++++++++++++++++++++++++++++++++++++++++++++++++++
for %%x in (%ProjectListVx%)  do (
   	echo Checking for %%x >NUL
    if NOT EXIST %WorkspaceDir%\XPedite7501_prj\default\%%x (Call :BldErr %%x)
	echo ** File Processed 	%%x **
	)
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
echo ++++++++++++++++++++++++++++++++++++++++++++++++++++
goto :EOF
:EOF
:Help
echo %parent%%me%.bat *** INVALID ENTRY ***
echo ::
echo :: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo ::	Description:
echo ::		This scrit file will build the following binaries:
echo ::     5.2.3	T3AppTracker.out - T, Reprogrammer.out - R, and UDFDecoder.out -U.
echo ::		The Release and the Project
echo ::
echo :: 	Input Required: 
echo ::		1. Release - Release String
echo ::		2. Project Name
echo :: 		
echo ::		
echo ::
echo ::		Example:
echo ::		%me%.bat 10_1000F000_6_8_18_AM
echo ::
echo :: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
goto END
  		 
:: REM ++++++++++++++++++++++++++++++++++++++++++++
:: ERROR HANDLING
:: REM ++++++++++++++++++++++++++++++++++++++++++++
:AspErr
echo "Missing workspace_ASP Folder" %1 -Exiting
goto ENDERR
:W3Err
echo "Missing workspace3 Folder" %1 -Exiting
goto ENDERR
:BldErr
echo "Build Error" on %1 - Exiting
goto ENDERR
:BuildErr
echo "Build Error"  - Exiting
goto ENDERR
:CleanError
echo "Clean Error" - Exiting
goto ENDERR

:InpError
echo "Input Error - Exiting"
goto ENDERR

:SkipComp
echo "Skipping Build as requested: @"
Call :Tstamp
goto END
:RmErr
echo "Delete Error on CFG File - Exiting"
goto ENDERR
:ENDERR
set ERRORLEVEL=1
EXIT /B 1
:END