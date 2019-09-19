:: echo '=================================================='
SET FOUNDRY=C:\DIAMOND20\3.8\diamond\3.8_x64\ispfpga
:: echo '=================================================='

:: echo '++++++++++++++++++++++++++++++++++++++++++++++++'
PATH=%PATH%;C:\Diamond20\3.8\diamond\3.8_x64\bin\nt64;C:\Diamond20\3.8\diamond\3.8_x64\ispfpga\bin\nt64;C:\Diamond20\3.8\diamond\3.8_x64\tcltk\BIN
:: echo '++++++++++++++++++++++++++++++++++++++++++++++++'
:: *************************************************

:: echo '*************************************************'
echo 'Moving to:' C:\DAIRCM\BUILDS\J0015_Sensor_CPLD_LW\2131\cpld_top\syn
cd C:\DAIRCM\BUILDS\J0015_Sensor_CPLD_LW\2131\cpld_top\syn
:: echo '*************************************************'
:: "prj_run Export -impl cpld_top"
edif2ngd  -l "MachXO2" -d LCMXO2-7000ZE -path "C:/DAIRCM/BUILDS/J0015_Sensor_CPLD_LW/2131/cpld_top/syn/cpld_top" -path "C:/DAIRCM/BUILDS/J0015_Sensor_CPLD_LW/2131/cpld_top/syn"   "C:/DAIRCM/BUILDS/J0015_Sensor_CPLD_LW/2131/cpld_top/syn/cpld_top/cpld_top_cpld_top.edi" "cpld_top_cpld_top.ngo"   
ngdbuild  -a "MachXO2" -d LCMXO2-7000ZE  -p "C:/DIAMOND20/3.8/diamond/3.8_x64/ispfpga/xo2c00/data"  -p "C:/DAIRCM/BUILDS/J0015_Sensor_CPLD_LW/2131/cpld_top/syn/cpld_top" -p "C:/DAIRCM/BUILDS/J0015_Sensor_CPLD_LW/2131/cpld_top/syn"  "cpld_top_cpld_top.ngo" "cpld_top_cpld_top.ngd"  	
map -a "MachXO2" -p LCMXO2-7000ZE -t FTBGA256 -s 3 -oc Industrial   "cpld_top_cpld_top.ngd" -o "cpld_top_cpld_top_map.ncd" -pr "cpld_top_cpld_top.prf" -mp "cpld_top_cpld_top.mrp" -lpf "C:/DAIRCM/BUILDS/J0015_Sensor_CPLD_LW/2131/cpld_top/syn/cpld_top/cpld_top_cpld_top_synplify.lpf" -lpf "C:/DAIRCM/BUILDS/J0015_Sensor_CPLD_LW/2131/cpld_top/syn/cpld_top.lpf" -c 0            
trce -f ".\cpld_top\cpld_top_cpld_top.mt" -o "cpld_top_cpld_top.tw1" "cpld_top_cpld_top_map.ncd" "cpld_top_cpld_top.prf"
ldbanno "cpld_top_cpld_top_map.ncd" -n Verilog -o "cpld_top_cpld_top_mapvo.vo" -w -neg
ldbanno "cpld_top_cpld_top_map.ncd" -n VHDL -o "cpld_top_cpld_top_mapvho.vho" -w -neg
mpartrce -p "cpld_top_cpld_top.p2t" -f ".\cpld_top\cpld_top_cpld_top.p3t" -tf "cpld_top_cpld_top.pt" "cpld_top_cpld_top_map.ncd" "cpld_top_cpld_top.ncd"
par -w -l 5 -i 200 -t 51 -c 0 -e 0 -stopzero -gui -msgset C:/DAIRCM/BUILDS/J0015_Sensor_CPLD_LW/2131/cpld_top/syn/promote.xml -exp parUseNBR=1:parCDP=0:parCDR=0:parPathBased=OFF:aseRouteInitSetupSlackThreshold=-8.156 cpld_top_cpld_top_map.ncd cpld_top_cpld_top.dir/5_51.ncd cpld_top_cpld_top.prf
par -w -l 5 -i 200 -t 52 -c 0 -e 0 -stopzero -gui -msgset C:/DAIRCM/BUILDS/J0015_Sensor_CPLD_LW/2131/cpld_top/syn/promote.xml -exp parUseNBR=1:parCDP=0:parCDR=0:parPathBased=OFF:aseRouteInitSetupSlackThreshold=-4.324 cpld_top_cpld_top_map.ncd cpld_top_cpld_top.dir/5_52.ncd cpld_top_cpld_top.prf
par -w -l 5 -i 200 -t 53 -c 0 -e 0 -stopzero -gui -msgset C:/DAIRCM/BUILDS/J0015_Sensor_CPLD_LW/2131/cpld_top/syn/promote.xml -exp parUseNBR=1:parCDP=0:parCDR=0:parPathBased=OFF:aseRouteInitSetupSlackThreshold=-4.324 cpld_top_cpld_top_map.ncd cpld_top_cpld_top.dir/5_53.ncd cpld_top_cpld_top.prf
par -w -l 5 -i 200 -t 54 -c 0 -e 0 -stopzero -gui -msgset C:/DAIRCM/BUILDS/J0015_Sensor_CPLD_LW/2131/cpld_top/syn/promote.xml -exp parUseNBR=1:parCDP=0:parCDR=0:parPathBased=OFF:aseRouteInitSetupSlackThreshold=-4.324 cpld_top_cpld_top_map.ncd cpld_top_cpld_top.dir/5_54.ncd cpld_top_cpld_top.prf
par -w -l 5 -i 200 -t 55 -c 0 -e 0 -stopzero -gui -msgset C:/DAIRCM/BUILDS/J0015_Sensor_CPLD_LW/2131/cpld_top/syn/promote.xml -exp parUseNBR=1:parCDP=0:parCDR=0:parPathBased=OFF:aseRouteInitSetupSlackThreshold=-4.324 cpld_top_cpld_top_map.ncd cpld_top_cpld_top.dir/5_55.ncd cpld_top_cpld_top.prf
par -w -l 5 -i 200 -t 56 -c 0 -e 0 -stopzero -gui -msgset C:/DAIRCM/BUILDS/J0015_Sensor_CPLD_LW/2131/cpld_top/syn/promote.xml -exp parUseNBR=1:parCDP=0:parCDR=0:parPathBased=OFF:aseRouteInitSetupSlackThreshold=-1.948 cpld_top_cpld_top_map.ncd cpld_top_cpld_top.dir/5_56.ncd cpld_top_cpld_top.prf

