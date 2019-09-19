SETLOCAL ENABLEEXTENSIONS
SETLOCAL ENABLEDELAYEDEXPANSION
goto bld
echo Calling ** Pre_Build_OFP.bat **
## Call Pre_Build_OFP.bat D 2134 N N
if /I "%ERRORLEVEL%" EQU "1" goto END
echo Calling ** GenCfg_OFP.bat **
## Call GenCfg_OFP.bat D 2134 2 N N
if /I "%ERRORLEVEL%" EQU "1" goto END
echo Calling ** Build_OFP.bat **
:bld
Call Build_OFP.bat 2134 O R D N
if /I "%ERRORLEVEL%" EQU "1" goto END
echo Calling ** Post_Build_OFP.bat **
Call Post_Build_OFP.bat 2134 N N
if /I "%ERRORLEVEL%" EQU "1" goto END
echo All Done
:End