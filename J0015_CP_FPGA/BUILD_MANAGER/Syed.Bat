SETLOCAL ENABLEEXTENSIONS
SETLOCAL ENABLEDELAYEDEXPANSION
set Name=CP_FPGA
echo Calling ** Pre_Build_%Name%.bat **
Call Pre_Build_%Name%.bat D 2129 N N
if /I "%ERRORLEVEL%" EQU "1" goto END
goto END
:: echo Calling ** GenCfg_OFP.bat **
:: Call GenCfg_OFP.bat D 2129 1 N N
:: if /I "%ERRORLEVEL%" EQU "1" goto END
echo Calling ** Build_%Name%.bat **
Call Build_%Name%.bat 2129 O R D N
if /I "%ERRORLEVEL%" EQU "1" goto END
echo Calling ** Post_Build_%Name%.bat **
Call Post_Build_%Name%.bat 2129 N N
if /I "%ERRORLEVEL%" EQU "1" goto END
echo All Done
:End