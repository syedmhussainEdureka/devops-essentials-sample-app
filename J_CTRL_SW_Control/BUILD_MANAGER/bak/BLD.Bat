@ECHO OFF

SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
::
SET EclipseDir="C:\ti\ccsv5\eclipse\eclipsec"
SET ProjBldDir=E:\DAIRCM\BUILDS\Controls_CSCI\J_CTRL_SW\
SET RleaseNum=Build_09E7
SET WorkSpace=WORKSPACES
SET WorkspaceDir=%ProjBldDir%\%RleaseNum%\%WorkSpace%
SET LocationDir=%ProjBldDir%%RleaseNum%\BUILD_MANAGER\ARM_ONLY



SET AisgenDir="E:\Apps\AISgen for D800K008\AISgen_d800k008.exe"

SET AISFileDir=E:\DAIRCM\BUILDS\Controls_CSCI\J_CTRL_SW\Build_09E7\

SET AISFile="1.0_Release_Config.cfg"



Goto AIS

:BLD
SET ConfigType=Debug

for %%a in (bareMetalDSP
            omap_arm) do (
SET Project=%%a
Echo "**************** !Project! ****************"
CALL :LoadProject %EclipseDir% %WorkspaceDir% %LocationDir% !Project!
CALL :CleanProjectALL %EclipseDir% %WorkspaceDir% !Project! %ConfigType%
CALL :BuildProject %EclipseDir% %WorkspaceDir% !Project! %ConfigType%
)


:AIS

ECHO ** %AisgenDir% -cfg=%AISFileDir%/%AISFile% **

:: Generate the Binary from ARM.out and DSP-v500.out Files
%AisgenDir% -cfg=%AISFileDir%/%AISFile%



IF /I "%ERRORLEVEL%" EQU "1" goto AISError

ECHO "omap_arm_Debug.bin" Generated Successfully

Echo "Check Current Dir for bin and Log Files" 

::End of main logic

EXIT /B %ERRORLEVEL%

:: 
:LoadProject
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

:CleanProjectALL
SET EDir=%~1
SET WDir=%~2
SET Projct=%~3
SET CfgTyp=%~4
SET CleanCMD=%EDir% -noSplash -data %WDir% -application com.ti.ccstudio.apps.projectBuild -ccs.projects %Projct% -ccs.clean -ccs.configuration %cfgTyp% -ccs.autoImport
ECHO %CleanCMD%
%CleanCMD%
IF /I "%ERRORLEVEL%" EQU "1" goto CleanError
Exit /B
GOTO END
:BuildProject
SET EDir=%~1
SET WDir=%~2
SET Projct=%~3
SET CfgTyp=%~4
SET BuildCMD=%EDir% -noSplash -data %WDir% -application com.ti.ccstudio.apps.projectBuild -ccs.projects %Projct% -ccs.FullBuild -ccs.configuration %cfgTyp% -ccs.autoImport
ECHO %BuildCMD%
%BuildCMD%
IF /I "%ERRORLEVEL%" EQU "1" goto BuildError
Exit /B
GOTO END
:ImportError
Echo "Import Error" - Exiting
goto END
:CleanError
Echo "Clean Error" - Exiting
goto END
:AISError
Echo "AISError: Binary Generation - Exiting"
:END