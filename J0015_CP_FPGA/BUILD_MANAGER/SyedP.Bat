SETLOCAL ENABLEEXTENSIONS
SETLOCAL ENABLEDELAYEDEXPANSION

echo python ing ** Pre_Build_CP_FPGA.py **
python Pre_Build_CP_FPGA.ps 2129 D D N N
if /I "%ERRORLEVEL%" EQU "1" goto END
echo python ing ** Build_CP_FPGA.py **
python Build_CP_FPGA.ps 2129 D D N N
if /I "%ERRORLEVEL%" EQU "1" goto END
echo python ing ** Post_Build_CP_FPGA.py **
python Post_Build_CP_FPGA.ps 2129 N N
if /I "%ERRORLEVEL%" EQU "1" goto END
echo All Done
:End