#!/usr/bin/python
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 	Name of File: Pre_Build_CPLD_PS.py
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

argsNUM = len(sys.argv)

if argsNUM < 4:
    helpme()
    print(helpme.__doc__)
    raise SystemExit()

ReleaseNum=(sys.argv[1])	
DBG=(sys.argv[2]) 
Toskip=(sys.argv[3])
 
## cfg_CP_FPGA.py is the Config File where all the common stuff for cfg_CP_FPGA is defined
exec(open('C:\\DAIRCM\\BUILDS\\J0015_CP_CPLD_PS\\BUILD_MANAGER\\cfg_CP_CPLD.py').read())

my_print('IN - PRE_BUILD: ', ' ')
CpyFrm=("C:\\DAIRCM\\BUILDS\\J0015_CP_CPLD_PS\\BUILD_MANAGER\\Lattice_Build_CMD_Full.bat")

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
	
	1. Release - Release String 
	2. Turn DUBUG ON: D for Debug
	3. Skip Entire Build
	
	You can choice the Default repository or Enter the Name
	
	Example:
	Pre_Build_CP_CPLD_PS.py -> ReleaseNUM Debug Skip
	Pre_Build_CP_CPLD_PS.py -> 1400         D    S

    +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""

##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Check to see if SVN Repo is Available
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
def Init_Repo():
    svnLST='svn ls '
    lstCMD=svnLST + svnREPO + 'trunk_' + ReleaseNum + '>NUL'
    ##print('lstCMD: ', lstCMD)
    exit_status = os.system(lstCMD)
    if exit_status > 0:
       ExtErr(lstCMD, exit_status)
    return
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Check to see if Release is Available
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
def Check_Release():
    svnLST='svn ls '
    lstCMD=svnLST + svnREPO + 'trunk_' + ReleaseNum +  '>NUL'
    ##print('lstCMD: ', lstCMD)
    exit_status = os.system(lstCMD)
    if exit_status > 0:
       ExtErr(lstCMD, exit_status)
    return  
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Check to see if Release Dir is Available
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
def CheckDir():
    my_print('rlsDIR', rlsDIR)
    if os.path.exists(rlsDIR):
       my_print('EXISTS:', rlsDIR)
       subprocess.check_call(('attrib -R ' + rlsDIR ).split())
	   ##subprocess.check_call(('attrib -R ' + rlsDIR + '\\* /S').split())
       exit_status=shutil.rmtree(rlsDIR)
       my_print("EXT: ", exit_status)
       if exit_status == 1:
          ExtErr(rlsDIR, exit_status)
    """
    newD=projBASE+bckslsh+'..'+ bckslsh + 'v2131_bak'
    shutil.rmtree(newD)
    newD=projBASE+bckslsh+'..'+ bckslsh + 'v2131_old'
    shutil.rmtree(newD)
    newD=projBASE+bckslsh+'..'+ bckslsh + '2129'
    shutil.rmtree(newD)
	"""
	
    oldmask = os.umask(000)
	
    exit_status = os.makedirs(rlsDIR, mode=0o777)
    if exit_status == 1:
       ExtErr('MkDir', exit_status)
   
    exit_status = os.chmod(rlsDIR,mode=0o777)
    os.umask(oldmask)
    my_print('Status on CHMOD:', exit_status)
    if exit_status == 1:
       ExtErr('RmDir', exit_status)
    return
   
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Import the Source from CP_CPLD from SVN_Repo
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
def svnIMPORT():
    print(sys.argv[0],":Dowloading Release from The SVN Repo:  "  + ReleaseNum )
    exit_status = os.chdir(rlsDIR)
    dot="  ."
   
    importCMD=svnEXPORT + svnREPO + 'trunk_' + ReleaseNum  + dot
    print('Import CMD:', importCMD)
    exit_status = os.system(importCMD)
    if exit_status == 1:
       ExtErr(importCMD, exit_status)
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Fix the Lattice_Build_CMD_Full.bat for the Release Number
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
def FixFiles():
	
    if ReleaseNum=="2128_v0017":
       os.chdir(projBASE)
       if os.path.exists('2129'):
          shutil.rmtree('2129')
          os.rename(ReleaseNum,'2129')
       if os.path.exists(ReleaseNum):
          os.rename(ReleaseNum,'2129')
		  
    return
##
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##
def EnvSetup():
    ##my_print('myPATH:', myPATH)
    myNum=find_str(os.getenv('PATH'), "Diamond20")
    ##my_print('myNum:', myNum)
    if myNum < 0:
       addPath='C:\\Diamond20\\3.10\\diamond\\3.10_x64\\bin\\nt64;'
       addPath1='C:\\Diamond20\\3.10\\diamond\\3.10_x64\\ispfpga\\bin\\nt64;'
       addPath2='C:\\Diamond20\\3.10\\diamond\\3.10_x64\\tcltk\\BIN;C:\\bin'
       ##os.environ["PATH"] += os.pathsep + os.pathsep.join(addPath+addPath1+addPath2)
       os.environ["PATH"] += os.pathsep + addPath + addPath1 + addPath2
    ##my_print('PATH:', os.getenv('PATH'))
   
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

if ReleaseNum=="2129":
   ReleaseNum="2128" + "_v0017"
   svnREPO='https://davms120131.core.drs.master/svn/J0015_CP_CPLD/trunk_' + ReleaseNum
   my_print ('svnREPO: ', svnREPO)
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Time Stamp Start of Process
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
print('++++++++++++++++++++++++++++++++++++++++++++++++++++')
print ('Processing Started @')
print(starTime)
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
print ('Processing Started @')
print(starTime)
print('Processing Completed @')
Tstamp(2)

raise SystemExit()
