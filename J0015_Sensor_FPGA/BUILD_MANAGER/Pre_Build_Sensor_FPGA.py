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

argsNUM = len(sys.argv)

if argsNUM < 4:
    helpme()
    print(helpme.__doc__)
    raise SystemExit()
	
DBG=(sys.argv[2]) 
Toskip=(sys.argv[3])
 
## Sensor_FPGA.py is the Config File where all the common stuff for Sensor_FPGA is defined

projBASE='C:\\DAIRCM\\BUILDS\\J0015_Sensor_FPGA\\BUILD_MANAGER'
exit_status = os.chdir(projBASE)
exec(open('C:\\DAIRCM\\BUILDS\\J0015_Sensor_FPGA\\BUILD_MANAGER\\cfg_sensor_FPGA.py').read())

my_print('IN - PRE_BUILD: ', ' ')
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
	Pre_Build_Sensor_FPGA.py -> ReleaseNUM Debug Skip
	Pre_Build_Sensor_FPGA.py -> 1400         D    S

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
    my_print('lstCMD: ', lstCMD)
    exit_status = os.system(lstCMD)
    if exit_status > 0:
       ExtErr(lstCMD, exit_status)
    return
    
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Check to see if Release Dir is Available
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
def CheckDir():
    if os.path.exists(rlsDIR):
       subprocess.check_call(('attrib -R ' + rlsDIR + '\\* /S').split())
       exit_status=shutil.rmtree(rlsDIR)
       ##print("EXT: ", exit_status)
       if exit_status == 1:
          ExtErr(rlsDIR, exit_status)
           
    oldmask = os.umask(000)
	
    exit_status = os.makedirs(rlsDIR, mode=0o777)
    if exit_status == 1:
       ExtErr('MkDir', exit_status)
   
    exit_status = os.chmod(rlsDIR,mode=0o777)
    os.umask(oldmask)
    ##print('Status on CHMOD:', exit_status)
    if exit_status == 1:
       ExtErr('RmDir', exit_status)
    return
   
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Import the Source from Sensor_FPGA from SVN_Repo
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
def svnIMPORT():
    print(sys.argv[0],":Dowloading Release from The SVN Repo:  "  + ReleaseNum )
    exit_status = os.chdir(rlsDIR)
    dot="  ."
    importCMD=svnEXPORT + svnREPO + dot
    my_print('Import CMD:', importCMD)
    exit_status = os.system(importCMD)
    if exit_status == 1:
       ExtErr(importCMD, exit_status)
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Fix Files from the SVN Repo projBASE\RLSNUM\d2s_top
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
def FixFiles():
# Fix the d2s_top.xpr file - Change the Path
   
    my_print('Moving to: ', projDIR)
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
	
    if (sys.argv[4])=='L':
        rlsDIRL=" X:\\BUILDS\\J0015_Sensor_FPGA\\" + ReleaseNum +  ">NUL"
        if os.path.exists(rlsDIRL):
           subprocess.check_call(('attrib -R ' + rlsDIRL + '\\* /S').split())
           exit_status=shutil.rmtree(rlsDIRL)
           print("EXT: ", exit_status)
           if exit_status == 1:
              ExtErr(rlsDIRL, exit_status)
			  
        my_print('xcpCMD: ', xcpCMD)
        exit_status = os.system(xcpCMD)
        if exit_status == 1:
          ExtErr(xcpCMD, exit_status)	
	   
    return
##
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##
def EnvSetup():
    ##my_print('PATH:', os.getenv('PATH'))
    myPATH=os.getenv('PATH')
    ##my_print('myPATH:', myPATH)
    myNum=find_str(os.getenv('PATH'), "Vivado")
    my_print('myNum:', myNum)
    if myNum < 0:
       addPath='C:\\Apps\\Vivado\\2016.4\\tps\win64\\git-1.9.5\\bin;'
       addPath1='C:\\Apps\\Vivado\\2016.4\\bin;'
       addPath2='C:\\Apps\Vivado\\2016.4\\lib\\win64.o;C:\\usr\\bin'
       ##os.environ["PATH"] += os.pathsep + os.pathsep.join(addPath+addPath1+addPath2)
       os.environ["PATH"] += os.pathsep + addPath + addPath1 + addPath2
    ##my_print('PATH:', os.getenv('PATH'))
    my_print('Cur Dir: ', os.getcwd())
   
    return
	
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Verify Input 
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

if OS=="nt":
   os.system('cls')
else:
   os.system('clear')

displayINFO()
print ('Inputs: Release:', ReleaseNum,  'DBG:', DBG, 'Skip:', Toskip)
if Toskip=="S":
    Skipme()

svnREPO='https://davms120131.core.drs.master/svn/J0015_Sensor_FPGA/tags/D2S_FPGA_' + ReleaseNum
my_print ('svnREPO: ', svnREPO)


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