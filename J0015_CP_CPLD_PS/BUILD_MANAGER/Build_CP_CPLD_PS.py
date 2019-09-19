#!/usr/bin/python
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 	Name of File: Build_CPLD_PS.py
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
    ##print('myPATH:', myPATH)
    myNum=find_str(os.getenv('PATH'), "Diamond20")
    ##print('myNum:', myNum)
    if myNum < 0:
       addPath='C:\\Diamond20\\3.10\\diamond\\3.10_x64\\bin\\nt64;'
       addPath1='C:\\Diamond20\\3.10\\diamond\\3.10_x64\\ispfpga\\bin\\nt64;'
       addPath2='C:\\Diamond20\\3.10\\diamond\\3.10_x64\\tcltk\\BIN;C:\\bin;C:\\usr\\bin'
       ##os.environ["PATH"] += os.pathsep + os.pathsep.join(addPath+addPath1+addPath2)
       os.environ["PATH"] += os.pathsep + addPath + addPath1 + addPath2
    return
	
##
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##
def BldCPLD():
    CpyTo=imDIR + bckslsh + "Lattice_Build_CMD_Full.bat>NUL"  	
    newCpCMD=cp + CpyFrm + blnk + CpyTo 
    #print('New CpCMD:', newCpCMD)
    exit_status = os.system(newCpCMD)
    if exit_status > 0:
       ExtErr(newCpCMD, exit_status)
    
    #print('New Dir:', imDIR)
    exit_status = os.chdir(imDIR)   
    #print('Cur Dir: ', os.getcwd())
    #print('SWP CMD1: ', swpCMD)
    newCMD=swpCMD + blnk + ReleaseNum
    #print('SWP CMD2:', newCMD)
    exit_status = os.system(newCMD)
	
    if exit_status > 0:
       if (exit_status!=12):
          ExtErr(newCMD, exit_status)
   
    print('Build CMD:', BuildCMD)
    exit_status = os.system(BuildCMD)
    ##print('EXt:', exit_status)
    if exit_status > 0: 
       ExtErr(BuildCMD, exit_status)
    ##print('Srch CMD:', srchCMD)
    exit_status = os.system(srchCMD)
    if exit_status > 0:
       ExtErr(srchCMD, exit_status)
    ##print('Err:', exit_status)
    if os.path.exists("asp_cpld_impl1.jed"):
       print('Build Successfull')
       exit_status=0
    else:
       print("The Build Failed")
       exit_status=1
	  
    return exit_status

argsNUM = len(sys.argv)

if argsNUM < 4:
    helpme()
    print(helpme.__doc__)
    raise SystemExit()
	
DBG=(sys.argv[2]) 
Toskip=(sys.argv[3])
 
## cfg_CP_FPGA.py is the Config File where all the common stuff for cfg_CP_FPGA is defined
exec(open('C:\\DAIRCM\\BUILDS\\J0015_CP_CPLD_PS\\BUILD_MANAGER\\cfg_CP_CPLD.py').read())

my_print('IN - BUILD: ', ' ')
BuildCMD='Lattice_Build_CMD_Full.bat'
srchCMD='Dir asp_cpld_impl1.jed' 

CpyFrm=(projBASE + bckslsh  + "Lattice_Build_CMD_Full.bat")


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
BldCPLD()
print('++++++++++++++++++++++++++++++++++++++++++++++++++++')
print ('Processing Started @')
print(starTime)
print('Processing Completed @')
Tstamp(2)

raise SystemExit()