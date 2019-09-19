@ECHO OFF
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: 	Name of File: Build.bat
::
:: 	Ver: 0.1	Date:12/26/2018
::
::	Author: Syed M Hussain @ DRS
::
::      SEE HELP FOR USAGE
::
::
::+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
SET me=%~n0
SET parent=%~dp0
SET argCount=0

SET EclipseDir="C:\ti\ccsv5\eclipse\eclipsec"
SET ProjBldDir=C:\DAIRCM\BUILDS\J_CTRL_SW_Control\
SET RleaseNum=%~1
SET WorkSpace=WORKSPACES
SET WorkspaceDir=%ProjBldDir%\%RleaseNum%\%WorkSpace%
SET LocationDir=%ProjBldDir%\%RleaseNum%\ARM_ONLY
SET ProjectList="bareMetalDSP omap_arm AIS"

SET AisExe="E:\Apps\AISgen for D800K008\AISgen_d800k008.exe"
SET AISFileDir=%ProjBldDir%\%RleaseNum%\BUILD_MANAGER\ARM_ONLY
SET AISFile=Release_Config.cfg

for %%x in (%*) do (
   SET /A argCount+=1
)

if "%1"=="" (call :help && exit /b 1)
if "%2"=="" (call :help && exit /b 1)

if "!ProjectList:%~2=!"=="!ProjectList!" (goto InpError)
SET Project=%~2
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: Time Stamp Start of Process
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo "Processing Started @"
Call :Tstamp
SET tStr=%Time%
SET f1name=!tStr!_null
SET f2name=!tStr!_null
if "!Project!"=="AIS" (goto AISG)
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:BLD
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
SET ConfigType=Debug

echo "**************** Processing !Project! ****************"
echo ":LoadProject %EclipseDir% %WorkspaceDir% %LocationDir% !Project!"

CALL :LoadProject %EclipseDir% %WorkspaceDir% %LocationDir% !Project!

CALL :CleanProjectALL %EclipseDir% %WorkspaceDir% !Project! %ConfigType%
CALL :BuildProject %EclipseDir% %WorkspaceDir% !Project! %ConfigType%
goto END

:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:AISG
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
ECHO ** ASEXE:%AisExe% -cfg=%AISFileDir%\%AISFile% **

::CALL :FixAisGenFile %RleaseNum% %AISFile% %AisExe% %AISFileDir%\%AISFile%

:: Generate the Binary from ARM.out and DSP-v500.out Files

if EXIST %ProjBldDir%\%RlNum%\omap_arm_Debug.bin (
del %ProjBldDir%\%RlNum%\omap_arm_Debug.bin
if /I "%ERRORLEVEL%" EQU "1" goto AISError2
)


echo "Executing :" %AisExe% -cfg=%AISFileDir%\%AISFile%

%AisExe% -cfg=%AISFileDir%\%AISFile%

::ECHO ERR=%ERRORLEVEL%
if /I "%ERRORLEVEL%" EQU "1" goto AISError

:: if NOT EXIST %ProjBldDir%\%RlNum%\omap_arm_Debug.bin (goto AISGErr)

ECHO "omap_arm_Debug.bin" Generated Successfully
Echo "Check Current Dir for bin and Log Files" 
Echo "Completed Processing" 
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
SET EDir=%~1
SET WDir=%~2
SET LDir=%~3
SET Projct=%~4
ECHO RECEIVED: -- %EDir% --  -- %PDir% -- -- %LDir% -- %WDir% -- %Projct%

::SET ImportCMD=%EDir% -noSplash -data %WDir% -application com.ti.ccstudio.apps.projectImport -ccs.location %LDir%/ARM_ONLY\%Projct%

SET ImportCMD=%EDir% -noSplash -data %WDir% -application com.ti.ccstudio.apps.projectImport -ccs.location %LDir%\%Projct%
ECHO ** %ImportCMD% **
GOTO END
%ImportCMD% 2^>NUL
IF /I "%ERRORLEVEL%" EQU "1" goto ImportError
Exit /B
GOTO END

:: REM ++++++++++++++++++++++++++++++++++++++++++++
:CleanProjectALL
:: REM ++++++++++++++++++++++++++++++++++++++++++++

SET EDir=%~1
SET WDir=%~2
SET Projct=%~3
SET CfgTyp=%~4
SET CleanCMD=%EDir% -noSplash -data %WDir% -application com.ti.ccstudio.apps.projectBuild -ccs.projects %Projct% -ccs.clean -ccs.configuration %cfgTyp% -ccs.autoImport
ECHO %CleanCMD%
%CleanCMD%
:: Echo ERR=%ERRORLEVEL%
::IF /I "%ERRORLEVEL%" EQU "1" goto CleanError
Exit /B
GOTO END
:: REM ++++++++++++++++++++++++++++++++++++++++++++
:BuildProject
:: REM ++++++++++++++++++++++++++++++++++++++++++++
SET EDir=%~1
SET WDir=%~2
SET Projct=%~3
SET CfgTyp=%~4
SET BuildCMD=%EDir% -noSplash -data %WDir% -application com.ti.ccstudio.apps.projectBuild -ccs.projects %Projct% -ccs.FullBuild -ccs.configuration %cfgTyp% -ccs.autoImport
ECHO %BuildCMD%
%BuildCMD%
:: Echo ERR=%ERRORLEVEL%
::IF /I "%ERRORLEVEL%" EQU "1" goto BuildError
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
:: CALL :FixAisGenFile %RleaseNum% %AISFile% %AisExe% %AISFileDir%\%AISFile%

