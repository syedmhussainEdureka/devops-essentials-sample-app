#!/usr/bin/python
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## 	Name of File: Build_SW_Control_PS.py
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

def helpme():
    
    """++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  
        Description:
	    This batch file will build the SW Control binaries ** CNTRL SW ** given the
	    The Release NUMBER
	
 	    Inputs Required:
	    1. Release - Release Number /String
	    2. Project Name: bareMetalDSP, omap_arm,  or AIS
	    3. Turn DUBUG ON: D for Debug
	    4. Skip Entire Build
	
	    Example:
	
	    Build_SW_Control.py: 1400 omap_arm D S
	
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"""
    return
		
if argsNUM < 4:
   os.system('clear')
   helpme()
   print(helpme.__doc__)
   raise SystemExit()

proJECT=(sys.argv[2])	
DBG=(sys.argv[3]) 
Toskip=(sys.argv[4])
 
## cfg_SW_Control.py is the Config File where all the common stuff for cfg_SW_Control is defined
exec(open('C:\\DAIRCM\\BUILDS\\J_CTRL_SW_Control\\BUILD_MANAGER\\cfg_SW_Control.py').read())

##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Functions Defined Here 
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

##
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
##
def ldPROJ():
    my_print('IMPCMD: ', impCMD)   
    os.system(impCMD)
    return
   
	
def clnPROJ():
    my_print('CLNCMD: ', clnCMD)
    exit_status = os.system(clnCMD)
    if exit_status > 0:
       ExtErr(clnCMD, exit_status)
    return
	
	
def bldPROJ():
    print(sys.argv[0], ' Processing Project: ', proJECT)
    my_print('BLDCMD: ', bldCMD)
    exit_status = os.system(bldCMD)
    if exit_status > 0:
       ExtErr(clnCMD, exit_status)
    return  

def aisPROJ():
    print(sys.argv[0], ' Processing Project: ', proJECT)
    my_print('AISDIR: ', aisfDIR)	
    my_print('AISFIL: ', aisFIL)
    exit_status = os.path.exists(aisFIL)
    if exit_status > 1:
       ExtErr(aisFIL, exit_status)
    my_print('cpyCMD: ', cpyCMD)
    exit_status = os.system(cpyCMD)
    if exit_status > 1:
       ExtErr(cpyCMD, exit_status)
    projDIR=rlsDIR+bckslsh+projNME
    my_print('PROJDIR: ', projDIR)   
    exit_status = os.chdir(projDIR)
  
    my_print('SEDCMD: ', sedCMD1)
    exit_status = os.system(sedCMD1)
    my_print('SEDCMD: ', sedCMD2)
    exit_status = os.system(sedCMD2)

    if os.path.exists('Release_Config1.cfg'):
      os.remove('Release_Config1.cfg')
    else:
      print('No such File: ', Release_Config1.cfg)
	    
    my_print('String 1: ', str1)
    my_print ('String 2: ', str2)

    f = open("Release_Config.cfg" , "a")
    f.write(str1)
    f.write(str2)
    f.close()
	
    my_print('AISCMD: ', aisCMD)
    exit_status = os.system(aisCMD)
    if exit_status > 1:
      ExtErr(aisCMD, exit_status)
    	
    return
     	
#del %ProjBldDir%\%RlNum%\BUILD_MANAGER\ARM_ONLY\Release_Config1.cfg	
##+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Verify Input 
## +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


if OS=="nt":
   os.system('cls')
else:
   os.system('clear')
   
projLST=['bareMetalDSP', 'omap_arm', 'AIS']

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