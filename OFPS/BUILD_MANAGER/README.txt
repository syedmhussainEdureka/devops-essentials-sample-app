Revision      Change Description
0x1400_0001   ASP-3375 Implement updates for deglitch, zeroize and FRAM write hold
0x1400_0000   ASP_3158 Remove DDR3 Xilinx IP auto pre-charge option
0x1130_0000   ASP_2813 Send INS PCMD continuously, regardless of SBC threat status bit
              ASP_2316 Adding unclassified headers/footers and some hfi files that have not changed functionally
0x1120_0004   ASP_2776 Added primary range thresh parameters (4).
              ASP-2779 Removed this JIRA. Now using RAW vs Clipped again.
              ASP-2786 Using Spectral TRK (negative clipped) for Threshold Spectral Flagged rejections
0x1120_0003   ASP_2727 Removed atmospheric calculations from Primary.
              ASP-2779 Spectral Limited (Saturation Clipped) Input to MD Range Thresholding should be used for Spectral Exceedance Relative Threshold Comparison
0x1120_0002   ASP_2670 Used delayed version of rtc flip buf in nav_header block to make the logic equivalent to the md_pcie_bridge block.
              This will allow the exceedances, sensor header data and nav data to all be aligned in the same buffer in SBC memory and
              removes the 3 100Hz frame delay in the nav data that is seen in the .xcd files recorded during IT-1 flights.
              ASP_2553 Increasing WoW deglitch time to 100mS.
0x1120_0001   ASP_2659 Modify FPGA "mpmc_mig_ddr3" IP to turn on autoprecharge
0x1120_0000   ASP-2545 Modify Missile Detection Pre-Rejection to adjust absolute thresholds with conversion factor.
              ASP_2386 Modify lim_enable to remove operate mode logic, now only driven by armed
0x1110_0003   ASP-2523 Make IDD register controlled by SBC rather than OMAP.
0x1110_0002   ASP-2124 changing zeroize deglitch to 250 ms.
0x1110_0001   ASP-2375 Modified bit_calc for sensor clean power circuit.
              ASP-2443 MD_PRI_CONV registers are incorrect in reg_pkg.vhd
              ASP-2442 LIM minor version bits had wrong defaults
              ASP-2423 Some registers had definition bugs.
0x1110_0000   change  version number to 1.1B because I forgot before the last build.
              ASP-2343 Added sensor sof and eof through exceedance fifo so exceedance fifo does not lose it's mind.
              ASP-2395 Changed a comment in reg 820 to specify that other for wow is FEED_BEEF.
0x1100_0005   ASP-2317 Added tactical compile flag to remove validation channel logic (not GTHs) from the design.
0x1100_0004   ASP-2289 Fixed SDRAM BIT to work at Start Address that is non-zero.
              ASP-2315 Reduced FIFO size, per channel, from 128 lines deep to 32 lines deep. This will save up to 116 BRAMs.
0x1100_0003   ASP-2218 Fixed FRAM faults to wrap around at 128 faults.
              ASP-2217 Write the fault selection register in RAM multiple times to make sure it is correct when we load it.
0x1100_0002   ASP-2005 Fan coming on at cold.  Added code to MAX6694 interface to accunt for diode faults.
              ASP-2172 Changed I2C sample rate to 5Hz from 10 Hz.
              ASP-0290 Removed bits 0 and 1 of reg 0x0218 that reset the DMA controller.
              ASP-2028 Enhanced FRAM Bit to use a random value each time Bit is run.
0x0940_0001   ASP-2067 Modify the FPGA logic to constantly update the parameter checks so they self clear.
0x0940_0000   ASP-1965, ASP-1973, ASP-1974, ASP-1975, ASP-1985, ASP-2001, ASP-2021 A bunch of CMDS changes.
0x0930_000D   ASP-2003 used wrong signal to switch TOEs  need to use earlier one.
0x0930_000C   ASP-2002 Changed SFA to always divide by 4 when calculating average of frames.  Old way was causing divide by 0.
              ASP-2003 Remove register 0x01B8 and use Bit 26 of NAV status word to select which TOE to use.
