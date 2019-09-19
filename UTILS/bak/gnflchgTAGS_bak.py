#!/usr/bin/python
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 	Name of File: gnflchgTAGS.py
##
## 	Ver: 0.1	Date:04/30/2019
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

starTime=datetime.datetime.now().strftime("%Y-%m-%d-%H-%M-%S")
print('starTime: ', starTime)

ReleaseNum1=(sys.argv[1])
ReleaseNum2=(sys.argv[2])	
DBG=(sys.argv[3]) 
Toskip=(sys.argv[4])

svnREPO='https://davms120131.core.drs.master/svn/'
svnLST='svn ls '
svnINFO='svn info '
svnLOG='svn log -v -q -r '
svnDIFF='svn diff --summarize '

global csciDLST
global svnDIR []

##
### csciLST=["J0015_CP_CPLD", "J0015_CP_FPGA", "J0015_Sensor_CPLD", "J0015_Sensor_FPGA",
### "J0015_Sensor_OMAP","J_MW_Cshell", "J_CTRL_SW"]

### csciDLST=[".", ".", "tags", "tags",
### "tags","tags", "tags"]

csciLST="J0015_CP_FPGA"
csciDLST="."

##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Functions Defined Here 
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
def helpme():
    """++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  
    Description:
	This python file will create the Release Dir on build machine
	set up the directory structure for the New Release and Download
	the source for Sensor_FPGA from the SVN REPO
	
 	Inputs Required:
	
	1. ReleaseNum - Release String 
	2. Dir- tags or branch or trunk
	3. Turn DUBUG ON: D for Debug
	4. Skip Entire Build
	
	You can choice the Default repository or Enter the Name
	
	Example:
	Pre_Build_SW_Control.py -> ReleaseNUM  DIR Debug Skip
	Pre_Build_SW_Control.py -> 1400       tags   D    S

    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""

##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Check to see if SVN Repo is Available
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
def Init_Repo():
    lstCMD=svnLST + svnREPO + csciLST + '/' + csciDLST + '>NUL'
    my_print('svnREPO:', svnREPO)
    my_print('lstCMD: ', lstCMD)
    exit_status = os.system(lstCMD)
    if exit_status > 0:
       ExtErr(lstCMD, exit_status)
    print(sys.argv[0], ': CSCI available - >', csciLST )
    return
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  
def chkRLS_0(param1,param2):
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  global rlSTR1
  global rlSTR2
  str1=[]
  str2=[]
  my_print('Param1: ', param1)
  my_print('Param2: ', param2)
  lstCMD1='svn ls https://davms120131.core.drs.master/svn/' + csciLST + '/' + csciDLST + ' | grep ' + param1
  ##lstCMD1='svn ls https://davms120131.core.drs.master/svn/' + csciLST + '/' + csciDLST + ' | grep ' + param1 + '/'
  my_print('lstCMD1: ', lstCMD1)
  rlSTR1=os.popen(lstCMD1).read()
  rlSTR1=rlSTR1[:-2]
  print('rlSTR1:', rlSTR1)
  str1=os.popen(lstCMD1).read()
  rlSTR1=str1.split('\n')[0]
  print('len of Str1: ', len(str1))
  print('rlSTR1:', rlSTR1)
  raise SystemExit()
  ##lstCMD2='svn ls https://davms120131.core.drs.master/svn/' + csciLST + '/' + csciDLST + ' | grep ' + param2 + '/'
  lstCMD2='svn ls https://davms120131.core.drs.master/svn/' + csciLST + '/' + csciDLST + ' | grep ' + param2
  rlSTR2=os.popen(lstCMD2).read()
  rlSTR2=rlSTR2[:-2]
  
  my_print('lstCMD2: ', lstCMD2)
  my_print('rlSTR2: ', rlSTR2)
  return 
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
def chkRLS(param):
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  global rlSTR
  global csciDLST
  
  str1=[]
  my_print('Param: ', param)
  lstCMD='svn ls https://davms120131.core.drs.master/svn/' + csciLST + '/' + csciDLST + ' | grep ' + param 
  print('lstCMD: ', lstCMD)
  rlSTR=os.popen(lstCMD).read()
  rlSTR=rlSTR[:-2]
  print('rlSTR:', rlSTR)
  str1=os.popen(lstCMD).read()
  rlSTR=str1.split('\n')[0]
  my_print('len of Str1: ', len(str1))
  if len(str1) < 1: 
     if csciDLST==".":
        print('Adjusting: Tags', param) 
        csciDLST="tags"
        chkRLS(param)
       
     ##print(sys.argv[0], ': ', param, 'Release NOT Found --> Exiting') 
     ##ExtErr(lstCMD, -1)
  print('rlSTR2:', rlSTR)
  
  return rlSTR
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Gen the File Changes based on Tags
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
def gnlst_TAGS():
   global rlSTR1
   global rlSTR2
   global csciDLST
   global org_csciDLST 
   chkRLS(ReleaseNum1)
   rlSTR1=rlSTR
   print('ReleaseNum1: ', rlSTR)
   chkRLS(ReleaseNum2)
   rlSTR2=rlSTR
   print('ReleaseNum2: ', rlSTR, 'Here')

   tagCMD=svnDIFF + svnREPO + csciLST + '/' + org_csciDLST  + '/' + rlSTR1 + '  ' + svnREPO + csciLST + '/' + csciDLST + '/' + rlSTR2 + '  >'+ 'Tags_' + csciLST + '_' + ReleaseNum1 + '_' + ReleaseNum2 + '.txt'
  
   my_print('tagCMD: ', tagCMD)
   
   exit_status = os.system(tagCMD)
   if exit_status > 0:
      ExtErr(tagCMD, exit_status)

   return
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
def getrev_NUM(param):
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  
 global rlREV
 
 my_print('Param: ', param)
 infoCMD=svnINFO + svnREPO + csciLST +  '/' + csciDLST + '/' + param + '|grep Rev:|cut --delim=" " --fields=4'
 my_print('infoCMD: ', infoCMD)
 rlREV=os.popen(infoCMD).read()
 rlREV=rlREV[:-1]
 my_print('rlREV: ', rlREV)
 return
 
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Gen the File Changes based on SVN Revisons
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
def gnlst_REVS():
    global rlSTR1
    global rlSTR2
	
    getrev_NUM(rlSTR1)
    rlREV1=rlREV
    my_print('Rev Num1: ',rlREV1)
      
    getrev_NUM(rlSTR2)
    rlREV2=rlREV
    my_print('Rev Num2: ',rlREV2)
  
    revCMD=svnLOG + rlREV1 + ':' + rlREV2 +  ' ' + svnREPO + csciLST + '>' + 'REVS_' + csciLST +  '_' + ReleaseNum1 + '_' + ReleaseNum2 + '.txt'
    my_print('revCMD: ', revCMD)	  
    exit_status = os.system(revCMD)
    if exit_status > 0:
     ExtErr(revCMD, exit_status)

    return
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Common Functions Defined Here for Sensor_FPGA
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
def Skipme():
    print('++++++++++++++++++++++++++++++++++++++++++++++++++++')
    print('Skipping as Requested: - Exiting @\n')
    Tstamp(2)
    raise SystemExit()
##
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##
def ExtErr(s, Err):
    print('++++++++++++++++++++++++++++++++++++++++++++++++++++')
    print('Error on CMD: ', s, 'Error:', Err, '- Exiting @\n')
    Tstamp(2)
    raise SystemExit()
##
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##
def Tstamp(param):
    print ('Date and time:', datetime.datetime.now())
    if (param==2):
        finTime=datetime.datetime.now().strftime("%Y-%m-%d-%H-%M-%S")
        print(finTime)

    print('++++++++++++++++++++++++++++++++++++++++++++++++++++')
    return
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Check & Display User info Here
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
def displayINFO():
   print('***')
   username = getpass.getuser()
   homedir =  os.path.expanduser('~')
   hostname = socket.gethostname()
   print ('User:',username, ' *  Home:', homedir, ' *  Host:', hostname, '  * OS:', OS)
   print('***')
   return
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
def my_print(arg1, arg2):
   if DBG=="D":
      print(arg1, arg2)
      return
	
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Time Stamp Start of Process
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
print('++++++++++++++++++++++++++++++++++++++++++++++++++++')
print ('Processing Started @')
print(starTime)
print('++++++++++++++++++++++++++++++++++++++++++++++++++++')
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Main Program
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Init_Repo()
gnlst_TAGS()
gnlst_REVS()
print('++++++++++++++++++++++++++++++++++++++++++++++++++++')
print ('Processing Started @')
print(starTime)
print('Processing Completed @')
Tstamp(2)

raise SystemExit()
