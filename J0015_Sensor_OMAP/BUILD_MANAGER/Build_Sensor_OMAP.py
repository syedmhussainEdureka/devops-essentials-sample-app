#!/usr/bin/python
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 	Name of File: Build_Sensor_OMAP.py
##
## 	Ver: 0.1	Date:05/24/2019
##
##	Author: Syed M Hussain @ DRS
##
##      SEE HELP FOR DETAILS
##
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
import os
import sys

argsNUM = len(sys.argv)

def helpme():
    
    """++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  
        Description:
	    This batch file will build the SW Control binaries ** CNTRL SW ** given the
	    The Release NUMBER
	
 	    Inputs Required:
	    1. Release - Release Number /String
	    2. Project Name: ARM DsP-v500 AiS		
	    3. Turn DUBUG ON: D for Debug
	    4. Skip Entire Build
	
	    Example:
	
	    Build_Sensor_OMAP.py 1400  ARM  D S
	    Build_Sensor_OMAP.py 1400  DSP-v500	D S
		Build_Sensor_OMAP.py 1400 AIS N N
	
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
    
		
if argsNUM < 4:
   os.system('clear')
   helpme()
   print(helpme.__doc__)
   raise SystemExit()

proJECT=(sys.argv[2])	
DBG=(sys.argv[3]) 
Toskip=(sys.argv[4])

## cfg_SW_Control.py is the Config File where all the common stuff for cfg_SW_Control is defined
exec(open('C:\\DAIRCM\\BUILDS\\J0015_Sensor_OMAP\\BUILD_MANAGER\\cfg_Sensor_OMAP.py').read())

##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Functions Defined Here 
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
def svnPROJ():
    global wrkspaceDIR
    global outDIR
    ##print('WorkspaceDIR2A: ', wrkspaceDIR)
    print(sys.argv[0],":  Checking Dir:  "  + ReleaseNum )
    exit_status = os.chdir(rlsDIR)
    ##output = os.popen('Dir *.* /B').read()
    ##outDIR = output[:-1]
	
    wrkspaceDIR=rlsDIR+bckslsh+'\\'+wrkspace
  
def ldPROJ():
    impCMD=(eclipseDIR + "-noSplash -data " + wrkspaceDIR + " -application com.ti.ccstudio.apps.projectImport -ccs.location " + locDIR + bckslsh + proJECT + ">NUL")
    print('IMPCMD: ', impCMD)   
   
    os.system(impCMD)
    return
   
	
def clnPROJ():
    clnCMD=(eclipseDIR + "-noSplash -data " + wrkspaceDIR + " -application com.ti.ccstudio.apps.projectBuild -ccs.projects "+ proJECT + " -ccs.clean -ccs.configuration " + cfgTYP + " -ccs.autoImport" )
    print('CLNCMD: ', clnCMD)
    exit_status = os.system(clnCMD)
    if exit_status > 0:
       ExtErr(clnCMD, exit_status)
    return
	
def bldPROJ():
    bldCMD=(eclipseDIR + "-noSplash -data " + wrkspaceDIR + " -application com.ti.ccstudio.apps.projectBuild -ccs.projects "+ proJECT + " -ccs.FullBuild -ccs.configuration " + cfgTYP + " -ccs.autoImport")
    print(sys.argv[0], ' Processing Project: ', proJECT)
    print('BLDCMD: ', bldCMD)
    exit_status = os.system(bldCMD)
    if exit_status > 0:
       ExtErr(clnCMD, exit_status)
    return  

def aisPROJ():
    print(sys.argv[0], ' Processing Project: ', proJECT)
    global outDIR, projDIR
    global cpyCMD	
    exit_status = os.chdir(rlsDIR)
    output = os.popen('Dir v*.* /B').read()
    outDIR = output[:-1]
    print('OUTDIR: ', outDIR)
    aisfDIR=projDIR+bckslsh+outDIR+'\ARM\Debug'
    aisFIL=aisfDIR +'\\*.cfg'
    print('AISDIR: ', aisfDIR)	
    print('AISFIL: ', aisFIL)
    exit_status = os.path.exists(aisFIL)
    if exit_status > 1:
       ExtErr(aisFIL, exit_status)
    cpTo=projDIR+bckslsh+outDIR+ '\\Release_Config.cfg'
    cpyCMD=(cp + aisFIL + blnk + cpTo + '>NUL')
    my_print('cpyCMD: ', cpyCMD)
    exit_status = os.system(cpyCMD)
    if exit_status > 1:
       ExtErr(cpyCMD, exit_status)
   
    aisfDIR=projDIR+bckslsh+outDIR
    my_print('AISDIR2: ', aisfDIR)
    exit_status = os.chdir(aisfDIR)
    str0=("\n")
    str1=("App File String=" + aisfDIR + "\\ARM\Debug\\arm.out;" + aisfDIR + "\\DSP-v500\\Debug\\DSP-v500.out@0x00000000"+ "\n")
    str2=("AIS File Name=" +  rlsDIR + "\\" + outDIR + "\\Release_Debug.bin" + "\n")  
    print('STR1: ', str1)
    print('STR2: ', str2)
    print('RLSDIR: ', rlsDIR+'\\'+outDIR)   
    exit_status = os.chdir(rlsDIR+'\\'+outDIR)
    sedCMD1=(sed + blnk + "'/App/d '" + ' Release_Config.cfg' + ">" + 'Release_Config1.cfg')
    sedCMD2=(sed + blnk + "'/AIS/d '" + ' Release_Config1.cfg' + ">" + 'Release_Config.cfg')  
    my_print('SEDCMD: ', sedCMD1)
    exit_status = os.system(sedCMD1)
    my_print('SEDCMD: ', sedCMD2)
    exit_status = os.system(sedCMD2)
    
    if os.path.exists('Release_Config1.cfg'):
      os.remove('Release_Config1.cfg')
    else:
      print('No such File: ', Release_Config1.cfg)
	    
    print('String 1:', str1)
    my_print ('String 2: ', str2)
    str1.lstrip()
    str2.lstrip()
    print('String 1:', str1)
    f = open("Release_Config.cfg" , "a")
    f.write(str0)
    f.write(str1)
    f.write(str2)
    f.close()
	
	
    aisCMD=(aisgEXE + '-cfg=' + projDIR +'\\'+outDIR + '\\Release_Config.cfg')
    print('AISCMD: ', aisCMD)
    exit_status = os.system(aisCMD)
    if exit_status > 1:
      ExtErr(aisCMD, exit_status)
    	
    return
     	
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Verify Input 
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
if OS=="nt":
   os.system('cls')
else:
   os.system('clear')
   
projLST=['ARM', 'DSP-v500', 'AIS']
wrkspaceDIR=' '

displayINFO()
print ('Inputs Verified: Release:', ReleaseNum, 'Project: ', proJECT, 'DBG: ', DBG, 'Skip:', Toskip, '\n')

if Toskip=="S":
    Skipme()

if proJECT not in projLST :
    print( proJECT, "Not in list : " , projLST)
    raise SystemExit()
my_print('IN - BUILD: ', ' ')

## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Time Stamp Start of Process
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
print('++++++++++++++++++++++++++++++++++++++++++++++++++++')
print ('Processing Started @')
print(starTime)
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## BLD Main Program
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
svnPROJ()
if proJECT =="AIS":
   aisPROJ()
else:

  ldPROJ()
  clnPROJ()
  bldPROJ()

print('++++++++++++++++++++++++++++++++++++++++++++++++++++')
print ('Processing Started @')
print(starTime)
print('Processing Completed @')
Tstamp(2)

raise SystemExit()