0x0930_000B   ASP-1977 Added bit to NAV status word to tell us which TOE was selected.
              ASP-1967 Added second TOE register and selection so we can have two TOE sources and switch between them.
              ASP-499  Fixed SPI timing race condition.
0x0930_000A   ASP-1513 Changed code to not report sensor frame count errors until one full flip buf after training frames go away.
0x0930_0009   ASP-1945 Fixing logic in md_temp_filter.
              ASP-1935 Fixing Fan control description in reg_top.vhd
              ASP-1912 Fixing NAV Header descriptions in reg_top.vhd
              ASP-1947 CMDS Changed constant to signal so simulation can overwrite.
0x0930_0008   ASP_1916 Add capability to turn of CP power via register when zeroize is done.
0x0930_0007   ASP-1895 Reverting Baud rate change.  It was already fixed in lower modules.
0x0930_0006   ASP-1865 Change laser code to make sure all 4 shutters are down before firing laser when on ground
              ASP-1864 Added LIM test mode to not increment TFL until the command is written.
0x0930_0005   ASP-1829 Reverting change to xfer_faults.vhd that we think are causing the fault logs to be screwed up
0x0930_0004   ASP-1826 Add compile option to remove zeroize trigger from FRAM and OMAP.
              ASP-1660 SDRAM BIT test fixes.
0x0930_0003   ASP-1789 merge from 09C0
0x0930_0002   Removing ILAs cause it worked with ILAs
0x0930_0001   adding ILAs in Audio because it quit working.
0x0930_0000   ASP-499 Added rest of Audio.
0x0920_0009   Removing ILAs and fixing default for laser serial.
0x0920_0008   Adding ILAs for forenic serial port captures.
0x0920_0007   Forgot to put the new registers in the sensitivity list.
0x0920_0006   ASP_1789 Added register to fix the baud rate used for forensic capture of laser serial traffic.
              Fixed problem in 0920_0002.  MPMC_1 needed to have a driver for reset_out.
0x0920_0003   Rolling revision to make sure I know what is getting built.
0x0920_0002   ASP-1707 Adding Programmer/UDF decoder version registers.
              ASP-499  Adding Audio output.
0x0920_0001   ASP-1552 Added fault logging and version control to FRAM storage.
              ASP-1554 Added capability to zeroize from either the OMAP or Discrete based on UDF.
              ASP-1596 Removed Zeroize Inihibit register.
              ASP-1528 Added zeroize of FRAM
0x0920_0000   ASP-1575 Merged 09A4 and 09B1 together.
              ASP-1541 Remove dead md_th_dir_vec_axi_master code.
              ASP-1542 Modify lim_grp_tfl_dequencer to add comments and fix debug logic error
              ASP-1543 add comments to lim_status module and repurpose lim_status_1 debug register bit to report laser fault
              ASP-1559 Fix a bunch or reg top simulation/comment errors
              ASP-1691 Added Laser Status register to Forensics.
              ASP-897  Removed some old ILAs from the design.
0x0911_0003   ASP-1655 Remove register 0058 so the SBC doesn't put the SBC in reset.
0x0911_0001   Changing to new versioning format.  MMmm_nnnn MM = 0.9, mm = B1(A = 0, B = 1), nnnn minor version
              ASP-1547 Removing IFOV and RTPCMW2 from forensics.
              ASP-1528 Adding zeroize of CP_FRAM.
0xBC11_0009   ASP-1514 Fixing DDR3 controller to be ROW_COLUMN_BANK rather than ROW_BANK_COLUMN.
              ASP-1418 Fixing default value comment on FSI Transmit control in reg top.
              ASP-1435 Adding reset condition for fault log fifo write to fix simulation warnings.
