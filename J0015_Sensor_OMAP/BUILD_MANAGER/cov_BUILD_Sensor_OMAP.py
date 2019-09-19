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

starTime=datetime.datetime.now().strftime("%Y-%m-%d-%H-%M-%S")
print('starTime: ', starTime)

projNME='BUILD_MANAGER'
OS=os.name
print('OS:', OS) 

if OS=="nt":
   rlsNUM="Cur"
   CSCI="J0015_Sensor_OMAP"
   ProjectLIST=['ARM','DSP-v500']
   projDMY="ARM"
   csciBASE="C:\\DAIRCM\\BUILDS\\"
  
   bldEXE= "\"C:\\Program Files\\Coverity\\Coverity Static Analysis\\bin\\cov-build.exe \""
   anzEXE= "\"C:\\Program Files\\Coverity\\Coverity Static Analysis\\bin\\cov-analyze.exe \""
   covCFG="\"C:\\Program Files\\Coverity\\Coverity Static Analysis\\config\\coverity_config.xml  \" "
   wkspDIR=csciBASE + "\\" + CSCI + "\\" + rlsNUM + "\\" + "WORKSPACES"
  
   DisableCheckers="--disable UNUSED_VALUE --disable NO_EFFECT --disable DEADCODE --disable CHECKED_RETURN --disable UNINIT"
   ParseWarnFile="parse_warnings.conf"
   ParseWarnPath=ParseWarnFile
   ParseWarnCmd='--parse-warnings-config ' + ParseWarnPath
   ##todoLIST=cleanProj buildProj anzyleProj deployProj 
   todoLIST=['cleanProj', 'buildProj', 'anzyleProj']

##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Common Functions Defined Here for Sensor_FPGA
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
def cleanProj(par):
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    projDMY=par
    ## 	print(sys.argv[0], + 'Cleaning Project' + par)
    print(' ===================================================================================')
    print( sys.argv[0], 'Cleaning Project:', projDMY)
    print(' ===================================================================================')

    my_print('projDMY:', projDMY)
    bldDIR="C:\\Temp\\" + CSCI + "\\cov-build"
    wkspDIR=csciBASE + "\\" + CSCI + "\\" + rlsNUM + "\\" + "WORKSPACES" + "\\"
    my_print ('WKS: ', wkspDIR)
    exit_status = os.chdir(wkspDIR)
    osCMD=(bldEXE + " --no-log-server --config " + covCFG + " --dir " + bldDIR +  " C:\\ti\\ccsv5\\eclipse\\eclipsec -noSplash -data " + wkspDIR + " -application com.ti.ccstudio.apps.projectBuild -ccs.projects " + par + " -ccs.clean -ccs.configuration  Debug -ccs.autoImport" )
    exit_status = subprocess.check_call(osCMD)
    if exit_status == 1:
       ExtErr(osCMD, exit_status)

    return
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++	
def buildProj(par):
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    projDMY=par
    ## 	print(sys.argv[0], + 'Cleaning Project' + par)
    print(' ===================================================================================')
    print( sys.argv[0], 'Building Project', projDMY)
    print(' ===================================================================================')

    print('projDMY:', projDMY)
    bldDIR="C:\\Temp\\" + CSCI + "\\cov-build"
    wkspDIR=csciBASE + "\\" + CSCI + "\\" + rlsNUM + "\\" + "WORKSPACES" + "\\"
    print ('WKS: ', wkspDIR)
    exit_status = os.chdir(wkspDIR)
    osCMD=(bldEXE + " --no-log-server --config " + covCFG + "--dir " + bldDIR +  " C:\\ti\\ccsv5\\eclipse\\eclipsec -noSplash -data " + wkspDIR + " -application com.ti.ccstudio.apps.projectBuild -ccs.projects " + par + " -ccs.buildType full -ccs.configuration  Debug -ccs.autoImport" )
    exit_status = subprocess.check_call(osCMD)
    if exit_status == 1:
       ExtErr(osCMD, exit_status)
	
    return
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++	
def anzyleProj(par):
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    projDMY=par
    print(' ===================================================================================')
    print(sys.argv[0], 'Analyzing Project',  projDMY)
    print(' ===================================================================================')

    my_print('projDMY:', projDMY)
    bldDIR="C:\\Temp\\" + CSCI + "\\cov-build"
    wkspDIR=csciBASE + "\\" + CSCI + "\\" + rlsNUM + "\\" + "WORKSPACES" + "\\"
    my_print('WKS: ', wkspDIR)
    exit_status = os.chdir(wkspDIR)
	## covEXE\cov-analyze.exe" --dir %bldDIR%  --config %covCFG% --all  --enable-fnptr --enable-callgraph-metrics --strip-path %csciBASE%\%CSCI%\%rlsNUM%\ARM_ONLY --aggressiveness-level medium 
    osCMD=(anzEXE + " --dir " + bldDIR + " --config " + covCFG + " --all --enable-fnptr --enable-callgraph-metrics --strip-path " + csciBASE + "\\" + CSCI + "\\" + rlsNUM + "\\" + '\\ARM_ONLY ' + ' --aggressiveness-level medium ')
    my_print('OSCMD: ', osCMD)
    exit_status =  subprocess.check_call(osCMD)
    if exit_status == 1:
       ExtErr(osCMD, exit_status)
    return
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
def my_print(arg1, arg2):
   ##if DBG=="D":
      print(arg1, arg2)
      return
	  
## ===================================================================================
##  Main Section
## ===================================================================================

## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Time Stamp Start of Process
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
print('++++++++++++++++++++++++++++++++++++++++++++++++++++')
print ('Processing Started @')
print(starTime)


displayINFO()

for i in (ProjectLIST):  
    cleanProj(i)
    buildProj(i)
    anzyleProj(i)
	
print('++++++++++++++++++++++++++++++++++++++++++++++++++++')
print ('Processing Started @')
print(starTime)	
print('Processing Completed @')
Tstamp(2)

raise SystemExit()