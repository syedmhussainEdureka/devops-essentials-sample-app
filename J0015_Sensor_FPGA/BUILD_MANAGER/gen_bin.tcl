## write_cfgmem -checksum -force -format BIN -size 64 -loadbit "up 0x0 ./d2s_top.runs/impl_1/d2s_top.bit" ./d2s_top.runs/impl_1/d2s_top.bin
write -checksum -force -format BIN -size 64 -loadbit "up 0x0 ./d2s_top.runs/impl_1/d2s_top.bit" ./d2s_top.runs/impl_1/d2s_top.bin
##file copy -force ./d2s_top.runs/impl_1/debug_nets.ltx ./debug_nets.ltx
file copy -force ./d2s_top.runs/impl_1/d2s_top.bit ./d2s_top_rev_1400.bit
file copy -force ./d2s_top.runs/impl_1/d2s_top.bin ./d2s_top_rev_1400.bin
file copy -force ./d2s_top.runs/impl_1/d2s_top.prm ./d2s_top_rev_1400.prm
##file copy -force ./d2s_top.runs/impl_1/d2s_top.msk ./d2s_top_rev_1400.msk



