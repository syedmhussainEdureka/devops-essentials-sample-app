@ECHO OFF

SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
::
SET EclipseDir="C:\ti\ccsv5\eclipse\eclipsec"
SET ProjBldDir=E:\DAIRCM\BUILDS\Controls_CSCI\J_CTRL_SW
SET RleaseNum=%~1
SET WorkSpace=WORKSPACES
SET WorkspaceDir=%ProjBldDir%\%RleaseNum%\%WorkSpace%
SET LocationDir=%ProjBldDir%\%RleaseNum%\ARM_ONLY
SET ProjectList="bareMetalDSP omap_arm AIS"

SET AisgenDir="E:\Apps\AISgen for D800K008\AISgen_d800k008.exe"

SET AISFileDir=%ProjBldDir%\%RleaseNum%\ARM_ONLY


SET AISFile=Release_Config.cfg
set argCount=0

for %%x in (%*) do (
   set /A argCount+=1
)

if "%1"=="" (call :help && exit /b 1)
if "%2"=="" (call :help && exit /b 1)

if "!ProjectList:%~2=!"=="!ProjectList!" (goto InpError)
SET Project=%~2
if "!Project!"=="AIS" (goto AISG)

:BLD
SET ConfigType=Debug

Echo "**************** !Project! ****************"
CALL :LoadProject %EclipseDir% %WorkspaceDir% %LocationDir% !Project!
CALL :CleanProjectALL %EclipseDir% %WorkspaceDir% !Project! %ConfigType%
CALL :BuildProject %EclipseDir% %WorkspaceDir% !Project! %ConfigType%
goto END


:AISG
ECHO ** %AisgenDir% -cfg=%AISFileDir%\%RleaseNum%\%AISFile% **
 
CALL :FixAisGenFile %RleaseNum% %AISFile%

:: Generate the Binary from ARM.out and DSP-v500.out Files

if EXIST %ProjBldDir%\%RlNum%\omap_arm_Debug.bin (
del %ProjBldDir%\%RlNum%\omap_arm_Debug.bin
if /I "%ERRORLEVEL%" EQU "1" goto AISError2
)

SET AISFileDir=%ProjBldDir%\%RleaseNum%\ARM_ONLY


SET AISFile=Release_Config.cfg

echo "Executing :" %AisgenDir% -cfg=%AISFileDir%\%AISFile%


%AisgenDir% -cfg=%AISFileDir%\%AISFile%

::ECHO ERR=%ERRORLEVEL%
if /I "%ERRORLEVEL%" EQU "1" goto AISError

if NOT EXIST %ProjBldDir%\%RlNum%\omap_arm_Debug.bin (goto AISGErr)

ECHO "omap_arm_Debug.bin" Generated Successfully

Echo "Check Current Dir for bin and Log Files" 



::End of main logic


goto END
:: 
::+++++++++++++
:LoadProject
::+++++++++++++
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
::+++++++++++++
:CleanProjectALL
::+++++++++++++
SET EDir=%~1
SET WDir=%~2
SET Projct=%~3
SET CfgTyp=%~4
SET CleanCMD=%EDir% -noSplash -data %WDir% -application com.ti.ccstudio.apps.projectBuild -ccs.projects %Projct% -ccs.clean -ccs.configuration %cfgTyp% -ccs.autoImport
ECHO %CleanCMD%
%CleanCMD%
Echo ERR=%ERRORLEVEL%
::IF /I "%ERRORLEVEL%" EQU "1" goto CleanError
Exit /B
GOTO END
::+++++++++++++
:BuildProject
::+++++++++++++
SET EDir=%~1
SET WDir=%~2
SET Projct=%~3
SET CfgTyp=%~4
SET BuildCMD=%EDir% -noSplash -data %WDir% -application com.ti.ccstudio.apps.projectBuild -ccs.projects %Projct% -ccs.FullBuild -ccs.configuration %cfgTyp% -ccs.autoImport
ECHO %BuildCMD%
%BuildCMD%
Echo ERR=%ERRORLEVEL%
::IF /I "%ERRORLEVEL%" EQU "1" goto BuildError
Exit /B
GOTO END
::+++++++++++++
:FixAisGenFile
::+++++++++++++
SET RlNum=%~1
SET ASFle=~2
if NOT EXIST %ProjBldDir%\%RlNum%\ARM_ONLY\*.cfg (goto CfgErr)
:: Copy The *.CFG to Release_Config.cfg
if EXIST %ProjBldDir%\%RlNum%\ARM_ONLY\Release_Config.cfg (
cd  %ProjBldDir%\%RlNum%\ARM_ONLY\
del Release_Config.cfg
if /I "%ERRORLEVEL%" EQU "1" goto RmError
)
Copy %ProjBldDir%\%RlNum%\ARM_ONLY\*.cfg %ProjBldDir%\%RlNum%\ARM_ONLY\Release_Config.cfg >NUL
:: Delete the Last Two Lines

cd %ProjBldDir%\%RlNum%\ARM_ONLY
sed '/App/d' %ProjBldDir%\%RlNum%\ARM_ONLY\Release_Config.cfg > %ProjBldDir%\%RlNum%\ARM_ONLY\Release_Config1.cfg
if /I "%ERRORLEVEL%" EQU "1" goto SedError
sed '/AIS/d' %ProjBldDir%\%RlNum%\ARM_ONLY\Release_Config1.cfg > %ProjBldDir%\%RlNum%\ARM_ONLY\Release_Config.cfg
if /I "%ERRORLEVEL%" EQU "1" goto SedError
del %ProjBldDir%\%RlNum%\ARM_ONLY\Release_Config1.cfg

:: Replace the Deleted Lines

echo App File String=%ProjBldDir%\%RlNum%\ARM_ONLY\omap_arm\Debug\omap_arm.out;%ProjBldDir%\%RlNum%\ARM_ONLY\bareMetalDSP\Debug\bareMetalDSP.out@0x00000000>  %ProjBldDir%\%RlNum%\ARM_ONLY\one.cfg
if /I "%ERRORLEVEL%" EQU "1" goto Wrt1Error
echo AIS File Name=%ProjBldDir%\%RlNum%\omap_arm_Debug.bin>>  %ProjBldDir%\%RlNum%\ARM_ONLY\one.cfg
if /I "%ERRORLEVEL%" EQU "1" goto Wrt2Error
Type %ProjBldDir%\%RlNum%\ARM_ONLY\one.cfg >> %ProjBldDir%\%RlNum%\ARM_ONLY\Release_Config.cfg
del %ProjBldDir%\%RlNum%\ARM_ONLY\one.cfg
Exit /B
GOTO END
::+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

:EOF
:Help
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