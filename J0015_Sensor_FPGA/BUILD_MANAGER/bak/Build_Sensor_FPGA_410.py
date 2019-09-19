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
import stat   # index constants for os.stat()
import datetime
import time
import subprocess

OS=os.name
print('OS:', OS)

ReleaseNum=(sys.argv[1])
Build_Sensor_FPGA=(sys.argv[2])

DBG='::'
Toskip=(sys.argv[4])
starTime=datetime.datetime.now().strftime("%Y-%m-%d-%H-%M-%S")
finTime=datetime.datetime.now().strftime("%Y-%m-%d-%H-%M-%S")

if OS=="nt":
 bckslsh="\\"
else:
 bckslsh="/"
 
projNME='d2s_top'
##print('projNME: ',projNME)
projBASE='C:\\DAIRCM\\BUILDS\\J0015_Sensor_FPGA\\BUILD_MANAGER'
##print('projBASE: ', projBASE)
rlsDIR=projBASE+bckslsh+'..'+ bckslsh +ReleaseNum
##print('rlsDIR: ', rlsDIR)
projDIR=rlsDIR+bckslsh+projNME
##print('projDIR: ', projDIR)
imDIR=projDIR+bckslsh+projNME+'.runs'+bckslsh+'impl_1'
##print('imDIR: ', imDIR)

blnk=" "

BuildCMD='vivado -log d2s_top.vdi -applog -m64 -product Vivado -messageDb vivado.pb -mode batch -source Batch_mode.tcl -notrace'

scrchCMD='grep "write_bitstream completed successfully"  ' 

if OS=="nt":
 swpCMD=("fart -q " + projBASE + "\\Batch_mode_new.tcl 1400")
 cp="copy "
else: 
  swpCMD=("sed -i 's/1400/ReleaseNum/g' Batch_mode.tcl")
  cp="cp "

  
CpyFrm=(projBASE + "\\Batch_mode.tcl")

#print ('swpCMD:', swpCMD)


##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Functions Defined Here 
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
def Skipme():
    print('++++++++++++++++++++++++++++++++++++++++++++++++++++')
    print('Skipping as Requested: - Exiting @\n')
    
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
    print('myPATH1:', myPATH)
    myNum=find_str(os.getenv('PATH'), "Vivado")
    print('myNum:', myNum)
    if myNum < 0:
      addPath='C:\\Apps\\Vivado\\2016.4\\tps\win64\\git-1.9.5\\bin;'
      addPath1='C:\\Apps\\Vivado\\2016.4\\bin;'
      addPath2='C:\\Apps\Vivado\\2016.4\\lib\\win64.o;C:\\usr\\bin;C:\\bin'
       ##os.environ["PATH"] += os.pathsep + os.pathsep.join(addPath+addPath1+addPath2)
      os.environ["PATH"] += os.pathsep + addPath + addPath1 + addPath2
    print('PATH:', os.getenv('PATH')) 
    return
##
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 
def BldFPGA():
    blnk=" "
   
    exit_status = os.chdir(projDIR)
    #print('Cur Dir: ', os.getcwd())
  
    CpyTo=projDIR + "\Batch_mode.tcl"
    newCpCMD=cp + CpyFrm + blnk + CpyTo 
    print('New CpCMD:', newCpCMD)
    exit_status = os.system(newCpCMD)
    if exit_status > 0:
       ExtErr(newCpCMD, exit_status)

    ##print('Cur Dir: ', os.getcwd())
    ##print('New swpCMD:', swpCMD)
    Exit_status = os.system(swpCMD)
    ##if exit_status > 0:
       ##ExtErr(newCMD, exit_status)
	   
    ##newDir=os.path.join(projBASE +os.sep, ReleaseNum, ImDirs)
    ##newDir=projBASE + "\\..\\" + ReleaseNum + ImDirs
    ##exit_status = os.chdir(newDir)
	
    ##exit_status = os.chmod('d2s_top.xpr', mode=0o777)
    ##if exit_status == 1:
       ##print('Chmod - 777- Failed')	
    exit_status = os.chdir(projDIR)
    print('Build CMD:', BuildCMD)
    exit_status = os.system(BuildCMD)
    ## print('EXT:', exit_status)
    if exit_status > 0: 
       ExtErr(BuildCMD, exit_status)
    ##print('Srch CMD:', scrchCMD)
	
    exit_status = os.chdir(imDIR)
    ##print('CWD: ', os.getcwd())
    newscrchCMD=scrchCMD + " runme.log"
    ##print('New Scrch CMD:', newscrchCMD)
    exit_status = os.system(newscrchCMD)
    if exit_status > 0:
       ExtErr(newscrchCMD, exit_status)
    ## print('Err:', exit_status)
    return exit_status

##
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##
def Tstamp(param):
    ## print ('Date and time:', datetime.datetime.now())

    if (param=="1"):
        starTime=datetime.datetime.now().strftime("%Y-%m-%d-%H-%M-%S")
        print(starTime)
    else:
      
        finTime=datetime.datetime.now().strftime("%Y-%m-%d-%H-%M-%S")
        print(finTime)
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
print('Processing Started @')
Tstamp(1)
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## BLD Main Program
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

EnvSetup()
BldFPGA()
print('++++++++++++++++++++++++++++++++++++++++++++++++++++')
print('Processing Started @')
print(starTime)
print('Processing Completed @')
Tstamp(2)