0x0904_0003   ASP-1595 Add TF_ZERO and TF_INIT to forensics.
              ASP-1584 In playback use TF_Zero/Init from sensor to control the MD temp filter.
0x0904_0000   Switching to new version format.  MMmm_nnnn MM = 0.9, mm = A1 (A = 0, B = 1...), nnnn minor version
0xBB17_0009   found bug in previous fix.
0xBB16_0009   ASP-1461 Add LIM threat pending logic.
              ASP-1501 Added Tracker version register and connected it to forensic.
              ASP-1430 Fixed comment in asp_top that describes the mpmc reset polarity.
0xBB15_0009   ASP-1469 New laser test mode for continous laser with out blanking.
0xBB14_0009   ASP-1464 Incorporating changes found at NRL.
0xBB13_0009   ASP-1410 LIM returns current tract segement to report to tracker.
0xBB12_0009   ASP-1134 MD threshold needs to have conversion factor applied to it to put it in the correct units.
              ASP-1248 test mode added to laser so that it will play test patterns continously rather than stopping after 8 seconds.
0xBB11_0009   ASP-1234 Forced status_1553 bit to always be non error since the test is invalid.
0xBB10_0009   ASP-1205 Latched NAV header sent to SBC and use it for forensics.
0xBB0F_0009   ASP-1205 Fixed NAV header swizzle in playback.
0xBB0E_0009   ASP-1205 Removing parameters that should not be in forensics.
0xBB0D_0009   ASP-1205 (First part)Shrt Swapping NAV Header to forensics.
              ASP-1197 Made frame count the same for forensics frames as nav hdr to SBC
0xBB0B_0009   ASP-1191 Fix to make forensic header match NAV header
0xBB0A_0009   ASP-1176/1088 Fixed various syntax errors in the rtc when trying to incorporate this JIRA.
0xBB05_0009   ASP-1176 forgot to give read access to the DST time specified to update the UTC.
0xBB04_0009   ASP-1176/1088 Capture current UTC time at 1PPS(along with DST) and latch it when OMAP writes to register 0x0178 so it does not change while OMAP is reading it.
              ASP-1144 In 1553 mode RTC now updates UTC time with the UTC time specified at the DST time specified.
0xBB03_0009   ASP-1145/1146 Fix UTC updates to only update once after 1PPS.
0xBB02_0009   JIRA ASP-1083 gave LIM more priority in the DRAM controller and got rid of the last runt waveforms and folded them into the real last waveform.
              ASP-1094 moved laser band enable logic from modules to output port
              ASP-1096 removed latches from bit_calc and rtc
              ASP-1100 modified laser_band outputs logic to include lim_cmd_rst reset logic
              ASP-1102 fix comments in various laser interface modules, including reg_top
              ASP-1101 add defaults to omap_ntrfc ports
              ASP-1099 modify laser_band outputs logic to include lim_cmd_rst reset logic
              ASP-1103 renam ports on command parser and status modules
              ASP-1097 added corrupt table error detection bit to waveform reader, reduce unused error vector bit from modulation module
              ASP-1093 Laser Interface test pulse width clipped to 10 bits
              ASP-1095 add pulsed reset logic to laser interface command register
