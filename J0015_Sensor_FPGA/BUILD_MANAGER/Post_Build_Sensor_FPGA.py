#!/usr/bin/python
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 	Name of File: Post_Build_CP_FPGA.py
##
## 	Ver: 0.1	Date:04/01/2019
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

cpyCMD='cp gen_bin.tcl A.tcl'
vivadoCMD='vivado -mode tcl -source A.tcl >NUL'

##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Functions Defined Here 
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
def helpme():
  """++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  
    Description:
	This file will generate the A.tcl file and The final binarires from the gen_bin.tcl
	it will generate the asp_fpga.bin from the asp_fpga.bit file, for the given release
	
 	Inputs Required:
	1. The Release - ####
	2. Dubug Option - D
	3. Skip Option - S
	You can choice the Default repository or Enter the Name
	
	Example:
	
	Post_Build_CP_Sensor.py ReleaseNUM DEBUG Skip
						     1400      D    S
	
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""

##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
def GenFile():
    EnvSetup()
    if os.path.exists(projDIR):
       exit_status = os.chdir(projDIR)
    ##print('Cur Dir: ', os.getcwd())
    if os.path.exists("gen_bin.tcl"):
       exit_status = os.system(cpyCMD)
       if exit_status > 0:
          ExtErr(cpyCMD, exit_status)
    with open("A.tcl", 'a') as file:
         file.write('exit')	
    print('Generating the bin File')
    exit_status = os.system(vivadoCMD)
    if exit_status > 0:
       ExtErr(vivadoCMD, exit_status)
     
    return
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Check to see if Release Dir is Available
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
def StageDir():
    os.chdir(projBASE)
    newDir=projBASE + ReleaseNum 
    if os.path.exists(newDir):
       exit_status = os.chdir(newDir)   
    return
##
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##
def EnvSetup():
    if OS=="nt":
       ##myPATH=os.getenv('PATH')
       ## print('myPATH:', myPATH)
       myNum=find_str(os.getenv('PATH'), "Vivado")
       ## print('myNum:', myNum)
       if myNum < 0:
          addPath='C:\\Apps\\Vivado\\2016.4\\tps\win64\\git-1.9.5\\bin;'
          addPath1='C:\\Apps\\Vivado\\2016.4\\bin;'
          addPath2='C:\\Apps\Vivado\\2016.4\\lib\\win64.o;C:\\usr\bin'
          os.environ["PATH"] += os.pathsep + addPath + addPath1 + addPath2  
    return

if OS=="nt":
   os.system('cls')
else:
   os.system('clear')

##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Verify Input 
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
displayINFO() 
print ('Inputs: Release:', ReleaseNum, 'DBG: ', DBG,  'Skip:', Toskip)

svnREPO='https://davms120131.core.drs.master/svn/J0015_CP_FPGA/trunk_' + ReleaseNum
#print ('svnREPO: ', svnREPO)
if Toskip=="S":
    Skipme()

## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Time Stamp Start of Process
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
print('++++++++++++++++++++++++++++++++++++++++++++++++++++')
print ('Processing Started @')
Tstamp(1)
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Main Program
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
StageDir()
GenFile()

print('++++++++++++++++++++++++++++++++++++++++++++++++++++')
print('Processing Started @')
print(starTime)
print ('Processing Completed @')
Tstamp(2)
raise SystemExit()

