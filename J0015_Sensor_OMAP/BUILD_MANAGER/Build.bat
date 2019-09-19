@echo OFF
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: 	Name of File: Build.bat
::
:: 	Ver: 0.1	Date:01/02/2019
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
::set ProjSVN=%~2
set Project=%~3 

set EclipseDir="C:\ti\ccsv5\eclipse\eclipsec"
set ProjBldDir=C:\DAIRCM\BUILDS\J0015_Sensor_OMAP\%RleaseNum%\

set WorkSpace=WORKSPACES

set LocationDir=%ProjBldDir%
set ProjectList="ARM DSP-v500 AIS"

set AisExe="E:\Apps\AISgen for D800K008\AISgen_d800k008.exe"
set AISFileDir=%ProjBldDir%\\
set AISFile=Release_Config


for %%x in (%*) do (
   set /A argCount+=1
)

if "%1"=="" (call :help && exit /b 1)
if "%2"=="" (call :help && exit /b 1)

if "!ProjectList:%~3=!"=="!ProjectList!" (goto InpError)
:: set ProjSVN=%~2
set Project=%~2
echo Inputs: ReleaseNum: %RleaseNum%  Project: %Project%

:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: Time Stamp Start of Process
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo "Processing Started @"
Call :Tstamp
set tStr=%Time%
set f1name=!tStr!_null
set f2name=!tStr!_null
if "!Project!"=="AIS" (goto AISG)
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:BLD
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
set ConfigType=Debug

echo "**************** Processing !Project! ****************"
CALL :GetProjSVN
echo :LoadProject ECDIR:%EclipseDir% WRKSP: %WorkspaceDir% LDIR: %LocationDir% Proj: !Project!
CALL :LoadProject %EclipseDir% %WorkspaceDir% %LocationDir% !Project!
CALL :CleanProjectALL %EclipseDir% %WorkspaceDir% !Project! %ConfigType%
CALL :BuildProject %EclipseDir% %WorkspaceDir% !Project! %ConfigType%
goto END

:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:AISG
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo AISG: ** %AisExe% -cfg=%AISFileDir%%AISFile%.cfg **

CALL :FixAisGenFile %RleaseNum% %AISFile%.cfg

:: Generate the Binary from ARM.out and DSP-v500.out Files

if EXIST %ProjBldDir%\%RleaseNum%\%AISFile%.bin (
del %ProjBldDir%\%RleaseNum%\%AISFile%.bin
if /I "%ERRORLEVEL%" EQU "1" goto AISError2
)

set AISFileDir=%ProjBldDir%\
set AISFile=%AISFile%

:AISG2
echo "Executing :" %AisExe% -cfg=%ProjBldDir%\2129\v1440_ARM_laser_warning\%AISFile%.cfg
%AisExe% -cfg=%ProjBldDir%\2129\v1440_ARM_laser_warning\%AISFile%.cfg

:: echo ERR=%ERRORLEVEL%
if /I "%ERRORLEVEL%" EQU "1" goto AISError

:: if NOT EXIST %ProjBldDir%\%RleaseNum%\%AISFile%_Debug.bin (goto AISGErr)

echo "%AISFile%_Debug.bin" Generated Successfully
echo "Check Current %ProjBldDir% for bin and Log Files" 
echo "Completed Processing" 
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
::::
:: REM ++++++++++++++++++++++++++++++++++++++++++++
:LoadProject
:: REM ++++++++++++++++++++++++++++++++++++++++++++
set EDir=%~1
set WDir=%~2
set LDir=%~3
set Projct=%~4
::echo RECEIVED: -- %EDir% --  -- %PDir% -- -- %LDir% -- %WDir% -- %Projct%

::set ImportCMD=%EDir% -noSplash -data %WDir% -application com.ti.ccstudio.apps.projectImport -ccs.location %LDir%/ARM_ONLY\%Projct%

set ImportCMD=%EDir% -noSplash -data %WDir% -application com.ti.ccstudio.apps.projectImport -ccs.location %LDir%\%Projct%
echo ** %ImportCMD% **

%ImportCMD% 2^>NUL
IF /I "%ERRORLEVEL%" EQU "1" goto ImportError
Exit /B
GOTO END

:: REM ++++++++++++++++++++++++++++++++++++++++++++
:CleanProjectALL
:: REM ++++++++++++++++++++++++++++++++++++++++++++

