#!/usr/bin/python

import os
import sys
import stat   # index constants for os.stat()
import datetime
import time
import subprocess

ReleaseNum=(sys.argv[1])
Build_Sensor_FPGA=(sys.argv[2])

DBG='::'
Toskip=(sys.argv[4])

ProjBase=os.getcwd()
ImDir='d2s_top\\d2s_top.runs\\impl_1'
ImDirs='\\d2s_top'
BuildCMD='vivado -log d2s_top.vdi -applog -m64 -product Vivado -messageDb vivado.pb -mode batch -source Batch_mode.tcl -notrace'

SrchCMD='Findstr /B /C:"write_bitstream completed successfully"' 
SwpCMD=("fart -q " + ProjBase + "\\Batch_mode_new.tcl 1400")
CpyFrm=(ProjBase + "\\Batch_mode.tcl")

##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Functions Defined Here 
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
def Skipme():
    print('++++++++++++++++++++++++++++++++++++++++++++++++++++')
    print('Skipping as Requested: - Exiting @\n')
    Tstamp()
    raise SystemExit()

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
def ExtErr(s, Err):
    print('++++++++++++++++++++++++++++++++++++++++++++++++++++')
    print('Error on CMD: ', s, 'Error:', Err, '- Exiting @\n')
    Tstamp()
    raise SystemExit()
##
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##
def find_str(s, char):
    index = 0

    if char in s:
        c = char[0]
        for ch in s:
            if ch == c:
                if s[index:index+len(char)] == char:
                    return index

            index += 1

    return -1

##
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##
def EnvSetup():
    ## print('PATH:', os.getenv('PATH'))
    myPATH=os.getenv('PATH')
    ## print('myPATH:', myPATH)
    myNum=find_str(os.getenv('PATH'), "Vivado")
    ## print('myNum:', myNum)
    if myNum < 0:
       addPath='C:\\Apps\\Vivado\\2016.4\\tps\win64\\git-1.9.5\\bin;'
       addPath1='C:\\Apps\\Vivado\\2016.4\\bin;'
       addPath2='C:\\Apps\Vivado\\2016.4\\lib\\win64.o;C:\\Usr\bin'
       ##os.environ["PATH"] += os.pathsep + os.pathsep.join(addPath+addPath1+addPath2)
       ###os.environ["PATH"] += os.pathsep + addPath + addPath1 + addPath2
    ## print('PATH:', os.getenv('PATH'))
    print('Cur Dir: ', os.getcwd())
    ProjBase=os.getcwd()
    print('BASE:', ProjBase)
    ##newDir=os.path.join(ProjBase +os.sep, ReleaseNum)
    newDir=ProjBase + "\\..\\" + ReleaseNum
    print('New Dir:->', newDir)
    os.chdir(newDir)
    ## print('Cur Dir: ', os.getcwd())
    return
##
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##
def BldFPGA():
    ProjBase=os.getcwd()
    newDir=ProjBase + ImDirs
	##newDir=os.path.join(ProjBase +os.sep, ReleaseNum, ImDirs)
    print('New Dir:->', newDir)
    blnk=" "
    bckslsh="\\"
    cp="Copy "
    exit_status = os.chdir(newDir)
    #print('Cur Dir: ', os.getcwd())
    newCMD=SwpCMD + blnk + ReleaseNum
    #print('New CMD:', newCMD)
    exit_status = os.system(newCMD)
    if exit_status > 0:
       ExtErr(newCMD, exit_status)
    ###CpyTo=os.path.join(ProjBase +os.sep, ReleaseNum, ImDirs) + bckslsh + "Batch_mode.tcl >NUL"
    CpyTo=ProjBase + "\\..\\" + ReleaseNum + ImDirs  + bckslsh + "Batch_mode.tcl >NUL"
    newCpCMD=cp + CpyFrm + blnk + CpyTo 
    ## print('New CpCMD:', newCpCMD)
    exit_status = os.system(newCpCMD)
    if exit_status > 0:
       ExtErr(newCpCMD, exit_status)
	   
    ##newDir=os.path.join(ProjBase +os.sep, ReleaseNum, ImDirs)
    newDir=ProjBase + "\\..\\" + ReleaseNum + ImDirs
    exit_status = os.chdir(newDir)
	
    exit_status = os.chmod('d2s_top.xpr', mode=0o777)
    if exit_status == 1:
       print('Chmod - 777- Failed')	   
    print('Build CMD:', BuildCMD)
    exit_status = os.system(BuildCMD)
    ## print('EXT:', exit_status)
    if exit_status > 0: 
       ExtErr(BuildCMD, exit_status)
    ##print('Srch CMD:', SrchCMD)
    newSrchCMD=SrchCMD + blnk + ProjBase + "\\..\\" + ReleaseNum + bckslsh + ImDir + bckslsh + "runme.log >NUL"
    ##print('New Scrch CMD:', newSrchCMD)
    exit_status = os.system(newSrchCMD)
    if exit_status > 0:
       ExtErr(newSrchCMD, exit_status)
    ## print('Err:', exit_status)
    return exit_status

##
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##
def Tstamp():
    print ('Date and time:', datetime.datetime.now())
    print('++++++++++++++++++++++++++++++++++++++++++++++++++++')
    return
##
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##

if (sys.argv[4])=="D": DBG='D'

if len(sys.argv) < 6:
  print(helpme.__doc__)

##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Verify Input 
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 
print ('Inputs Verified: Release:', ReleaseNum, 'Build_Sensor_FPGA:', Build_Sensor_FPGA, 'Skip:', Toskip, 'DBG: ', DBG)

if Toskip=="S":
    Skipme()
 

## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Time Stamp Start of Process
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
print('++++++++++++++++++++++++++++++++++++++++++++++++++++')
print ('Processing Started @')
Tstamp()
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## BLD Main Program
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
EnvSetup()
BldFPGA()
print('++++++++++++++++++++++++++++++++++++++++++++++++++++')
print ('Processing Completed @')
Tstamp()
raise SystemExit()

