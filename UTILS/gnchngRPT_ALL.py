#!/usr/bin/python
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 	Name of File: gnCHngRPT_ALL.py
##
## 	Ver: 0.1	Date:05/02/2019
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

global csciDLST
global csciLST
global svnDIR

OS=os.name

svnREPO='https://davms120131.core.drs.master/svn/'
svnLST='svn ls '
svnINFO='svn info '
svnLOG='svn log -v -q -r '
svnDIFF='svn diff --summarize '

##
csciLSTALL=["J0015_CP_CPLD", "J0015_CP_FPGA", "J0015_Sensor_CPLD", "J0015_Sensor_FPGA",
"J0015_Sensor_OMAP","J_MW_Cshell", "J_CTRL_SW"]

csciDLSTALL=[".", ".", "tags", "tags",
"tags","tags", "tags"]

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
	
	1. ReleaseNum-1 - Release String 
	2. ReleaseNum-2 - Release String
	3. Turn DUBUG ON: D for Debug
	4. Skip Entire Build
	
	You can choice the Default repository or Enter the Name
	
	Example:
	gnchngRPT_ALL.py -> ReleaseNUM  DIR Debug Skip
	gnchngRPT_ALL.py -> 1400       tags   D    S
	
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""

##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Check to see if SVN Repo is Available
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
def myMSG(str1, str2):
    print(sys.argv[0], str1, str2)

def Init_Repo():
    lstCMD=svnLST + svnREPO + csciLST + '/' + csciDLST + '>NUL'
    my_print('svnREPO:', svnREPO)
    my_print('lstCMD: ', lstCMD)
    exit_status = os.system(lstCMD)
    if exit_status > 0:
       ExtErr(lstCMD, exit_status)	   
    myMSG(': CSCI available - >', csciLST)
   
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
    	
  if  csciDLST=="." and \
        len(str) < 1:
        print(sys.argv[0], ':', param, 'Release NOT Found under ', csciLST + '/' + svnDIR[noM], '--> Adjusting')
        print(sys.argv[0], ': Adjusting Path to', csciLST + '/tags :') 
        csciDLST="tags"
        svnDIR[noM]="tags"
        chkRLS(param,noM) 
		
  elif csciDLST=='tags' and \
	    len(str) < 1:
        print(sys.argv[0], ': ', param, 'Release NOT Found under ', csciLST + '/' + svnDIR[noM], '--> Adjusting')
        print(sys.argv[0], ': Adjusting Path to', csciLST + '/trunk :') 
        csciDLST="trunk"
        svnDIR[noM]="trunk"
        chkRLS(param,noM)
		
  elif csciDLST=='trunk' and \
	    len(str) < 1:
        print(sys.argv[0], ': ', param, 'Release NOT Found under ', csciLST + '/' + svnDIR[noM])
        print(sys.argv[0], ': ', '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%') 
        
  
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
    ##raise SystemExit()
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
def my_print(arg1, arg2):
   if DBG=="D":
      print(arg1, arg2)
      return
	  
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Main Program
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
os.system('cls')
   
argsNUM = len(sys.argv)
if argsNUM < 4:
    helpme()
    print(helpme.__doc__)
    raise SystemExit()
	
## Verify Input 
ReleaseNum1=(sys.argv[1])
ReleaseNum2=(sys.argv[2])	
DBG=(sys.argv[3]) 
Toskip=(sys.argv[4])

displayINFO()
starTime=datetime.datetime.now().strftime("%Y-%m-%d-%H-%M-%S")
print('starTime: ', starTime)
print ('Inputs: Release1:', ReleaseNum1, 'Release2:', sys.argv[2], 'DBG: ', DBG, 'Skip:', Toskip )

if Toskip=="S":
    Skipme()
	

i=0
while i<6:
    svnDIR=[".", ".", ".",]
    csciLST=csciLSTALL[i]
    csciDLST=csciDLSTALL[i]
    print('%%%%%%%%%%%%%%%%%%%%% csciLST: ', csciLST,   'csciDLST: ', csciDLST, '%%%%%%%%%%%%%%%%%%%')
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Time Stamp Start of Process
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    print('++++++++++++++++++++++++++++++++++++++++++++++++++++')
    print ('Processing Started @ for  csciLST: ', csciLST,   'csciDLST: ', csciDLST)
    print (starTime)
    print('++++++++++++++++++++++++++++++++++++++++++++++++++++')

   
    Init_Repo()
    gnlst_TAGS()
    gnlst_REVS()
    print('++++++++++++++++++++++++++++++++++++++++++++++++++++')
    print ('Processing Started @')
    print(starTime)
    print('Processing Completed @ for  csciLST: ', csciLST,   'csciDLST: ', csciDLST)
    Tstamp(2)
    i +=1

raise SystemExit()
