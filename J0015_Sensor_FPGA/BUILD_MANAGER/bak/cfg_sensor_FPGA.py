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
##print('starTime: ', starTime)

projNME='d2s_top'
OS=os.name
##print('OS:', OS) 

if OS=="nt":
 bckslsh="\\"
 projBASE='C:\\DAIRCM\\BUILDS\\J0015_Sensor_FPGA\\BUILD_MANAGER'
 swpCMD=("fart -q " + projBASE + "\\Batch_mode_new.tcl 1400")
 xcpCMD=("xcopy /S /Q /I " + projBASE + "\\..\\" + ReleaseNum + " X:\\BUILDS\\J0015_Sensor_FPGA\\" + ReleaseNum +  ">NUL")
 cp="copy "
 rlsDIR=projBASE+bckslsh+'..'+ bckslsh + ReleaseNum
 projDIR=rlsDIR+bckslsh+projNME
 imDIR=projDIR+bckslsh+projNME+'.runs'+bckslsh+'impl_1'
else:
 bckslsh="/"
 projBASE='/data/BUILDS/J0015_Sensor_FPGA/BUILD_MANAGER'
 swpCMD=("sed -i 's/1400/ReleaseNum/g' Batch_mode.tcl")
 cp="cp "
 rlsDIR=projBASE+bckslsh+'..'+ bckslsh +ReleaseNum
 projDIR=rlsDIR+bckslsh+projNME
 imDIR=projDIR+bckslsh+projNME+'.runs'+bckslsh+'impl_1'
 
"""++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
print('projNME: ',projNME)
print('projBASE: ', projBASE)
print('rlsDIR: ', rlsDIR)
print('projDIR: ', projDIR)
print('imDIR: ', imDIR)
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
blnk=" "

svnLST='svn ls'
svnINFO='svn info'
svnREPO='https://davms120131.core.drs.master/svn/J0015_Sensor_FPGA/'
svnEXPORT='svn export --force -q '

DBG='::'

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