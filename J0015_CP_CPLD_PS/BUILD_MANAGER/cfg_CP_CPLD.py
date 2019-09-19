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

starTime=datetime.datetime.now().strftime("%Y-%m-%d-%H-%M-%S")
print('starTime: ', starTime)

projNME='cpld_top'
OS=os.name
print('OS:', OS) 

if OS=="nt":
 bckslsh="\\"
 projBASE='C:\\DAIRCM\\BUILDS\\J0015_CP_CPLD_PS\\BUILD_MANAGER'
 
 cp="copy "
 rlsDIR=projBASE+bckslsh+'..'+ bckslsh + ReleaseNum
 projDIR=rlsDIR+bckslsh+projNME
 projDIRSYN=rlsDIR+bckslsh+projNME+ bckslsh + 'syn'
 imDIR=projDIRSYN+bckslsh+'impl1'
 swpCMD=("fart -q Lattice_Build_CMD_Full.bat 1400 ")
 

 
"""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
print('projNME: ',projNME)
print('projBASE: ', projBASE)
print('rlsDIR: ', rlsDIR)
print('projDIR: ', projDIR)
print('projDIRSYN: ',projDIRSYN)
print('imDIR: ', imDIR)
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
blnk=" "

svnLST='svn ls'
svnINFO='svn info'
svnREPO='https://davms120131.core.drs.master/svn/J0015_CP_CPLD/tags/'
svnEXPORT='svn export --force -q '

if DBG=="D": 
    DBG="D"

##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Common Functions Defined Here for Sensor_FPGA
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
def Skipme():
    print('++++++++++++++++++++++++++++++++++++++++++++++++++++')
    print('Skipping as Requested: - Exiting @\n')

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
   print ('User:',username, ' *  Home:', homedir, ' *  Host:', hostname)
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
