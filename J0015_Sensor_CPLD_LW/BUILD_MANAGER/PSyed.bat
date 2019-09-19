SETLOCAL ENABLEEXTENSIONS
SETLOCAL ENABLEDELAYEDEXPANSION

echo python ** Pre_Build_CPLD_LW.py **
start python Pre_Build_CPLD_LW.py D 2129 N N
if /I "%ERRORLEVEL%" EQU "1" goto END
echo python ** Build_CPLD_LW.py **
start python Build_CPLD_LW.py 2129 O R D N
if /I "%ERRORLEVEL%" EQU "1" goto END
echo pythoning ** Post_Build_CPLD_LW.py **
start python Post_Build_CPLD_LW.py 2129 N N
if /I "%ERRORLEVEL%" EQU "1" goto END
echo All Done
:End