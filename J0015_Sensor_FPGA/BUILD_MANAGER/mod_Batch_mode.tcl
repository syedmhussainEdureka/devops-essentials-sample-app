puts "Launching Build for 2125 J0015_Sensor_FPGA - d2s_top"
puts "Opening Project"
open_project ./d2s_top.xpr
puts "Reset_run synth_1"
reset_run synth_1
puts "Reset_run impl_1"
reset_run impl_1
puts "launch_runs impl_1 -jobs 10"
launch_runs impl_1 -jobs 10
puts {get_property STATS.WNS [get_runs impl_1]}
puts {get_property STATS.WHS [get_runs impl_1]}
wait_on_run impl_1
puts "launch_runs impl_1 -to_step write_bitstream -jobs 10"
launch_runs impl_1 -to_step write_bitstream -jobs 10
wait_on_run impl_1
puts " Completed Build for 2125 J0015_Sensor_FPGA - d2s_top"
exit