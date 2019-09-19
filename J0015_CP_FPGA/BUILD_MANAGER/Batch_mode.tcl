puts "Launching Build for 1400 J0015_CP_FPGA - asp_fpga"
puts "Opening Project"
open_project ./asp_fpga.xpr
puts "Reset_run synth_1"
reset_run synth_1
puts "Reset_run impl_1"
reset_run impl_1
set_param general.maxThreads 8
puts "launch_runs impl_1 -jobs 20"
launch_runs impl_1 -jobs 20
puts {get_property STATS.WNS [get_runs impl_1]}
puts {get_property STATS.WHS [get_runs impl_1]}
wait_on_run impl_1
puts "launch_runs impl_1 -to_step write_bitstream -jobs 20"
launch_runs impl_1 -to_step write_bitstream -jobs 20
wait_on_run impl_1
puts " Completed Build for 1400 J0015_CP_FPGA - asp_fpga"
exit