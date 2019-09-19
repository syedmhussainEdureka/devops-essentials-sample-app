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
## Sensor_FPGA.py is the Config File where all the common stuff for Sensor_FPGA is defined

projBASE='C:\\DAIRCM\\BUILDS\\J0015_Sensor_FPGA\\BUILD_MANAGER'
exit_status = os.chdir(projBASE)
print('IN - PRE_BUILD: ')
exec(open('C:\\DAIRCM\\BUILDS\\J0015_Sensor_FPGA\\BUILD_MANAGER\\cfg_sensor_FPGA.py').read())

##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Functions Defined Here 
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

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
    return
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
    return
    
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Check to see if Release Dir is Available
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
def CheckDir():
    oldmask = os.umask(0o777)
    ##print('rlsDIR:-> ', rlsDIR)
    if os.path.exists(rlsDIR):
       exit_status = shutil.rmtree(rlsDIR)
       if exit_status == 1:
          ExtErr(rlsDIR, exit_status)
           
    oldmask = os.umask(000)
	
    exit_status = os.makedirs(rlsDIR, mode=0o777)
    if exit_status == 1:
       ExtErr('MkDir', exit_status)
   
    exit_status = os.chmod(rlsDIR,mode=0o777)
    os.umask(oldmask)
    #print('Status on CHMOD:', exit_status)
    if exit_status == 1:
       ExtErr('RmDir', exit_status)
    return
   
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Import the Source from CP_FPGA from SVN_Repo
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
def svnIMPORT():
    exit_status = os.chdir(rlsDIR)
    dot="  ."
    importCMD=svnEXPORT + svnREPO + dot
    #print('Import CMD:', importCMD)
    exit_status = os.system(importCMD)
    if exit_status == 1:
       ExtErr(importCMD, exit_status)
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Fix Files from the SVN Repo projBASE\RLSNUM\d2s_top
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
def FixFiles():
# Fix the d2s_top.xpr file - Change the Path
   
    ##print('Moving to: ', projDIR)
    exit_status = os.chdir(projDIR)
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
	
    ##print('xcpCMD: ', xcpCMD)
    exit_status = os.system(xcpCMD)
    if exit_status == 1:
       ExtErr(xcpCMD, exit_status)	
	   
    return
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
       addPath2='C:\\Apps\Vivado\\2016.4\\lib\\win64.o;C:\\usr\\bin'
       ##os.environ["PATH"] += os.pathsep + os.pathsep.join(addPath+addPath1+addPath2)
       os.environ["PATH"] += os.pathsep + addPath + addPath1 + addPath2
    ## print('PATH:', os.getenv('PATH'))
    ## print('Cur Dir: ', os.getcwd())
   
    return
	
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Verify Input 
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

if OS=="nt":
   os.system('cls')
else:
   os.system('clear')

argsNUM = len(sys.argv)
#print('Args: ',  argsNUM )
if argsNUM < 5:
    helpme()
    print(helpme.__doc__)
    raise SystemExit()
 
Build_Sensor_FPGA=(sys.argv[2])
Toskip=(sys.argv[5])
DBG=(sys.argv[4]) 

displayINFO()
print ('Inputs: Release:', ReleaseNum, 'URL:', sys.argv[2], 'Build Dir:', sys.argv[3], 'DBG: ', DBG, 'Skip:', Toskip)

if (sys.argv[2])=="D": 
   svnREPO='https://davms120131.core.drs.master/svn/J0015_Sensor_FPGA/tags/D2S_FPGA_' + ReleaseNum
#print ('svnREPO: ', svnREPO)
if Toskip=="S":
    Skipme()

## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Time Stamp Start of Process
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

print('++++++++++++++++++++++++++++++++++++++++++++++++++++')
print('Processing Started @')
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