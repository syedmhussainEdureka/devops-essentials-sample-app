@ECHO OFF
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: 	Name of File: Build_Tracker.bat
::
:: 	Ver: 0.1	Date:01/14/2019
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
SET RleaseNum=%~1
SET ProjBldDir=E:\DAIRCM\BUILDS\SBC_CSCI\J_MW_Cshell\%RleaseNum%\Tracker139\T2\libT2
SET CygwinInstallDir=E:\Apps\cygwin64
SET CygwinbinDir=%CygwinInstallDir%\bin
SET CleanCMD=make clean
SET BuildCMD=make vxworks
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: Time Stamp Start of Process
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo "Processing Started @"
Call :Tstamp
SET tStr=%Time%
SET f1name=!tStr!_null
SET f2name=!tStr!_null

:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:BLD
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
SET ConfigType=Debug

Echo "**************** Processing !Project! ****************"
::CALL :LoadProject %EclipseDir% %WorkspaceDir% %LocationDir% !Project!
CALL :CleanProjectALL 
CALL :BuildProject 
goto END



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
::ECHO RECEIVED: -- %EDir% --  -- %PDir% -- -- %LDir% -- %WDir% -- %Projct%

::SET ImportCMD=%EDir% -noSplash -data %WDir% -application com.ti.ccstudio.apps.projectImport -ccs.location %LDir%/ARM_ONLY\%Projct%

SET ImportCMD=%EDir% -noSplash -data %WDir% -application com.ti.ccstudio.apps.projectImport -ccs.location %LDir%\%Projct%
ECHO ** %ImportCMD% **

%ImportCMD% 2^>NUL
IF /I "%ERRORLEVEL%" EQU "1" goto ImportError
Exit /B
GOTO END

:: REM ++++++++++++++++++++++++++++++++++++++++++++
:CleanProjectALL
:: REM ++++++++++++++++++++++++++++++++++++++++++++
cd C:\data\Tracker139\T2\libT2
SET CygwinbinDir=%CygwinInstallDir%\bin
SET CleanCMD=make clean
SET CMD=%CygwinbinDir% %CleanCMD%
ECHO %CMD%
%CMD%
Echo ERR=%ERRORLEVEL%
::IF /I "%ERRORLEVEL%" EQU "1" goto CleanError
Exit /B
GOTO END
:: REM ++++++++++++++++++++++++++++++++++++++++++++
:BuildProject
:: REM ++++++++++++++++++++++++++++++++++++++++++++
cd C:\data\Tracker139\T2\libT2
SET CygwinbinDir=%CygwinInstallDir%\bin
SET BuildCMD=make clean
SET CMD=%CygwinbinDir% %CMD%
ECHO %CMD%
%CMD%
ECHO %BuildCMD%
%BuildCMD%
Echo ERR=%ERRORLEVEL%
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
SET RlNum=%~1
SET ASFle=~2
if NOT EXIST %ProjBldDir%\*.cfg (goto CfgErr)
:: Copy The *.CFG to Release_Config.cfg
if EXIST %ProjBldDir%\%RlNum%\Release_Config.cfg (
cd  %ProjBldDir%\%RlNum%
del Release_Config.cfg
if /I "%ERRORLEVEL%" EQU "1" goto RmError
)
echo Copying: %ProjBldDir%\*.cfg %ProjBldDir%\%RlNum%\Release_Config.cfg
Copy %ProjBldDir%\*.cfg %ProjBldDir%\%RlNum%\Release_Config.cfg >NUL

:: Delete the Last Two Lines
SET LNE52=App File String=%ProjBldDir%\%RlNum%\ARM\Debug\ARM.out;%ProjBldDir%\%RlNum%\DSP-v500\Debug\DSP-v500.out@0x00000000
SET LNE53=AIS File Name=%ProjBldDir%\%RlNum%\%AISFile%_Debug.bin

cd %ProjBldDir%\%RlNum%

sed '/App/d' %ProjBldDir%\%RlNum%\Release_Config.cfg > %ProjBldDir%\%RlNum%\Release_Config1.cfg
if /I "%ERRORLEVEL%" EQU "1" goto SedError
sed '/AIS/d' %ProjBldDir%\%RlNum%\Release_Config1.cfg > %ProjBldDir%\%RlNum%\Release_Config.cfg
if /I "%ERRORLEVEL%" EQU "1" goto SedError
del %ProjBldDir%\%RlNum%\Release_Config1.cfg

:: Replace the Deleted Lines

echo !LNE52!>%ProjBldDir%\%RlNum%\one.cfg
if /I "%ERRORLEVEL%" EQU "1" goto Wrt1Error
echo !LNE53!>>%ProjBldDir%\%RlNum%\one.cfg
if /I "%ERRORLEVEL%" EQU "1" goto Wrt2Error

Type %ProjBldDir%\%RlNum%\one.cfg >> %ProjBldDir%\%RlNum%\Release_Config.cfg
del %ProjBldDir%\%RlNum%\one.cfg

Copy %ProjBldDir%\%RlNum%\Release_Config.cfg %ProjBldDir%\%RlNum%\%AISFile%_Debug.cfg >NUL


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
echo ::		%me%.bat v3426_ARM_Laser_warning ARM
echo ::		%me%.bat v3426_ARM_Laser_warning DSP-v500
echo ::		%me%.bat v3426_ARM_Laser_warning AIS
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