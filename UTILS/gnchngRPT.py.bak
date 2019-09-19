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
global svnDIR

##
### csciLST=["J0015_CP_CPLD", "J0015_CP_FPGA", "J0015_Sensor_CPLD", "J0015_Sensor_FPGA",
### "J0015_Sensor_OMAP","J_MW_Cshell", "J_CTRL_SW"]

### csciDLST=[".", ".", "tags", "tags",
### "tags","tags", "tags"]

csciLST="J0015_CP_FPGA"
csciDLST="."
svnDIR=[".", "."]
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
def chkRLS(param,noM):
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  global rlSTR
  global csciDLST
  
  my_print('Param: ', param)
  lstCMD='svn ls https://davms120131.core.drs.master/svn/' + csciLST + '/' + svnDIR[noM]  + ' | grep ' + param 
  my_print('lstCMD: ', lstCMD)
  rlSTR=os.popen(lstCMD).read()
  rlSTR=rlSTR[:-2]
  my_print('rlSTR:', rlSTR)
  str=os.popen(lstCMD).read()
  rlSTR=str.split('\n')[0]
  my_print('len of Str1: ', len(str))
  if csciDLST=='tags' and \
	    len(str) < 1:
        print(sys.argv[0], ': ', param, 'Release NOT Found under ', csciLST + '/' + svnDIR[noM], '--> Adjusting')
        print(sys.argv[0], ': Adjusting Path to', csciLST + '/trunk :') 
        csciDLST="trunk"
        svnDIR[noM]="trunk"
        chkRLS(param,noM)
		
  if len(str) < 1: 
     if csciDLST==".":
        print(sys.argv[0], ':', param, 'Release NOT Found under ', csciLST + '/' + svnDIR[noM], '--> Adjusting')
        print(sys.argv[0], ': Adjusting Path to', csciLST + '/tags :') 
        csciDLST="tags"
        svnDIR[noM]="tags"
        chkRLS(param,noM)  
  my_print('rlSTR:', rlSTR)
  svnDIR[noM]=csciDLST
  
  return rlSTR
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Gen the File Changes based on Tags
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
def gnlst_TAGS():
   global rlSTR1
   global rlSTR2
   global csciDLST

   nuM=0
   chkRLS(ReleaseNum1,nuM)
   rlSTR1=rlSTR
   my_print('ReleaseNum1: ', rlSTR)
   nuM=1
   chkRLS(ReleaseNum2,nuM)
   rlSTR2=rlSTR
   my_print('ReleaseNum2: ', rlSTR)
   tagCMD=svnDIFF + svnREPO + csciLST + '/' + svnDIR[0]  + '/' + rlSTR1 + '  ' + svnREPO + csciLST + '/' + csciDLST + '/' + rlSTR2 + '  >'+ 'Tag_Report_' + csciLST + '_' + ReleaseNum1 + '_' + ReleaseNum2 + '.txt'
   my_print('tagCMD: ', tagCMD)
   exit_status = os.system(tagCMD)
   if exit_status > 0:
      ExtErr(tagCMD, exit_status)
   else:
     print(sys.argv[0], ': Report based on Tags Generated -->\n', 'Tag_Report_' + csciLST + '_' + ReleaseNum1 + '_' + ReleaseNum2 + '.txt')
   my_print('tagCMD: ', tagCMD)

   return
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
def getrev_NUM(param,num):
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++  
 global rlREV
 
 my_print('Param: ', param)
 infoCMD=svnINFO + svnREPO + csciLST +  '/' + svnDIR[num] + '/' + param + '|grep Rev:|cut --delim=" " --fields=4'
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
	
    num=0
    getrev_NUM(rlSTR1,num)
    rlREV1=rlREV
    my_print('Rev Num1: ',rlREV1)
    
    num=1
    getrev_NUM(rlSTR2,num)
    rlREV2=rlREV
    my_print('Rev Num2: ',rlREV2)
   
    revCMD=svnLOG + rlREV1 + ':' + rlREV2 +  ' ' + svnREPO + csciLST + '/' + csciDLST + '/' + rlSTR2 + '>' + 'Rev_Report_' + csciLST +  '_' + ReleaseNum1 + '_' + ReleaseNum2 + '.txt'
    my_print('revCMD: ', revCMD)	  
    exit_status = os.system(revCMD)
    if exit_status > 0:
     ExtErr(revCMD, exit_status)
    else:
       print(sys.argv[0], ': Report based on SVN Revisons Generated -->\n',  'Rev_Report_'  + csciLST + '_' + ReleaseNum1 + '_' + ReleaseNum2 + '.txt')
    
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
    
    if (param==2):
        finTime=datetime.datetime.now().strftime("%Y-%m-%d-%H-%M-%S")
        print(finTime)
    else:
	    print ('Date and time:', datetime.datetime.now())

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
print (starTime)
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
