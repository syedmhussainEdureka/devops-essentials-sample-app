#!/usr/bin/python
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 	Name of File: Post_Build_Sensor_CPLD_LW.py
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
 
## cfg_CP_CPLD.py is the Config File where all the common stuff for cfg_CP_FPGA is defined
exec(open('C:\\DAIRCM\\BUILDS\\J0015_Sensor_CPLD_LW\\BUILD_MANAGER\\cfg_Sensor_CPLD.py').read())

my_print('IN - PoST_BUILD: ', ' ')

cpyCMD='cp cpld_top_cpld_top.jed  ../../'
genCMD='perl JED_to_CPD.pl cpld_top_cpld_top.jed > cpld_top_cpld_top.cpd'
cpyPrlFile='cp C:\\DAIRCM\\BUILDS\\J0015_Sensor_CPLD_LW\\BUILD_MANAGER\\JED_to_CPD.pl .'

##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Functions Defined Here 
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
def helpme():
  """++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  
    Description:
	This batch file will generate the A.tcl file and The B.bat from the gen_bin.tcl
	it will generate the asp_fpga.bin from the asp_fpga.bit file, for the given release
	
 	Inputs Required:
	1. The Release - ####
	2. Dubug Option - D
	3. Skip Option - S
	You can choice the Default repository or Enter the Name
	
	Example:
	
	*.py 1400 O R D S
	
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
def GenFile():
    EnvSetup()
    my_print('rlsDir:', rlsDIR)
    exit_status = os.chdir(rlsDIR)
    
    exit_status = os.system(cpyPrlFile)
    if exit_status > 0:
       ExtErr(cpyPrlFile, exit_status) 
 
    newDIR=rlsDIR + bckslsh + '\\cpld_top\\syn'
    my_print('newDIr2: ', newDIR)
    my_print('Moving to: ', rlsDIR + '\\cpld_top')
    exit_status = os.chdir(newDIR)
    my_print('Cur Dir: ', os.getcwd())
    my_print('Copy CMD:', cpyCMD)
    if os.path.exists("cpld_top_cpld_top.jed"):
       exit_status = os.system(cpyCMD)
       if exit_status > 0:
          ExtErr(cpyCMD, exit_status)
	 
       exit_status = os.chdir(rlsDIR)
       my_print('Cur Dir: ', os.getcwd())
       my_print('Generating the bin File', ' ')
       exit_status = os.system(genCMD)
       if exit_status > 0:
          ExtErr(genCMD, exit_status)     
    else:
       print('.\syn\cpld_top_cpld_top.jed:', 'No Such File')
       exit_status=1
    if os.path.exists("cpld_top_cpld_top.cpd"):
	     print(sys.argv[0],"cpld_top_cpld_top.cpd:, Generated Successfully")
        
    return
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Check to see if Release is Available
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
def EnvSetup():
    ## print('PATH:', os.getenv('PATH'))
    myPATH=os.getenv('PATH')
    ## print('myPATH:', myPATH)
    myNum=find_str(os.getenv('PATH'), "Diamond")
    ## print('myNum:', myNum)
    if myNum < 0:
       addPath='C:\\Diamond20\\3.8\\diamond\\3.18_x64\bin\\nt64;'
       addPath1='C:\\Diamond20\\3.8\diamond\\3.8_x64\ispfpga\bin\nt64;'
       addPath2='C:\\Diamond20\\3.8\diamond\\3.8_x64\tcltk\BIN;C:\\bin'
       ##os.environ["PATH"] += os.pathsep + os.pathsep.join(addPath+addPath1+addPath2)
       os.environ["PATH"] += os.pathsep + addPath + addPath1 + addPath2
       return
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Verify Input 
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
if OS=="nt":
   os.system('cls')
else:
   os.system('clear')

displayINFO()
print ('Inputs: Release:', ReleaseNum, 'URL:', 'DBG: ', DBG, 'Skip:', Toskip )
if Toskip=="S":
    Skipme()
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Time Stamp Start of Process
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
print('++++++++++++++++++++++++++++++++++++++++++++++++++++')
print ('Processing Started @')
print(starTime)
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Main Program
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
StageDir()
GenFile()
print('++++++++++++++++++++++++++++++++++++++++++++++++++++')
print ('Processing Completed @')
print(starTime)
print('Processing Completed @')
Tstamp(2)
raise SystemExit()

