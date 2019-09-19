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

ReleaseNum=(sys.argv[1])
proJECT=(sys.argv[2])	
DBG=(sys.argv[3]) 
Toskip=(sys.argv[4])

starTime=datetime.datetime.now().strftime("%Y-%m-%d-%H-%M-%S")
print('starTime: ', starTime)

projNME='BUILD_MANAGER'
OS=os.name
print('OS:', OS) 

if OS=="nt":
   blnk=" "
   bckslsh="\\"
   cp="copy "
   wrkspace='WORKSPACES'
   projBASE='C:\\DAIRCM\\BUILDS\\J_MW_Cshell_SBC\\BUILD_MANAGER'
   projBASE1='C:\\DAIRCM\\BUILDS\\J_MW_Cshell_SBC\\'
   rlsDIR=projBASE1 + ReleaseNum
   projDIR=rlsDIR+bckslsh+projNME
   eclipseDIR='C:\\ti\\ccsv5\\eclipse\\eclipsec '
   wrkspaceDIR=rlsDIR+bckslsh+wrkspace
   locDIR=rlsDIR+bckslsh+'ARM_ONLY'
   aisfDIR=projDIR+bckslsh+'ARM_ONLY'
   aisgEXE='C:\\Apps\\AISgen\\AISgen_d800k008.exe  '
   aisFIL=aisfDIR +'\\Elwood_05_320MHz_OMAP.cfg'
   cfgTYP='Debug'
   cpTo=projDIR + '\\Release_Config.cfg'
   sed='C:\\ti\\ccsv5\\utils\\cygwin\\sed'
 

"""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
print('projNME: ',projNME)
print('projBASE: ', projBASE)
print('rlsDIR: ', rlsDIR)
print('projDIR: ', projDIR)
print('projDIRSYN: ',projDIRSYN)
print('imDIR: ', imDIR)
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
impCMD=(eclipseDIR + "-noSplash -data " + wrkspaceDIR + " -application com.ti.ccstudio.apps.projectImport -ccs.location " + locDIR + bckslsh + proJECT + ">NUL")
clnCMD=(eclipseDIR + "-noSplash -data " + wrkspaceDIR + " -application com.ti.ccstudio.apps.projectBuild -ccs.projects "+ proJECT + " -ccs.clean -ccs.configuration " + cfgTYP + " -ccs.autoImport" )
bldCMD=(eclipseDIR + "-noSplash -data " + wrkspaceDIR + " -application com.ti.ccstudio.apps.projectBuild -ccs.projects "+ proJECT + " -ccs.FullBuild -ccs.configuration " + cfgTYP + " -ccs.autoImport")

cpyCMD=(cp + aisFIL + blnk + cpTo + '>NUL')
sedCMD1=(sed + blnk + "'/App/d '" + ' Release_Config.cfg' + ">" + 'Release_Config1.cfg')
sedCMD2=(sed + blnk + "'/AIS/d '" + ' Release_Config1.cfg' + ">" + 'Release_Config.cfg')
str1=("App File String=" + aisfDIR + "\\omap_arm\Debug\omap_arm.out;" + aisfDIR + "\\bareMetalDSP\\Debug\\bareMetalDSP.out@0x00000000"+ "\n")
str2=("AIS File Name=" +  rlsDIR + "\\omap_arm_Debug.bin" + "\n")  
aisCMD=(aisgEXE + '-cfg=' + projDIR + '\\Release_Config.cfg')

	  


svnLST='svn ls'
svnINFO='svn info'
##svnREPO='https://davms120131.core.drs.master/svn/J0015_Sensor_FPGA/'
svnEXPORT='svn export --force -q '

if DBG=="D": 
    DBG="D"

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
