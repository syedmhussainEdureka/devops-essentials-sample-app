#!/usr/bin/python
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 	Name of File: Build_Sensor_CPLD_LW.py
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
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Functions Defined Here 
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
def helpme():
  """++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  
    Description:
	This batch file will build the  OFP and RRT binaries ** CP SW (OMAP) ** given the
	The Release NUMBER
	
 	Inputs Required:
	1. Release - Release String
	2. Project Name: O for OFP
	3. Project Name: R for RRT
	4. Turn DUBUG ON: D for Debug
	5. Skip Entire Build
	
	Example:
	
	%me%.bat 1400 O R D S
	
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
##
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##
def EnvSetup():
## print('PATH:', os.getenv('PATH'))
    myPATH=os.getenv('PATH')
    my_print('myPATH:', myPATH)
    myNum=find_str(os.getenv('PATH'), "Diamond20")
    my_print('myNum:', myNum)
    if myNum < 0:
       addPath='C:\\Diamond20\\3.8\\diamond\\3.8_x64\\bin\\nt64;'
       addPath1='C:\\Diamond20\\3.8\\diamond\\3.8_x64\\ispfpga\\bin\\nt64;'
       addPath2='C:\\Diamond20\\3.8\\diamond\\3.8_x64\\tcltk\\BIN;C:\\bin'
       
       os.environ["PATH"] += os.pathsep + addPath + addPath1 + addPath2   
    return
	
##
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##
def BldCPGA():
    exit_status = os.chdir(projDIR)
   
    #print('Cur Dir: ', os.getcwd())
    newCMD=swpCMD + blnk + ReleaseNum
    #print('SWP CMD:', swpCMD)
    exit_status = os.system(swpCMD)
    if exit_status > 0:
       ExtErr(swpCMD, exit_status)
    CpyTo=projDIRSYN + bckslsh + "Lattice_Build_CMD_Full.bat>NUL"  
    newCpCMD=cp + cpyFRM + blnk + CpyTo 
    my_print('New CpCMD:', newCpCMD)
    exit_status = os.system(newCpCMD)
    if exit_status > 0:
       ExtErr(newCpCMD, exit_status)
    
    print('projDIRSYN:', projDIRSYN)
    exit_status = os.chdir(projDIRSYN)   
  	
    print('Build CMD:', BuildCMD)
    exit_status = os.system(BuildCMD)
    my_print('EXt:', exit_status)
    if exit_status > 0: 
       ExtErr(BuildCMD, exit_status)
    my_print('Srch CMD:', srchCMD)
    exit_status = os.system(srchCMD)
    if exit_status > 0:
       ExtErr(srchCMD, exit_status)
    my_print('Err:', exit_status)
    if os.path.exists("cpld_top_cpld_top.jed"):
       print('Build Successfull')
       exit_status=0
    else:
       print("The Build Failed")
       exit_status=1
	  
    return exit_status

if argsNUM < 4:
    helpme()
    print(helpme.__doc__)
    raise SystemExit()
	
DBG=(sys.argv[2]) 
Toskip=(sys.argv[3])
 
## cfg_Sensor_CPLD.py is the Config File where all the common stuff for Sensor_CPLD is defined
exec(open('C:\\DAIRCM\\BUILDS\\J0015_Sensor_CPLD_LW\\BUILD_MANAGER\\cfg_Sensor_CPLD.py').read())

my_print('IN - BUILD: ', ' ')
BuildCMD='Lattice_Build_CMD_Full.bat'
srchCMD='Dir cpld_top_cpld_top.jed' 

cpyFRM=(projBASE + bckslsh  + "Lattice_Build_CMD_Full.bat")


##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Verify Input 
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
if OS=="nt":
   os.system('cls')
else:
   os.system('clear')

displayINFO()
print ('Inputs Verified: Release:', ReleaseNum, 'DBG: ', DBG, 'Skip:', Toskip)

if Toskip=="S":
    Skipme()

## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Time Stamp Start of Process
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
print('++++++++++++++++++++++++++++++++++++++++++++++++++++')
print ('Processing Started @')
print(starTime)
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## BLD Main Program
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
EnvSetup()
BldCPGA()
print('++++++++++++++++++++++++++++++++++++++++++++++++++++')
print ('Processing Completed @')
print(starTime)
print('Processing Completed @')
Tstamp(2)
raise SystemExit()