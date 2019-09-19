#!/usr/bin/python
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 	Name of File: chkBinCSCI.py
##
## 	Ver: 0.1	Date:05/03/2019
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
global rlSTR
global notFND

OS=os.name

svnREPO='https://davms120131.core.drs.master/svn/System_Binaries/'
svnLST='svn ls '
svnINFO='svn info '
svnLOG='svn log -v -q -r '
svnDIFF='svn diff --summarize '

##
csciLSTALL=["CP%20CPLD", "CP%20FPGA", "Sensor%20CPLD", "Sensor%20FPGA",
"Sensor_OMAP_ARM_Laser_Warning","SBC", "Control"]

csciDLSTALL=[".", ".", ".", ".",
".",".", "."]
notFND=0
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
	2. Turn DUBUG ON: D for Debug
	3. Skip Entire Build
	
	You can choice the Default repository or Enter the Name
	
	Example:
	gnchngRPT_ALL.py -> ReleaseNUM  Debug Skip
	gnchngRPT_ALL.py -> 1400         D    S
	
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
  global notFND
  
  my_print('Param: ', param)
  lstCMD='svn ls https://davms120131.core.drs.master/svn/System_Binaries/' + csciLST + '/' + svnDIR[noM]  + ' | grep ' + param 
  my_print('lstCMD: ', lstCMD)
  rlSTR=os.popen(lstCMD).read()
  rlSTR=rlSTR[:-2]
  my_print('rlSTR:', rlSTR)
  str=os.popen(lstCMD).read()
  rlSTR=str.split('\n')[0]
  my_print('len of Str: ', len(str))
  if (len(str) < 1):  
    if  csciDLST=="." :      
        print(sys.argv[0], ':', param, 'Release NOT Found under ', csciLST + '/' + svnDIR[noM], '--> Adjusting')
        print(sys.argv[0], ': Adjusting Path to', csciLST + '/tags :') 
        csciDLST="tags"
        svnDIR[noM]="tags"
        noM=1
        chkRLS(param,noM) 
		
    elif csciDLST=='tags':
        print(sys.argv[0], ': ', param, 'Release NOT Found under ', csciLST + '/' + 'tags' '--> Adjusting')
        print(sys.argv[0], ': Adjusting Path to', csciLST + '/trunk :') 
        csciDLST="trunk"
        svnDIR[noM]="trunk"
        noM=2
        chkRLS(param,noM)
		
    elif csciDLST=='trunk':
	   
        print(sys.argv[0], ': ', param, 'Release NOT Found under ', csciLST + '/' + 'trunk')
        print(sys.argv[0], ': ', '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%') 
        notFND="1"
  else:     
     print(sys.argv[0], ':', param, 'Release Found For ', csciLST )
     print('++++++++++++++++++++++++++++++++++++++++++++++++++++')
	 
  my_print('rlSTR:', rlSTR)
  svnDIR[noM]=csciDLST
  
  return rlSTR
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
    print(sys.argv[0],'++++++++++++++++++++++++++++++++++++++++++++++++++++')
    print(sys.argv[0], 'Error: ', s, ' ', Err, '- Exiting @\n')
    print(sys.argv[0], ': ', '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%') 
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
if argsNUM < 3:
    helpme()
    print(helpme.__doc__)
    raise SystemExit()

## Verify Input 
ReleaseNum=(sys.argv[1])	
DBG=(sys.argv[2]) 
Toskip=(sys.argv[3])
if ReleaseNum=='RL':
   ReleaseNum=os.environ["RELEASE_NUMBER"]
displayINFO()
starTime=datetime.datetime.now().strftime("%Y-%m-%d-%H-%M-%S")
print('starTime: ', starTime)
print ('Inputs: Release:', ReleaseNum, 'DBG: ', DBG, 'Skip:', Toskip )

if Toskip=="S":
    Skipme()
	
i=0
##print('%%%%%%%%%%%%%%%%%%%%% csciLST: ', csciLST,   'csciDLST: ', csciDLST, '%%%%%%%%%%%%%%%%%%%')
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Time Stamp Start of Process
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
print('++++++++++++++++++++++++++++++++++++++++++++++++++++')
print ('Processing Started @ ')
print (starTime)
print('++++++++++++++++++++++++++++++++++++++++++++++++++++')  
while i<=6:
   
    svnDIR=[".", ".", ".",]
    csciLST=csciLSTALL[i]
    csciDLST=csciDLSTALL[i]
    Init_Repo()
    ##print('I: ', i, 'csciLST:', csciLSTALL[i], 'csciDLST=:', csciDLSTALL[i])
    
    nuM=0
    chkRLS(ReleaseNum,nuM)
    if (notFND=="1"):
       ExtErr("Release NOT FOUND", csciLST)
       break
    i +=1
print('++++++++++++++++++++++++++++++++++++++++++++++++++++')
print ('Processing Started @')
print(starTime)
print('Processing Completed @ ')
Tstamp(2)
    

raise SystemExit()
