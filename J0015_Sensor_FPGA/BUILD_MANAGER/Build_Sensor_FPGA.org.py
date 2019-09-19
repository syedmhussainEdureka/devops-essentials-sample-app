#!/usr/bin/python
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 	Name of File: Build_Sensor_FPGA.py
##
## 	Ver: 0.1	Date:04/02/2019
##
##	Author: Syed M Hussain @ DRS
##
##      SEE HELP FOR DETAILS
##
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
import os
import sys

argsNUM = len(sys.argv)

if argsNUM < 4:
    helpme()
    print(helpme.__doc__)
    raise SystemExit()
	
DBG=(sys.argv[2]) 
Toskip=(sys.argv[3])

projBASE='/data/BUILDS/J0015_Sensor_FPGA/BUILD_MANAGER'
exit_status = os.chdir(projBASE)

## Sensor_FPGA.py is the Config File where all the common stuff for Sensor_FPGA is defined
exec(open('/data/BUILDS/J0015_Sensor_FPGA/BUILD_MANAGER/cfg_sensor_FPGA.py').read())

BuildCMD='vivado -log d2s_top.vdi -applog -m64 -product Vivado -messageDb vivado.pb -mode batch -source Batch_mode.tcl -notrace'
scrchCMD='grep "write_bitstream completed successfully"  ' 
 
CpyFrm=(projBASE +  bckslsh + "Batch_mode.tcl")

##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Functions Defined Here 
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
def helpme():
  """++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  
    Description:
	This file will build the  Sensor_FPGA binaries given the Release NUMBER
	
 	Inputs Required:
	1. Release - Release String
	2. Turn DUBUG ON: D for Debug
	3. Skip Entire Build
	
	Example:
	
    Build_Sensor_FPGA.py ReleaseNum Debug Skip
	Build_Sensor_FPGA.py 1400         D     S
	
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
##
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##
def EnvSetup():
    if OS=="nt":
       ##my_print('PATH:', os.getenv('PATH'))
       ##myPATH=os.getenv('PATH')
       ##my_print('myPATH1:', myPATH)
       myNum=find_str(os.getenv('PATH'), "Vivado")
       my_print('myNum:', myNum)
       if myNum < 0:
           addPath='C:\\Apps\\Vivado\\2016.4\\tps\win64\\git-1.9.5\\bin;'
           addPath1='C:\\Apps\\Vivado\\2016.4\\bin;'
           addPath2='C:\\Apps\Vivado\\2016.4\\lib\\win64.o;C:\\usr\\bin;C:\\bin'
           os.environ["PATH"] += os.pathsep + addPath + addPath1 + addPath2
        ##my_print('PATH:', os.getenv('PATH')) 
    return
##
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 
def BldFPGA():
    exit_status = os.chdir(projDIR)
    my_print('Cur Dir: ', os.getcwd())
  
    CpyTo=projDIR +  bckslsh  + "Batch_mode.tcl"
    newCpCMD=cp + CpyFrm + blnk + CpyTo + ">NUL"
    my_print('New CpCMD:', newCpCMD)
    exit_status = os.system(newCpCMD)
    if exit_status > 0:
       ExtErr(newCpCMD, exit_status)

    my_print('Cur Dir: ', os.getcwd())
    my_print('New swpCMD:', swpCMD)
    Exit_status = os.system(swpCMD)
    ##if exit_status > 0:
       ##ExtErr(newCMD, exit_status)
	   
    exit_status = os.chdir(projDIR)
    my_print('Build CMD:', BuildCMD)
    exit_status = os.system(BuildCMD)
    #print('EXT:', exit_status)
    if exit_status > 0: 
       ExtErr(BuildCMD, exit_status)
    my_print('Srch CMD:', scrchCMD)
	
    exit_status = os.chdir(imDIR)
    my_print('CWD: ', os.getcwd())
    newscrchCMD=scrchCMD + " runme.log" + ">NUL"
    my_print('New Scrch CMD:', newscrchCMD)
    exit_status = os.system(newscrchCMD)
    if exit_status > 0:
       ExtErr(newscrchCMD, exit_status)
    my_print('Err:', exit_status)
    return exit_status

##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Verify Input 
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
if OS=="nt":
   os.system('cls')
else:
   os.system('clear')

displayINFO() 
print ('Inputs Verified: Release:', 'DBG: ', DBG, 'Skip:', Toskip)

if Toskip=="S":
    Skipme()
 
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Time Stamp Start of Process
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
print('++++++++++++++++++++++++++++++++++++++++++++++++++++')
print('Processing Started @')
Tstamp(1)
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## BLD Main Program
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

EnvSetup()
BldFPGA()
print('++++++++++++++++++++++++++++++++++++++++++++++++++++')
print ('Processing Started @')
print(starTime)
print('Processing Completed @')
Tstamp(2)

raise SystemExit()



