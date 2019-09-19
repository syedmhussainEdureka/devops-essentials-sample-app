#!/usr/bin/python
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 	Name of File: Pre_Build_Sensor_FPGA.py
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

ProjBase='C:\\DAIRCM\\BUILDS\\J0015_Sensor_FPGA\\'
ProjB='ProjBase\\bin'
ProjbldDir='ProjBase\\ReleaseNum\\BUILD_MANAGER'
ImDir='d2s_top\\d2s_top.runs\\impl_1'
ImDirs='d2s_top'
BuildCMD='vivado -log ImDird2s_top.vdi -applog -m64 -product Vivado -messageDb vivado.pb -mode batch -source Batch_mode.tcl -notrace'

SrchCMD='Findstr /B /C:"write_bitstream completed successfully"'
SwpCMD=("fart -q C:\\DAIRCM\\BUILDS\\J0015_Sensor_FPGA\\BUILD_MANAGER\\Batch_mode_new.tcl 1400")
CpyFrm=("C:\\DAIRCM\\BUILDS\\J0015_Sensor_FPGA\\BUILD_MANAGER\\Batch_mode.tcl")

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
	This batch file will create the Release Dir on build machine
	set up the directory structure for the New Release and Download
	ofp_util from the SVN REPO
	
 	Inputs Required:
	1. The SVN Repository Name and Path
	2. Release - Release String 
	3. Turn DUBUG ON: D for Debug
	4. Skip Entire Build
	
	You can choice the Default repository or Enter the Name
	
	Example:
	
	*.py D 1400 D S
	
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""

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
def CheckDir():
    os.chdir(ProjBase)
    newDir=ProjBase + ReleaseNum
    oldmask = os.umask(0o777)
	
    if os.path.exists(newDir):
       shutil.rmtree(newDir)
       
    oldmask = os.umask(000)   
    exit_status = os.makedirs(ReleaseNum, mode=0o777)
    if exit_status == 1:
       ExtErr(MkDir, exit_status)
   
    exit_status = os.chmod(ReleaseNum,mode=0o777)
    os.umask(oldmask)
    print('Status on CHMOD:', exit_status)
    if exit_status == 1:
       ExtErr(RmDir, exit_status)
    return
   
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Import the Source from CP_FPGA from SVN_Repo
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
def svnIMPORT():
    os.chdir(ProjBase)
    newDir=ProjBase + ReleaseNum
    exit_status = os.chdir(newDir)
    dot="  ."
    importCMD=svnEXPORT + svnREPO + dot
    print('Import CMD:', importCMD)
    exit_status = os.system(importCMD)
    if exit_status == 1:
       ExtErr(importCMD, exit_status)
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Fix Files from the SVN Repo ProjBase\RLSNUM\d2s_top
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
def FixFiles():
# Fix the d2s_top.xpr file - Change the Path
    newDir=ProjBase + ReleaseNum + '\\d2s_top'
    print('Moving to: ', ProjBase + ReleaseNum + '\\d2s_top')
    exit_status = os.chdir(newDir)
    with open ("d2s_top.xpr", "r") as infile:
         lines=infile.readlines()
         with open ("mod_d2s_top.xpr", "w") as outfile:
            for pos, line in enumerate(lines):
                if pos == 5:
                  line6="<Project Version=\"7\" Minor=\"17\" Path=\"./d2s_top.xpr\">\n"
                  outfile.write(line6)
                else:
                  outfile.write(line)
				  
    os.remove("d2s_top.xpr")
    exit_status = os.rename("mod_d2s_top.xpr", "d2s_top.xpr")
    if exit_status == 1:
       ExtErr("rename", exit_status)

# fix the Batch_mode.tcl file - Change the release number 
    newDir=ProjBase + ReleaseNum + '\\d2s_top' + '\\d2s_top.runs' + '\\impl_1'
    blnk=" "
    bckslsh="\\"
    cp="Copy "
    CpyTo=os.path.join(ProjBase +os.sep, ReleaseNum, ImDir) + bckslsh + "Batch_mode.tcl >NUL"
    print('Copy To:', CpyTo)
    newCpCMD=cp + CpyFrm + blnk + CpyTo 
    ## print('New CpCMD:', newCpCMD)
    exit_status = os.system(newCpCMD)
    if exit_status > 0:
       ExtErr(newCpCMD, exit_status)
	   
    exit_status = os.chdir(newDir)
    fartStr='fart -q "Batch_mode.tcl" 1400  '
    fartCMD=fartStr + ReleaseNum + ">NUL"
    ##print('fart CMD:', fartCMD)
    exit_status = os.system(fartCMD)
    if exit_status == 1:
       ExtErr(fartCMD, exit_status)
	   
    with open ("Batch_mode.tcl", "r") as infile:
         lines=infile.readlines()
         with open ("mod_Batch_mode.tcl", "w") as outfile:
              for pos, line in enumerate(lines):
                 if pos == 2:
                    line3="open_project ./d2s_top.xpr\n"
                    outfile.write(line3)
                 else:
                    outfile.write(line)
					
    os.remove("Batch_mode.tcl")
    exit_status = os.rename("mod_Batch_mode.tcl", "Batch_mode.tcl")
    if exit_status == 1:
       ExtErr("rename", exit_status)
	   
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
    newDir=os.path.join(ProjBase +os.sep, ReleaseNum)
    ## print('New Dir:', newDir)
    os.chdir(newDir)
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


if len(sys.argv) < 5:
  print(helpme.__doc__)

##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Assign Inputs 
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

ReleaseNum=(sys.argv[2])

DBG='##'
Toskip=(sys.argv[3])

if (sys.argv[4])=="D": DBG='D'

##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Verify Input 
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 
print ('Inputs: Release:', ReleaseNum, 'URL:', sys.argv[2], 'Build Dir:', sys.argv[3], 'Skip:', Toskip, 'DBG: ', DBG)
if (sys.argv[1])=="D": 
   svnREPO='https://davms120131.core.drs.master/svn/J0015_Sensor_FPGA/tags/D2S_FPGA_' + ReleaseNum
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
Init_Repo()
Check_Release()
CheckDir()
EnvSetup()
svnIMPORT()
FixFiles()
print('++++++++++++++++++++++++++++++++++++++++++++++++++++')
print ('Processing Completed @')
Tstamp()
raise SystemExit()