0xBB01_0009   JIRA ASP-972(cont) Noticed that I forgot to connect the TOE.
0xBB00_0009   JIRA ASP-972: New timing(added DST time, drive tag lines to DDCs,
              convert TOE from OMAP to 64 bits, capture dst at 1pps time and provide to OMAP and
              add dst timestamps to forensics.
0xBB28_0007   JIRA ASP-946: Added DTED and UDF version registers and connected them to Forensic_top AND
              JIRA ASP-539: Connected register outputs cpld_status_q, d2s_disabled_q, and sup_cap_vol_q to Forensic_top.
              JIRA ASP-789: Updated bit_calc.vhd and added conv_type0.vhd to fix relative humidity calculation.
0xBB27_0007   JIRA ASP-964 which reverts changes by JIRA-635 that were incorrectly included.
0xBB26_0007   JIRA ASP-958 Disabled eMMC interfaces.
0xBB25_0007   Turned off SBCs cabability to write to the LIM control registers.
              Merged branch "asp_fpga_laser_debug" LIM changes that seem to be modulating the laser.
0xBB24_0007   Consolidated NAV header writing to one module.  Moved MD NAV writing to the new module. Added latest LIM edits and latest fix for 500Hz data path EMI issue.
0xBB23_0007   Updates to Laser Interface Module to removed index LUTs and need for waveform valid.
0xBB22_0007   Updates to Laser Interface Module to increase JAM power bit pulse lengths and
              mod rtc to have 500Hz pulse.  Added laser debug pins.
0xBB21_0007   Merged in the Laser Interface Module fixes.
              Removed some ILAs
0xBB20_0007   Changed checking of the line blanking in sensor_line_chkr
0xBB1F_0007   Added description to reg_top for OMAP_Status register.
              Added mega_deglitch for extra long glitch filtering.
              Incorporated JIRA ASP-657 (Forensic fix for extra data word from OMAP Interface), ASP-638 (frame checker logic), ASP-713 (Early MW interrupts for NAV), ASP-534 (lengthen Exceedance FIFO to 2048 deep), ASP-700 (System I/F
              gets UTCPlus data from RTC), ASP-655 (VxWorks OS Registers added), ASP-637 (Playback Sync output), ASP-632 (NAV header, RTC/NTP time from recording, 1553 data all 'F's), ASP-659 (Playback uses NAV from recording, no DDC               Emulation)
0xBB1E_0007   Incorporating fixes to CMDS JIRA ASP-496.
0xBB1D_0007   Incorporated JIRA ASP-686 (Removing WOW register 0404).
0xBB1C_0007   Added additional ILA probes in forensic ILAs.
0xBB1B_0007   Modified RTC block to have it correctly snap the updated time when in playback mode.
0xBB1A_0007   Changed RTC to snap the 64-bit timestamp in playback mode instead of the 52-bit timestamp. Fixed bug in RTC sensitivity list and added an ILA to RTC.
0xBB19_0007   Changed the Forensic DDC Bus Monitor to ignore the last word that comes across the bus, but only for non-register messages.
0xBB18_0007   Changed the Forensic DDC Bus Monitor to ignore the last word that comes across the bus as it is not valid.
0xBB17_0007   Changed the Forensic DDC Input clock to use mclk20 instead of the 1553 Host Clock. Added ILAs for debug.
0xBB16_0007   Removed Forensic ILA to reduce timing errors.
0xBB15_0007   Incorporated JIRA ASP-324(Adding Playback and DDC Emulator logic) and fixed issue with RTC Playback logic.
0xBB14_0007   Incorporated JIRA ASP-495(Adding Laser Interface Module) and ASP-637(Incorporating Playback Synchronization).
0xBB13_0007   Incorporated JIRA ASP-496(Adding CMDS Interface Module).
0xBB12_0007   Incorporated JIRA ASP-619(moved System Activation register to address 0x040C).
0xBB11_0007   Incorporated JIRA ASP-588(removing Camera Link and DVI from design).
0xBB10_0007   Incorporated JIRA ASP-533(fixing false fault log generation due to errors with BIT processing).
0xBB0F_0007   Incorporated JIRA ASP-525(fixing V Sense equation) and ASP-498(Incorporating Zeroize Interface)
              and ASP-497(Incorporating Laser Blanking) and ASP-481(Incorporating SBC UTCplus registers)
              and ASP-591(Incorporating System Activation Register) and ASP-581(fixing CRC Failure Counters).
0xBB0E_0007   Incorporated JIRA ASP-521.  Adding laser version into forensics.
0xBB0D_0007   Incorporated JIRA ASP-283.  Fixing PCI reset.
0xBB4D_0006   Was using wrong clock based on clock divide for serial baud rate gen.
0xBB4C_0006   Same as below but removed the ILA
0xBB4B_0006   Forensic was not recording serial data correctly.
0xBB4A_0006   Forensic was not recording CP Main CCA Temp 2 but was recording Temp 1 twice.
0xBB49_0006   Fixed bug in forensics that did not allow md_conv to be included per channel.
0xBB48_0006   Added spliting md_conv per sensor including within forensics.
0xBB46_0006   Watchdog to for fix below polarity was wrong so here is attempt 3.
0xBB45_0006   Watchdog to for fix below was incomplete so here is attempt 2.
0xBB44_0006   One PPS Present bit will report not present for 0.5s every 2.0s.  This should fix.
0xBB43_0006   David M. Changed how SFA acummulation reads and writes are reset to make sure we do not terminate AXI transactions that are not complete.
              Added RRF mode in reg_top.vhd to put the CMDS control register under SBC control instead of omap.
0xBB42_0006   David M. came up with a mod to SFA that only resets the AXI at start of frame.
0xBB41_0006   Modified Missile Detect Sub Fame Averager to NOT reset the MDDR AXI ports when the Sensor is Powered off.
0xBB40_0006   Backed out some extra changes in the validation channel that are not needed for RRF.
0xBB3F_0006   Same fix but include validation channel: Only reseting MD data path if SDRAM is also reset.
0xBB3E_0006   Only reseting MD data path if SDRAM is also reset.
0xBB3D_0006   Slowing down IPPS output signal for Clock accuracy checking.
0xBB3C_0006   Forensic DDC capture divide LTW by 2 because of an error in DDC documentation.
              Change Sensor data header to SBC version from 6 to 7.
              Added driving the spare_0/1_rs485_DE lines to enable output timing for verification.
0xBB3B_0006   Adding one second signal to help validate clock accuracy.
              Fixed Sensorx Power up default
              Modified data_recorder module to put CRC insertion in sub module
0xBB39_0006   Reverting back.  OMAP can no longer write RTC_MODE reg
              No longer wait for DDR to be out of reset before taking omap out of reset
              Added includes at ASP_TOP for all ILAs.
0xBB38_0006   Trying to fix Data Recorder CRC (Think I got it this time)
              Holding OMAP in reset until PLLs are locked.
0xBB36_0006   making OMAP test registers 32 bit (2d00 -> 2d0c) for Elwood
              incorporating Alfredo's fix to the upp_pkt_router to account for fifo under run
              Fixed CPLD activate reg default again.  messed up first fix.
              CRC on data recorder still showing as bad so adding ILA.
0xBB35_0006   Fixed CRC was not being applied in data recorder.
0xBB34_0006   Changed default for CPLD activate reg to on 0x3d40 bit 0
0xBB33_0006   Latch the NAV Header every 2ms (also delay latching else where to avoid latency)
              Replace last 8 words(16 bytes) of Forensic NAV data with utcplus data.
              Allow EMIF to write NAV header along with UPP.
              Move SW_UPP_ILA trigger to address 0x2D14 from 0x2D04
              Allow both OMAP and SBC to write the RTC_Mode register
0xBB32_0006   Add CPLD Reconfigurablility.
              Add SW timer register.
              Added Fix for RTC latching input.
0xBB31_0006   Change default baud rate for ALE-47.
              Add SW trigger for UPP to DDC ILAs.
0xBB30_0006   ***** DDC Debug Only ****
              Fix to RS485 logic and constraint.
              Add SW trigger for upp ILAs.
0xBB2F_0006   Fix to RS485 logic and constraint.
0xBB2E_0006   fixed bug in CRC in Data Recorder fix.
              Fixed drive strength on a pin.
              Fixed direction of 485 signals.
0xBB2D_0006   First Risk Reduction Flight Build.  Has DDC IF fix and
              CRC fix in Data Recorder.
