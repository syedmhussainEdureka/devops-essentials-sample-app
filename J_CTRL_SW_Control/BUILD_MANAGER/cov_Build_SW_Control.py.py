#!/usr/bin/python
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 	Name of File: Pre_Build_SW_Control.py
##
## 	Ver: 0.1	Date:04/23/2019
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
    return

exec(open('C:\\DAIRCM\\BUILDS\\J_CTRL_SW_Control\\BUILD_MANAGER\\cfg_SW_Control.py').read())

my_print('IN - PRE_BUILD: ', ' ')

##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Check to see if SVN Repo is Available
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
def Init_Repo():
    print(sys.argv[0], ':  Checking for SVN Repo: ', svnREPO)
    svnLST='svn ls '
    lstCMD=svnLST + svnREPO + '>NUL'
    my_print('lstCMD: ', lstCMD)
    exit_status = os.system(lstCMD)
    if exit_status > 0:
       ExtErr(lstCMD, exit_status)
    return
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Check to see if Release is Available
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
def Check_Release():
    print(sys.argv[0], ':  Checking for Release on REPO:', sys.argv[1])
    svnLST='svn ls '
    lstCMD=svnLST + svnREPO + '>NUL'
    ##print('lstCMD: ', lstCMD)
    exit_status = os.system(lstCMD)
    if exit_status > 0:
       ExtErr(lstCMD, exit_status)
    return 
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Remove Dir is Available
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
def rmDIR(rlDIR):
 if os.path.exists(rlDIR):
       my_print('EXISTS:',rlDIR)
       subprocess.check_call(('attrib -R ' + rlDIR ).split())
	   ##subprocess.check_call(('attrib -R ' + rlsDIR + '\\* /S').split())    
       exit_status=shutil.rmtree(rlDIR)
       my_print("EXT: ", exit_status)
       if exit_status == 1:
          ExtErr(rlDIR, exit_status)       
 return
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Create Dir if required
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
def crtDIR(rlDIR):
  if not os.path.exists(rlDIR):
    exit_status = os.makedirs(rlDIR, mode=0o777)
    my_print('Status on MkDIR	   :', exit_status)
    if exit_status == 1:
       ExtErr('MkDir', exit_status)
    oldmask = os.umask(000)
    exit_status = os.chmod(rlDIR,mode=0o777)
    os.umask(oldmask)
    my_print('Status on CHMOD:', exit_status)
    if exit_status == 1:
       ExtErr('MKDir', exit_status)
	   
    my_print('WKSCPY:', wksCPY)
    exit_status = os.system(wksCPY)
    if exit_status > 0:
       ExtErr('wksCPY', exit_status)
	
  return

##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Check to see if Release Dir is Available
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
def CheckDir(param):
    rlDIR=param
    my_print('Param', rlDIR)
    print(sys.argv[0], ':  Checking for Release Dir on Build System: ', sys.argv[1])
    my_print('rlDIR', rlDIR)
    rmDIR(rlDIR)
    crtDIR(rlDIR)
    return
   
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Import the Source from CP_CPLD from SVN_Repo
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
def svnIMPORT():
    print(sys.argv[0],":  Dowloading Release from The SVN Repo:  "  + ReleaseNum )
    exit_status = os.chdir(curDIR)
    dot="  ."
    importCMD=svnEXPORT + svnREPO + dot
    my_print('Import CMD:', importCMD)
    exit_status = os.system(importCMD)
    if exit_status == 1:
       ExtErr(importCMD, exit_status)
    else:
       exit_status = os.chdir(projBASE1)
       rmDIR(rlsDIR)

       exit_status = os.chdir(projBASE1)
       lnkDIR=os.popen('DIR /AL /B').read()
       exit_status = os.unlink(lnkDIR[:-1])
	   
       exit_status = os.system(mklnkCMD)
       if exit_status == 1:
          ExtErr(mklnkCMD, exit_status)
    
    return
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
def EnvSetup():
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    print(sys.argv[0], ':  Checking Environment on Build System: ', sys.argv[1])
    ##my_print('myPATH:', myPATH)
    myNum=find_str(os.getenv('PATH'), "ccsv5")
    ##my_print('myNum:', myNum)
    if myNum < 0:
       addPath='C:\\ti\\xdctools_3_25_03_72;C:\\ti\\xdctools_3_25_03_72\\bin;C:\\ti\\ccsv5\\utils\\bin;'
       addPath1='C:\\ti\\ccsv5\\utils\\bin\\gmake;C:\\ti\\ccsv5\\utils\\cygwin;'
       addPath2='C:\\Apps\\cygwin64\\bin;C:\\bin'
       ##os.environ["PATH"] += os.pathsep + os.pathsep.join(addPath+addPath1+addPath2)
       os.environ["PATH"] += os.pathsep + addPath + addPath1 + addPath2
    ##my_print('PATH:', os.getenv('PATH'))
   
    return
	
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Verify Input 
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DBG=(sys.argv[3]) 
Toskip=(sys.argv[4])

if OS=="nt":
   os.system('cls')
else:
   os.system('clear')

displayINFO()
print ('Inputs: Release:', ReleaseNum, '*  URL:', sys.argv[2], '*   DBG: ', DBG, '*  Skip:', Toskip, '\n' )

if Toskip=="S":
    Skipme()

svnREPO='https://davms120131.core.drs.master/svn/J_CTRL_SW' +  '/' + sys.argv[2] +  '/' + ReleaseNum
my_print ('svnREPO: ', svnREPO)
   
if argsNUM < 4:
    helpme()
    print(helpme.__doc__)
    raise SystemExit()
	
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
Check_Release()
CheckDir(curDIR)
EnvSetup()
svnIMPORT()

print('++++++++++++++++++++++++++++++++++++++++++++++++++++')
print ('Processing Started @')
print(starTime)
print('Processing Completed @')
Tstamp(2)

raise SystemExit()
