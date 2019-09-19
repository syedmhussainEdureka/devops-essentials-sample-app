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

argsNUM = len(sys.argv)
if argsNUM < 4:
    helpme()
    print(helpme.__doc__)
    raise SystemExit()


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
   projBASE='C:\\DAIRCM\\BUILDS\\J0015_Sensor_OMAP\\BUILD_MANAGER'
   projBASE1='C:\\DAIRCM\\BUILDS\\J0015_Sensor_OMAP\\'
   rlsDIR=projBASE1 + ReleaseNum
   global projDIR
   projDIR=rlsDIR
   curDIR=projBASE1 + 'Cur'
   outDIR=' '
   eclipseDIR='C:\\ti\\ccsv5\\eclipse\\eclipsec '
   wrkspaceDIR=' '
   locDIR=rlsDIR
   aisfDIR=projDIR+bckslsh+outDIR+'\ARM\Debug'
   aisgEXE='C:\\Apps\\AISgen\\AISgen_d800k008.exe  '
   aisFIL=aisfDIR +'\\*.cfg'
   cfgTYP='Debug'
   cpTo=projDIR + '\\Release_Config.cfg'
   sed='C:\\ti\\ccsv5\\utils\\cygwin\\sed'
   mklnkCMD='mklink /J ' + ReleaseNum + ' ' + 'Cur'
   wksCPY='xcopy /E /Q ' + '  ' +  projBASE + '\\' +  wrkspace + '   ' +  curDIR + '\\' + '.' + '>nul'
   
 

"""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
print('projNME: ',projNME)
print('projBASE: ', projBASE)
print('rlsDIR: ', rlsDIR)
print('projDIR: ', projDIR)
print('projDIRSYN: ',projDIRSYN)
print('imDIR: ', imDIR)
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
global cpyCMD
cpyCMD=(cp + aisFIL + blnk + cpTo + '>NUL')
sedCMD1=(sed + blnk + "'/App/d '" + ' Release_Config.cfg' + ">" + 'Release_Config1.cfg')
sedCMD2=(sed + blnk + "'/AIS/d '" + ' Release_Config1.cfg' + ">" + 'Release_Config.cfg')

aisCMD=(aisgEXE + '-cfg=' + projDIR + '\\Release_Config.cfg')

svnLST='svn ls'
svnINFO='svn info'

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
