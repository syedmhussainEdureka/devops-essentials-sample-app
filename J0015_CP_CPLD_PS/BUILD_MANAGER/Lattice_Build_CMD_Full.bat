:: Starting: "prj_run Export -impl impl1"
set covEXE="C:\Program Files\Coverity\Coverity Static Analysis\bin\cov-build.exe"
set covSTR=%covEXE% --no-log-server --dir "C:\Temp\J0015_Sensor_FPGA\cov-build"
::==================================================
SET FOUNDRY=C:\DIAMOND20\3.10\diamond\3.10_x64\ispfpga
::==================================================
:: ++++++++++++++++++++++++++++++++++++++++++++++++ 
PATH
:: ++++++++++++++++++++++++++++++++++++++++++++++++
PATH=%PATH%;C:\Diamond20\3.10\diamond\3.10_x64\bin\nt64;C:\Diamond20\3.10\diamond\3.10_x64\ispfpga\bin\nt64;C:\Diamond20\3.10\diamond\3.10_x64\tcltk\BIN
:: ++++++++++++++++++++++++++++++++++++++++++++++++
cd C:\DAIRCM\BUILDS\J0015_CP_CPLD_PS\1400\cpld_top\syn\impl1
::************************************************************
::**  Synplify Pro                                          **
::************************************************************

synpwrap -msg -prj "asp_cpld_impl1_synplify.tcl" -log "asp_cpld_impl1.srf"


::************************************************************
::**  Translate Design                                      **
::************************************************************

edif2ngd  -l "MachXO2" -d LCMXO2-7000ZE -path "C:/DAIRCM/BUILDS/J0015_CP_CPLD_PS/1400/cpld_top/syn/impl1" -path "C:/DAIRCM/BUILDS/J0015_CP_CPLD_PS/1400/cpld_top/syn"   "C:/DAIRCM/BUILDS/J0015_CP_CPLD_PS/1400/cpld_top/syn/impl1/asp_cpld_impl1.edi" "asp_cpld_impl1.ngo"   
ngdbuild  -a "MachXO2" -d LCMXO2-7000ZE  -p "C:/DIAMOND20/3.10/diamond/3.10_x64/ispfpga/xo2c00/data"  -p "C:/DAIRCM/BUILDS/J0015_CP_CPLD_PS/1400/cpld_top/syn/impl1" -p "C:/DAIRCM/BUILDS/J0015_CP_CPLD_PS/1400/cpld_top/syn"  "asp_cpld_impl1.ngo" "asp_cpld_impl1.ngd"  	

::************************************************************
::**  Map Design                                            **
::************************************************************
map -a "MachXO2" -p LCMXO2-7000ZE -t FTBGA256 -s 2 -oc Industrial   "asp_cpld_impl1.ngd" -o "asp_cpld_impl1_map.ncd" -pr "asp_cpld_impl1.prf" -mp "asp_cpld_impl1.mrp" -lpf "C:/DAIRCM/BUILDS/J0015_CP_CPLD_PS/1400/cpld_top/syn/impl1/asp_cpld_impl1_synplify.lpf" -lpf "C:/DAIRCM/BUILDS/J0015_CP_CPLD_PS/1400/cpld_top/syn/asp_cpld.lpf" -c 0            
::************************************************************
::**  Map Trace                                             **
::************************************************************

trce -f "asp_cpld_impl1.mt" -o "asp_cpld_impl1.tw1" "asp_cpld_impl1_map.ncd" "asp_cpld_impl1.prf"
trce -v 1 -gt -mapchkpnt 0 -sethld -o asp_cpld_impl1.tw1 -gui -msgset C:/DAIRCM/BUILDS/J0015_CP_CPLD_PS/1400/cpld_top/syn/promote.xml asp_cpld_impl1_map.ncd asp_cpld_impl1.prf 
trce -v 1 -gt -mapchkpnt 0 -sethld -o asp_cpld_impl1.tw1 -gui -msgset C:/DAIRCM/BUILDS/J0015_CP_CPLD_PS/1400/cpld_top/syn/promote.xml asp_cpld_impl1_map.ncd asp_cpld_impl1.prf 

::************************************************************
::**  Verilog Simulation File                               **
::************************************************************

ldbanno "asp_cpld_impl1_map.ncd" -n Verilog -o "asp_cpld_impl1_mapvo.vo" -w -neg

::************************************************************
::**  VHDL Simulation File                                  **
::************************************************************

ldbanno "asp_cpld_impl1_map.ncd" -n VHDL -o "asp_cpld_impl1_mapvho.vho" -w -neg
::************************************************************
::**  Place & Route Design                                  **
::************************************************************

mpartrce -p "asp_cpld_impl1.p2t" -f "asp_cpld_impl1.p3t" -tf "asp_cpld_impl1.pt" "asp_cpld_impl1_map.ncd" "asp_cpld_impl1.ncd"
par -w -l 5 -i 6 -t 1 -c 0 -e 0 -gui -msgset C:/DAIRCM/BUILDS/J0015_CP_CPLD_PS/1400/cpld_top/syn/promote.xml -exp parUseNBR=1:parCDP=0:parCDR=0:parPathBased=OFF asp_cpld_impl1_map.ncd asp_cpld_impl1.dir/5_1.ncd asp_cpld_impl1.prf

::************************************************************
::**  Place & Route Trace                                   **
::************************************************************

trce -f "asp_cpld_impl1.pt" -o "asp_cpld_impl1.twr" "asp_cpld_impl1.ncd" "asp_cpld_impl1.prf"
trce -v 10 -gt -sethld -sp 2 -sphld m -o asp_cpld_impl1.twr -gui -msgset C:/DAIRCM/BUILDS/J0015_CP_CPLD_PS/1400/cpld_top/syn/promote.xml asp_cpld_impl1.ncd asp_cpld_impl1.prf 

::************************************************************
::**  I/O Timing Analysis                                   **
::************************************************************

iotiming  "asp_cpld_impl1.ncd" "asp_cpld_impl1.prf"

::************************************************************
::**  IBIS Model                                            **
::************************************************************

ibisgen "asp_cpld_impl1.pad" "C:/DIAMOND20/3.10/diamond/3.10_x64/cae_library/ibis/machxo2.ibs" 
::************************************************************
::**  Verilog Simulation File                               **
::************************************************************

ldbanno "asp_cpld_impl1.ncd" -n Verilog  -o "asp_cpld_impl1_vo.vo"         -w -neg

::************************************************************
::**  VHDL Simulation File                                  **
::************************************************************

ldbanno "asp_cpld_impl1.ncd" -n VHDL -o "asp_cpld_impl1_vho.vho"         -w -neg 

::************************************************************
::**  JEDEC File                                            **
::************************************************************

bitgen -f "asp_cpld_impl1.t2b" -w "asp_cpld_impl1.ncd" -jedec "asp_cpld_impl1.prf"

::************************************************************
::**  Bitstream File                                        **
::************************************************************

bitgen -f "asp_cpld_impl1.t2b" -w "asp_cpld_impl1.ncd" "asp_cpld_impl1.prf"
:END
::Done: completed successfully