trce -f "cpld_top_cpld_top.pt" -o "cpld_top_cpld_top.twr" "cpld_top_cpld_top.ncd" "cpld_top_cpld_top.prf"
trce -v 10 -gt -sethld -sp 3 -sphld m -o cpld_top_cpld_top.twr -gui -msgset C:/DAIRCM/BUILDS/J0015_Sensor_CPLD_LW/2131/cpld_top/syn/promote.xml cpld_top_cpld_top.ncd cpld_top_cpld_top.prf 
trce -v 10 -gt -sethld -sp 3 -sphld m -o cpld_top_cpld_top.twr -gui -msgset C:/DAIRCM/BUILDS/J0015_Sensor_CPLD_LW/2131/cpld_top/syn/promote.xml cpld_top_cpld_top.ncd cpld_top_cpld_top.prf 
iotiming  "cpld_top_cpld_top.ncd" "cpld_top_cpld_top.prf"
ibisgen "cpld_top_cpld_top.pad" "C:/DIAMOND20/3.8/diamond/3.8_x64/cae_library/ibis/machxo2.ibs" 
ldbanno "cpld_top_cpld_top.ncd" -n Verilog  -o "cpld_top_cpld_top_vo.vo"         -w -neg
ldbanno "cpld_top_cpld_top.ncd" -n VHDL -o "cpld_top_cpld_top_vho.vho"         -w -neg
bitgen -f "cpld_top_cpld_top.t2b" -w "cpld_top_cpld_top.ncd" -jedec "cpld_top_cpld_top.prf"
bitgen -f "cpld_top_cpld_top.t2b" -w "cpld_top_cpld_top.ncd" "cpld_top_cpld_top.prf"
exit 0