SET RlNum=%~1
SET ASFle=%~2
SET ASDir=%~3
SET ASCNF=%~4
echo.
echo RECEIVED: RL:%RlNum% CFGFLE:%ASFle% ASD:%ASDir%  AFG:%ASCNF%
echo.
goto END

if NOT EXIST %ASDir%\*.cfg (goto CfgErr)
:: Copy The *.CFG to Release_Config.cfg
if EXIST %ASDir%\Release_Config.cfg (
cd  %ASDir%
del Release_Config.cfg
if /I "%ERRORLEVEL%" EQU "1" goto RmError
)
Copy %ASDir%\*.cfg Release_%ASDir%\Config.cfg >NUL
:: Delete the Last Two Lines

cd %ASDir%
sed '/App/d' %ProjBldDir%\%RlNum%\BUILD_MANAGER\ARM_ONLY\Release_Config.cfg > %ProjBldDir%\%RlNum%\BUILD_MANAGER\ARM_ONLY\Release_Config1.cfg
if /I "%ERRORLEVEL%" EQU "1" goto SedError
sed '/AIS/d' %ProjBldDir%\%RlNum%\BUILD_MANAGER\ARM_ONLY\Release_Config1.cfg > %ProjBldDir%\%RlNum%\BUILD_MANAGER\ARM_ONLY\Release_Config.cfg
if /I "%ERRORLEVEL%" EQU "1" goto SedError
del %ProjBldDir%\%RlNum%\BUILD_MANAGER\ARM_ONLY\Release_Config1.cfg

:: Replace the Deleted Lines

echo App File String=%ProjBldDir%\%RlNum%\BUILD_MANAGER\ARM_ONLY\omap_arm\Debug\omap_arm.out;%ProjBldDir%\%RlNum%\BUILD_MANAGER\ARM_ONLY\bareMetalDSP\Debug\bareMetalDSP.out@0x00000000>  %ProjBldDir%\%RlNum%\ARM_ONLY\one.cfg
if /I "%ERRORLEVEL%" EQU "1" goto Wrt1Error
echo AIS File Name=%ProjBldDir%\%RlNum%\omap_arm_Debug.bin>>  %ProjBldDir%\%RlNum%\ARM_ONLY\one.cfg
if /I "%ERRORLEVEL%" EQU "1" goto Wrt2Error
Type %ProjBldDir%\%RlNum%\ARM_ONLY\one.cfg >> %ProjBldDir%\%RlNum%\ARM_ONLY\Release_Config.cfg
del %ProjBldDir%\%RlNum%\ARM_ONLY\one.cfg
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
echo ::		This batch file will build the complete ** Controls Project ** given the 
echo ::		The Release and the Project
echo ::
echo :: 	Input Required: 
echo ::		1. Release - Release String
echo ::		2. Project Name
echo :: 		
echo ::		
echo ::
echo ::		Example:
echo ::		%me%.bat Build_09E7_6_11_18 omap_arm
echo ::		%me%.bat Build_09E7_6_11_18 bareMetalDSP
echo ::		%me%.bat Build_09E7_6_11_18 AIS
echo ::		
echo ::
echo :: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
goto END
:: REM ++++++++++++++++++++++++++++++++++++++++++++
:: ERROR HANDLING
:: REM ++++++++++++++++++++++++++++++++++++++++++++
:ImportError
Echo "Import Error" - Exiting
goto ENDERR
:CleanError
Echo "Clean Error" - Exiting
goto ENDERR

:CfgErr
Echo "CFG File missing" - Exiting
goto ENDERR

:AISError

Echo "AISError: Binary Generation - Exiting"
goto ENDERR
:AISError2

Echo "AISError2: Del binary File Error - Exiting"
goto ENDERR
:AISGErr
Echo "AISGError: bin Generation - Exiting"
goto ENDERR
:InpError
Echo "Input Error - Exiting"
goto ENDERR
:RmErr
Echo "Delete Error on CFG File - Exiting"
goto ENDERR
:Wrt1Error
Echo "UPdating Config File - First Line - Exiting
goto ENDERR
:Wrt2Error
Echo "UPdating Config File - First Line - Exiting
goto ENDERR 
:SedErr
Echo "Error on Sed - Exiting
goto ENDERR
:ENDERR
SET ERRORLEVEL=1
EXIT /B 1
:END