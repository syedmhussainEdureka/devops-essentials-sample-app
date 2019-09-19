@echo off
set datetimef=%date:~-4%_%date:~3,2%_%date:~0,2%_%time:~0,2%_%time:~3,2%_%time:~6,2%
echo %datetimef%
D.bat D D >CSCI_Filelist.csv 2>CSCI_Err.csv 
goto  END
timeout /t 18000
gensvr D D >CP_FPGA_list.lst 2>CP_FPGA_Err.lst
:END
echo DONE