set EDir=%~1
set WDir=%~2
set Projct=%~3
set CfgTyp=%~4
set CleanCMD=%EDir% -noSplash -data %WDir% -application com.ti.ccstudio.apps.projectBuild -ccs.projects %Projct% -ccs.clean -ccs.configuration %cfgTyp% -ccs.autoImport
echo %CleanCMD%
%CleanCMD%
::echo ERR=%ERRORLEVEL%
::IF /I "%ERRORLEVEL%" EQU "1" goto CleanError
Exit /B
GOTO END
:: REM ++++++++++++++++++++++++++++++++++++++++++++
:BuildProject
:: REM ++++++++++++++++++++++++++++++++++++++++++++
set EDir=%~1
set WDir=%~2
set Projct=%~3
set CfgTyp=%~4
set BuildCMD=%EDir% -noSplash -data %WDir% -application com.ti.ccstudio.apps.projectBuild -ccs.projects %Projct% -ccs.FullBuild -ccs.configuration %cfgTyp% -ccs.autoImport
echo %BuildCMD%
%BuildCMD%
::echo ERR=%ERRORLEVEL%
::IF /I "%ERRORLEVEL%" EQU "1" goto BuildError
Exit /B
GOTO END
:: REM ++++++++++++++++++++++++++++++++++++++++++++
:GetProjSVN
:: REM ++++++++++++++++++++++++++++++++++++++++++++
cd %ProjBldDir%
for /f %%a in (' Dir *.* /B ') do (set projSVN=%%a)
set WorkspaceDir=%ProjBldDir%%ProjSVN%\%WorkSpace%
Exit /B
GOTO END
:: REM ++++++++++++++++++++++++++++++++++++++++++++
:FixAisGenFile
:: REM ++++++++++++++++++++++++++++++++++++++++++++
:: REM ++++++++++++++++++++++++++++++++++++++++++++
:: In this routine we have to Edit the *.cfg - replace the last two lines
:: with the Current Path of the *.out Files and specify the location of the 
:: binary file
:: REM ++++++++++++++++++++++++++++++++++++++++++++
set RlNum=%~1
set ASFle=~2
::: if NOT EXIST %ProjBldDir%\%RlNum%v1440_ARM_laser_warning\ARM\Debug\*.cfg (goto CfgErr)
:: Copy The *.CFG to Release_Config.cfg
::: if EXIST %ProjBldDir%\%RlNum%v1440_ARM_laser_warning\ARM\Debug\*.cfg (
cd  %ProjBldDir%\%RlNum%
::: del Release_Config.cfg
::: if /I "%ERRORLEVEL%" EQU "1" goto RmError
::: )
echo Copying:  %ProjBldDir%v1440_ARM_laser_warning\ARM\Debug\*.cfg %ProjBldDir%Release_Config.cfg
Copy  %ProjBldDir%v1440_ARM_laser_warning\ARM\Debug\*.cfg %ProjBldDir%\Release_Config.cfg

:: Delete the Last Two Lines
set LNE52=App File String=%ProjBldDir%v1440_ARM_laser_warning\ARM\Debug\ARM.out;%ProjBldDir%v1440_ARM_laser_warning\DSP-v500\Debug\DSP-v500.out@0x00000000
set LNE53=AIS File Name=%ProjBldDir%%AISFile%_Debug.bin

cd %ProjBldDir%

sed '/App/d' %ProjBldDir%Release_Config.cfg > %ProjBldDir%\Release_Config1.cfg
if /I "%ERRORLEVEL%" EQU "1" goto SedError
sed '/AIS/d' %ProjBldDir%Release_Config1.cfg > %ProjBldDir%Release_Config.cfg
if /I "%ERRORLEVEL%" EQU "1" goto SedError
del %ProjBldDir%Release_Config1.cfg

:: Replace the Deleted Lines

echo !LNE52!>%ProjBldDir%one.cfg
if /I "%ERRORLEVEL%" EQU "1" goto Wrt1Error
echo !LNE53!>>%ProjBldDir%one.cfg
if /I "%ERRORLEVEL%" EQU "1" goto Wrt2Error

Type %ProjBldDir%one.cfg >> %ProjBldDir%Release_Config.cfg
del %ProjBldDir%one.cfg

Copy %ProjBldDir%Release_Config.cfg %ProjBldDir%%AISFile%_Debug.cfg >NUL


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
echo ::		%me%.bat 2129 ARM
echo ::		%me%.bat 2129 DSP-v500
echo ::		%me%.bat 2129 AIS
echo ::		
echo ::
echo :: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
goto END
  		 
:: REM ++++++++++++++++++++++++++++++++++++++++++++
:: ERROR HANDLING
:: REM ++++++++++++++++++++++++++++++++++++++++++++
:ImportError
echo "Import Error" - Exiting
goto ENDERR
:CleanError
echo "Clean Error" - Exiting
goto ENDERR

:CfgErr
echo "CFG File missing" - Exiting
goto ENDERR

:AISError

echo "AISError: Binary Generation - Exiting"
goto ENDERR
:AISError2

echo "AISError2: Del binary File Error - Exiting"
goto ENDERR
:AISGErr
echo "AISGError: bin Generation - Exiting"
goto ENDERR
:InpError
echo "Input Error - Exiting"
goto ENDERR
:RmErr
echo "Delete Error on CFG File - Exiting"
goto ENDERR
:Wrt1Error
echo "UPdating Config File - First Line - Exiting
goto ENDERR
:Wrt2Error
echo "UPdating Config File - First Line - Exiting
goto ENDERR 
:SedErr
echo "Error on Sed - Exiting
goto ENDERR
:ENDERR
set ERRORLEVEL=1
EXIT /B 1
:END