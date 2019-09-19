@ECHO OFF
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

:: This script requires that the coverity bin folder is added to PATH
SET CovDir=%cd%
SET WorkspaceDir=workspace3

SET oneDir=bareMetalDSP
SET twoDir=omap_arm

SET ProcessorArch=PENTIUM4diab_SMP
SET ParseWarnFile=daircm_parse_warnings.conf
SET DisableCheckers=--disable UNUSED_VALUE --disable NO_EFFECT --disable DEADCODE --disable CHECKED_RETURN --disable UNINIT

SET IsAnalyzingAll=%1

SET EnableChecks=E
SET IsEnablingChecks=%2
IF !IsEnablingChecks!==!EnableChecks! (
    echo Enable All Checkers
    SET DisableCheckers=
)

REM SET CovDir=%~1

SET ParseWarnPath=%CovDir%/%ParseWarnFile%

SET ParseWarnCmd=

CALL :initCoverityWorkspace %CovDir% %ReprogramDir%

echo ../%WorkspaceDir%
cd ../%WorkspaceDir%
SET WS3Path=%cd%

:: Clean all of the projects in the repository
for /d %%I in (!WS3Path!\*) do (

    SET ProjectPath=%%I\!ProcessorArch!
    SET MakePath=!ProjectPath!\Makefile

    IF EXIST "!MakePath!" (
	 echo !ProjectPath!
     cd !ProjectPath!
     make clean
    )
);

CALL :coverityAnalyzeFormat %WS3Path% %ReprogramDir% %CovDir% %IsAnalyzingAll%


::End of main logic
EXIT /B %ERRORLEVEL%

:: build and analyze files 1st arg is the WS3 Directory 2nd is the project directory 3rd is the coverity directory
:coverityAnalyzeFormat

set regValue=.*/

SET WS3Path=%~1
SET ProjDir=%~2
SET CovDir=%~3
SET AnalyzeAll=%~4
SET VersionFile=SBC_Version.txt

:: Analyze the T3AppTracker project
echo Analyze %ProjDir%
echo %WS3Path%/%ProjDir%
cd %WS3Path%/%ProjDir%

set addValue=
set includeFile=--include-files (
for /f "delims=" %%i in ('svn status') do (
    set fileStat=%%i
    IF "!fileStat:~0,1!"=="M" (
        set regVal=!fileStat: =!
        set regVal=!regVal:Msource\=%regValue%!
        IF NOT !regVal!==!regValue!!VersionFile! (
            REM set regVal=!fileStat:M       /source^\=%regValue%!
            SET includeFile=!includeFile!!addValue!^(!regVal!^)
            set addValue=^|
        )
    )
);

SET includeFile=!includeFile!)

IF !AnalyzeAll!==A (
    echo Analyzing All
    SET includeFile=
    SET ParseWarnCmd=--parse-warnings-config %ParseWarnPath%
)

echo !includeFile!
IF "!includeFile!"=="--include-files ()" (
    EXIT /B 0
)

cd PENTIUM4diab_SMP
make clean
cov-build.exe --add-arg --c99 --dir %CovDir%/%ProjDir% --delete-stale-tus --return-emit-failures --fs-capture-search %WS3Path%/%ProjDir%\PENTIUM4diab_SMP make
cov-analyze.exe --all --dir %CovDir%/%ProjDir% --strip-path %WS3Path%/%ProjDir%\PENTIUM4diab_SMP --aggressiveness-level high --enable-fb %DisableCheckers% --enable-parse-warnings !ParseWarnCmd!


cov-format-errors.exe --html-output  %CovDir%\%ProjDir%\output\errors --dir %CovDir%/%ProjDir% --exclude-files .*/RC.* !includeFile!
cd %CovDir%\%ProjDir%
cp -r %CovDir%\%ProjDir%\output\errors\ %CovDir%\

IF EXIST %CovDir%\%ProjDir%_errors (
    rm -r %CovDir%\%ProjDir%_errors
)

mv %CovDir%\errors\ %CovDir%\%ProjDir%_errors\

EXIT /B 0

:: set up workspace 1st arg is the coverity directory 2nd arg is the project directory
:initCoverityWorkspace

SET CovDir=%~1
SET ProjDir=%~2

IF NOT EXIST %CovDir%\%ProjDir% (
    mkdir %ProjDir%
)

IF EXIST %CovDir%\%ProjDir%\output\errors\ (
    rm -r %CovDir%\%ProjDir%\output\errors
)

EXIT /B 0