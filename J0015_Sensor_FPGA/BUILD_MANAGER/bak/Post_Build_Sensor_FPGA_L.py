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
import stat   # index constants for os.stat()
import datetime
import fileinput
import time
import subprocess
import getpass
import socket
import shutil

projNME='d2s_top'
OS=os.name
print('OS:', OS)

ReleaseNum=(sys.argv[1])

if OS=="nt":
 bckslsh="\\"
 projBASE='C:\\DAIRCM\\BUILDS\\J0015_Sensor_FPGA\\BUILD_MANAGER'
 swpCMD=("fart -q " + projBASE + "\\Batch_mode_new.tcl 1400")
 cp="copy "
 rlsDIR=projBASE+bckslsh+'..'+ bckslsh +ReleaseNum
 projDIR=rlsDIR+bckslsh+projNME
 imDIR=projDIR+bckslsh+projNME+'.runs'+bckslsh+'impl_1'
else:
 bckslsh="/"
 projBASE='/data/BUILDS/J0015_Sensor_FPGA/BUILD_MANAGER'
 swpCMD=("sed -i 's/1400/ReleaseNum/g' Batch_mode.tcl")
 cp="cp "
 rlsDIR=projBASE+bckslsh+'..'+ bckslsh +ReleaseNum
 projDIR=rlsDIR+bckslsh+projNME
 imDIR=projDIR+bckslsh+projNME+'.runs'+bckslsh+'impl_1'

cpyCMD='cp gen_bin.tcl A2.tcl'
vivadoCMD='vivado -mode tcl -source A2.tcl'

svnLST='svn ls'
svnINFO='svn info'
svnREPO='https://davms120131.core.drs.master/svn/J0015_Sensor_FPGA/'
svnEXPORT='svn export --force -q '

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
## Check to see if SVN Repo is Available
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##def StageBase():

##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
def GenFile():
    EnvSetup()
    if os.path.exists(projDIR):
       exit_status = os.chdir(projDIR)
    if os.path.exists("gen_bin.tcl"):
       exit_status = os.system(cpyCMD)
       if exit_status > 0:
          ExtErr(cpyCMD, exit_status)
       print('Generating the bin File')
       exit_status = os.system(vivadoCMD)
       if exit_status > 0:
          ExtErr(vivadoCMD, exit_status)
    else:
       print("The file: gen_bin.tcl  does not exist")
       
    return

##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Check to see if SVN Repo is Available
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
def Init_Repo():
    svnLST='svn ls '
    lstCMD=svnLST + svnREPO + '>NUL'
    ## print('lstCMD: ', lstCMD)
    exit_status = os.system(lstCMD)
    if exit_status > 0:
       ExtErr(lstCMD, exit_status)
    ## print('Status: ', exit_status)
    ## raise SystemExit()

##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Check to see if Release is Available
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
def Check_Release():
    svnLST='svn ls '
    lstCMD=svnLST + svnREPO + '>NUL'
    ## print('lstCMD: ', lstCMD)
    exit_status = os.system(lstCMD)
    if exit_status > 0:
       ExtErr(lstCMD, exit_status)
    
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
       addPath2='C:\\Apps\Vivado\\2016.4\\lib\\win64.o'
       ##os.environ["PATH"] += os.pathsep + os.pathsep.join(addPath+addPath1+addPath2)
       os.environ["PATH"] += os.pathsep + addPath + addPath1 + addPath2
    ## print('PATH:', os.getenv('PATH'))
    ## print('Cur Dir: ', os.getcwd())
    
    return
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


if len(sys.argv) < 3:
  print(helpme.__doc__)

##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Assign Inputs 
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


## Build_CP_FPGA=(sys.argv[3])

DBG='##'
Toskip=(sys.argv[2])

if (sys.argv[3])=="D": DBG='D'

##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Verify Input 
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 
print ('Inputs: Release:', ReleaseNum, 'URL:', sys.argv[2], 'Build Dir:', sys.argv[3], 'Skip:', Toskip, 'DBG: ', DBG)
if (sys.argv[2])=="D": 
   svnREPO='https://davms120131.core.drs.master/svn/J0015_CP_FPGA/trunk_' + ReleaseNum
#print ('svnREPO: ', svnREPO)
if Toskip=="S":
    Skipme()

##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Check & Display User Here
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
print('***')
username = getpass.getuser()
homedir =  os.path.expanduser('~')
hostname = socket.gethostname()
print ('User:',username, 'Home:', homedir, 'Host:', hostname)
print('***')

## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Time Stamp Start of Process
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
print('++++++++++++++++++++++++++++++++++++++++++++++++++++')
print ('Processing Started @')
Tstamp()
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Main Program
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##StageBase()
##Init_Repo()
##Check_Release()
StageDir()
GenFile()

print('++++++++++++++++++++++++++++++++++++++++++++++++++++')
print ('Processing Completed @')
Tstamp()
raise SystemExit()

