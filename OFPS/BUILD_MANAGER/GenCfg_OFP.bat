@echo off & setlocal
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: 	Name of File: GenOfpcfg.bat
::
:: 	Ver: 0.1	Date:02/28/2018
::
::	Author: Syed M Hussain @ DRS
::
::      SEE HELP FOR DETAILS
::
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
SETLOCAL ENABLEEXTENSIONS
SETLOCAL ENABLEDELAYEDEXPANSION
SET me=%~n0
SET parent=%~dp0

set tld=no
 
if "%~4"=="" if "%~5"=="" (goto :help)

set SVNLST=svn ls  
set SVNINFO=svn info 
set space=no

:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: Display the Inputs
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo Input: Repo:%1 Release:%2 Build NUM:%3 Debug:%4  Skip:%5

:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: Time Stamp Start of Process
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


echo "Processing Started @"
Call :Tstamp
echo. 
if S==%5 goto SkipComp

set tStr=%Time%
set f1name=!tStr!_null
set f2name=!tStr!_null
set DBG=::
set fle=""
set flnme=""
set loc=""

:: Verify and Validate the Input Strings
:: First: SVN Repo
set str="%~1"
set LBL=ONE
goto CheckInput 
:ONE
set SVNREPO_PATH=%str1%
if "%1"=="D" (set SVNREPO_PATH=https://davms120131.core.drs.master/svn/System_Binaries) 
if "%3"=="D" (set DBG=)
set RLSNUM=%2
:: Second: Release 
set str="%~2"
set LBL=TWO
goto CheckInput 


:TWO
set SVNDIR=%str2%

cd C:\DAIRCM\BUILDS\OFPS\%RLSNUM%\
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: Initialize - Check to see if SVN Repo is Available
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Call :Init_Repo
if /I "%ERRORLEVEL%" EQU "1" (goto END)

:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
::  Check to see if Release is Available
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Call :Check_Release
if "%str%"=="E200009" (goto END)

:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
::  Load up Data for processing 
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Call :Load_Data

:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: Get the date and Time of Day AM or PM 
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

set mydate=%DATE:~-10,2%/%DATE:~-7,2%/%DATE:~-2%%
for /f "tokens=1,2 delims= " %%a in (' Time /T ') Do (set mytime=%%b)


:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: Initialize/Open the cfg file 
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
cd C:\DAIRCM\BUILDS\OFPS\%RLSNUM%\
set BldNum=F00%3%
echo [OFG_CFG]>file_cfg_long.txt
echo FT^|1 >>file_cfg_long.txt
echo OFPV^|%RLSNUM%%BldNum%>>file_cfg_long.txt
echo DESC^|%RLSNUM% %mydate% %mytime% TDF>>file_cfg_long.txt
echo UDF^|>>file_cfg_long.txt

echo [OFG_CFG]>file_cfg.txt
echo FT^|1 >>file_cfg.txt
echo OFPV^|%RLSNUM%%BldNum%>>file_cfg.txt
echo DESC^|%RLSNUM% %mydate% %mytime% TDF>>file_cfg.txt
echo UDF^|>>file_cfg.txt

%DBG% echo BldNum: %BldNum%

set /A i=0
set /A lmt=7
set /A lnenum=0

:STRT
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: OUT The Inputs on Screen for Validation
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  
echo.

:: Form the SVN List Command and Later the SVN Info Command

set /a knt=0
%DBG% echo Processing: !SVNDIRA[%i%]! F:!flExtA[%i%]! N:%RLSNUM% I:%i%  
:loop
echo Processing: !SVNDIRA[%i%]! 
set SVNDIR=!SVNDIRA[%i%]!
set flExt=!flExtA[%i%]!

if "%i%" == "7" (goto nSbc)

  Call :PrfleData 
  if "!i!" LEQ "6" (goto :LPBCK)
  
:nSbc
    
	 set j=0
	 set SVNDIR=!SVNDIRA[%i%]!

:sbcLoop
     %DBG% echo in sbcLoop
	 echo Processing: !SVNDIRA[%i%]! File:!SBCFiles[%j%]! 
	 set SVNDIR=!SVNDIRA[%i%]!
     set str="!SBCFiles[%j%]!"
	 %DBG% echo str: %str% SVND=%SVNDIR% SVND1=!SVNDIRA[%i%]! File=!SBCFiles[%%j]! 
	 
	 set SVNLST=svn ls -R 
     set LSTCMD7="%SVNLST%%SVNREPO_PATH%!SVNDIRA[%i%]! |Find %str% >%i%_lst_%knt%_%j%.log"
     %DBG% echo LSTCMD7 is =%LSTCMD7% 
     %DBG% echo.
	 
	  for /f "tokens=* delims= " %%a in (' !LSTCMD7! ') do  (if /I "%ERRORLEVEL%" EQU "1"  call :LSTCMD_fail)
	  for /f "tokens=* delims= " %%a in ('Type %i%_lst_%knt%_%j%.log') Do (set flnme=%%a)
	  
	  %DBG% echo FLNM: %flnme%
	  
   set NFOCMD="%SVNINFO% %SVNREPO_PATH%%SVNDIR%!SBCLST[%j%]!|Findstr "Rev:" "
   set NFOCMD=!NFOCMD:^&=^^^&!
   %DBG% echo NFOCMD: !NFOCMD!
   
   for /f "tokens=* delims= " %%a in (' !NFOCMD! 2^>null_2 ') do (set str=%%a)
   %DBG% echo NFOCMD: %ERRORLEVEL%
   if /I "%ERRORLEVEL%" EQU "1" (goto :NFOCMD_fail)
   
   for /f "tokens=1,4 delims= "  %%a in ( "!str!" ) do (set ver=%%b)

   call :GetCharCount FwdslashCount "!flnme!" "/"
   if /I "%ERRORLEVEL%" EQU "1"  goto END
   call :FileDetails "!flnme!" !FwdslashCount!
   if /I "%ERRORLEVEL%" EQU "1"  goto END
       
   echo !lnenum!^|%SVNREPO_PATH%%SVNDIR%!flnme!@!ver!>>file_cfg_long.txt
   echo !lnenum!^|!SBCFiles[%j%]!>>file_cfg.txt
   
   %DBG% echo J: %j% FileName: !SBCFiles[%j%]!
   if "!j!" EQU "4" (set flnme=!SBCLST[%j%]! )
   %DBG% echo J: %j% FileName: !flnme!
   set EXPCMD=SVN export --force -q %SVNREPO_PATH%%SVNDIR%!flnme! . 
   !EXPCMD!
   echo Downloading: !SBCFiles[%j%]!
   echo.
     
       set /a j+=1	
       set /a lnenum+=1	   
       
	   if "!j!" LEQ "6" (goto sbcLoop)

      goto PEND  


  
:LPBCK
 set /A i+=1
  %DBG% echo I: %i%
  %DBG% echo ** _____________________________________________________________________ **
  if "!i!" LEQ "!lmt!" (goto STRT)
:PEND
   echo.
   echo "Completed Processing"  
  
::Call :Fixcfg
Call :Tstamp
Call :CleanUp
cd %parent%
ENDLOCAL
exit /b 0
go to END
ENDLOCAL
goto EOF
:: REM ++++++++++++++++++++++++++++++++++++++++++++
:: REM ***** Only functions below this line *****
:: REM ++++++++++++++++++++++++++++++++++++++++++++

:help
clear
@echo "From--->" %0.bat:
:: echo %parent%%me%
echo *** INVALID ENTRY ***
echo ::
echo :: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo ::	Description:
echo ::		This batch file will generate the file_cfg_long.txt and the file_cfg.txt file for the 
echo ::		OFP. It will also download all the files neeed to build the OFP with the correct revision
echo ::		Numbers. 
echo ::		The file_cfg_long.txt:
echo ::		displays the full path Name and Version Number downloaded from the 
echo ::		SVN Repository. This verifies and Validates the files that will be used for the OFP build.
echo ::
echo ::    The file_cfg.txt:
echo ::	   contains ONLY the Name of the Files, is used to generate the OFP
echo ::  
echo ::
echo :: 	Input Required: 
echo ::		1. The SVN Repository Name and Path - D for Default Current SVN Repo
echo ::		2. The Release 
echo ::		3. The OFP Build Number - Default is 0
echo ::		4. Using Dubug - D for Debug for Trouble shooting
echo ::		5. To Skip the whole Process - S 
echo :: 		
echo ::
echo ::		Example:
echo ::		%me%.bat D 1400 0 N N -- Default Build
echo ::		%me%.bat D 1400 1 N N
echo ::		%me%.bat D 1400 1 D S		
echo ::
echo :: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
::
goto EOF
exit /b 
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: Process File DATA
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:PrfleData %SVNLST% %SVNREPO_PATH% %SVNDIR% ".%flExt%" %i% %flnme% %RLSNUM%

set SVNLST=svn ls -R 
set LSTCMD1="%SVNLST%%SVNREPO_PATH%%SVNDIR% |Findstr ".%flExt%" >%i%_lst_%knt%.log"
%DBG% echo LSTCMD1 is =%LSTCMD1% 
%DBG% echo.
   for /f "tokens=* delims= " %%a in (' !LSTCMD1! ') do  (if /I "%ERRORLEVEL%" EQU "1"  call :LSTCMD_fail)
   for /f "tokens=* delims= " %%a in ('Type %i%_lst_%knt%.log') Do (set flnme=%%a)
   
  %DBG% echo FLNM: %flnme%
  %DBG% echo Calling GitInfo2 %SVNINFO% %SVNREPO_PATH% %SVNDIR% %i% %flnme% %RLSNUM%
  if NOT "%flnme%"==""  (Call :gtInfo2 %SVNINFO% %SVNREPO_PATH% %SVNDIR% %i% %flnme% %RLSNUM%
  set /a lnenum+=1)
exit /b 
goto END

::
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: Routine - Check to see if SVN Repo is Available
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:Init_Repo 
setlocal
set SVNLST=svn ls  
set LSTCMD="%SVNLST%%SVNREPO_PATH%"
%DBG% echo Check to see if SVN Repo is Available: %LSTCMD% 
%DBG% echo.
for /f "tokens=* delims= " %%a in (' !LSTCMD! ') do  (if /I "%ERRORLEVEL%" EQU "1"  call :Init_fail) 
endlocal
exit /b 
goto END
::
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: Rountine  Check to see if Release is Available
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:Check_Release
setlocal
set SVNLST=svn ls  
set LSTCMD="%SVNLST%%SVNREPO_PATH%/SBC/%RLSNUM% >Err.log 2>&1"
%DBG% echo Check to see if Release is Available  %LSTCMD% 
%DBG% echo.

for /f "tokens=* delims= " %%a in (' !LSTCMD!') do  (if /I "%ERRORLEVEL%" EQU "1"  call :Release_fail) 
for /f "tokens=* delims= " %%a in (Err.log) do (set str=%%a)
set str=%str:~5,7%
%DBG% echo %result%
if "%str%"=="E200009" (call :Release_fail)
endlocal
exit /b 
goto END
::
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
::  set up the information in Array for Processing 
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:Load_Data 
::
::
:: First load up the Directories
::
set /A n=0
for %%a in (/"CP FPGA"/%RLSNUM%/
            /Control/%RLSNUM%/
            /Laser/%RLSNUM%/
	        /"CP CPLD"/%RLSNUM%/
            /Sensor_OMAP_ARM_Laser_Warning/%RLSNUM%/
            /"Sensor CPLD"/%RLSNUM%/
            /"Sensor FPGA"/%RLSNUM%/
            /SBC/%RLSNUM%/
           ) do (
   set SVNDIRA[!n!]=%%a
  
   set /A n+=1
)

::
:: Second load up the File EXtension to search
:: 

set /A n=0
for %%a in (mcs
            bin
            dld
	        cpd
            bin
            cpd
            bin
            out
           ) do (
   set flExtA[!n!]=%%a
   set /A n+=1
)

:: Load up the SBC File list With Dir 

set /A n=0
for %%a in (ahci00_1/Tracker/T3AppTracker.out
            ahci00_1/Tracker/Tracker.vx
            ahci00_1/Tracker/Reprogrammer.out
	        ahci00_1/Udf/UDFDecoder.out
            ahci01_1/vxWorks
            ahci01_1/vxWorks.sym
            ahci00_1/Tracker/HFITracker.vx     
           ) do (
   set SBCLST[!n!]=%%a
   set /A n+=1
)

:: Load up the SBC File list

set /A n=0
for %%a in (T3AppTracker.out
            Tracker.vx
            Reprogrammer.out
	        UDFDecoder.out
            vxWorks
            vxWorks.sym
            HFITracker.vx     
           ) do (
   set SBCFiles[!n!]=%%a
   set /A n+=1
)

goto EOF
goto END
::
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: Rountine for Verify the Inputs
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:CheckInput <string>
set space=no
set str=%~1
for /f "tokens=2" %%a in ("%str%") do (set char=%%b)
if "!char!"=="" goto :cntue
set space=yes
@echo on
if "%space%"=="yes" (echo  Input Contains Space, No spaces Allowed)
@echo off
  set space=no
   
:cntue
goto %LBL%
goto EOF

:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: Routine for CleanUp
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:CleanUp
rm *.log
goto EOF
::
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: Routine to Fixcfg - remove any Blanks
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:FixCfg
cd C:\DAIRCM\BUILDS\OFPS\%RLSNUM%\
:: set FIXCMD=powershell -Nop -C "(gc .\file_cfg.txt) -replace '(?<!-) \s+(?=\||$)'|sc file_cfg.txt"
for /f "tokens=*" %%a in (1.junk) do (
  set newline=%%a
   call set newline= %%newline:this=that %%
   call echo %%newline%% >>1.tmp
)

%DBG% echo !FIXCMD!
!FIXCMD!
goto EOF
::


:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: Routine for Time Stamp
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:Tstamp
echo %DATE% %TIME%
goto EOF
::
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: Routine for Checking the Recursive Directories and Display the "File Name"  Ver and Dir 
:: echo in "FileDetails" AB:  %~1 C:%~2 
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:FileDetails "!flnme!" !FwdslashCount!


::: echo FileName: !flnme!  FlashCount: !FwdslashCount!

             if "%tld%"=="no" (if "!FwdslashCount!"=="0" (set tld=yes)) 
             if "!FwdslashCount!"=="0"(for /f "tokens=1,2 delims=/"  %%a in ( "!flnme!" ) do (set dir=%%a && set fle=%%b && set loc=%%a))      
             if "!FwdslashCount!"=="1" (for /f "tokens=1,2 delims=/"  %%a in ( "!flnme!" ) do (set dir=%%a && set fle=%%b && set loc=%%a))      
             if "!FwdslashCount!"=="2" (for /f "tokens=1,2,3 delims=/"  %%a in ( "!flnme!" ) do (set dir=%%b && set fle=%%c && set loc=%%a/%%b))
             if "!FwdslashCount!"=="3" (for /f "tokens=1,2,3,4 delims=/"  %%a in ( "!flnme!" ) do (set dir=%%c && set fle=%%d && set loc=%%a/%%b/%%c)) 
             if "!FwdslashCount!"=="13" (goto DIRERR)  
  	         if "!FwdslashCount!"=="14" (goto DIRERR)
            
%DBG% if "!FwdslashCount!"=="0" (echo F1: !flnme!, !ver!, !dir!, !loc! )
%DBG% if NOT "!FwdslashCount!"=="0" (echo F2: !fle!,	!ver!, !dir!, !loc!)      
             
:Cont 
exit /b 
goto END
::
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: 
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:gtInfo2 %SVNINFO% %SVNREPO_PATH% %SVNDIR% %i% !flnme! %RLSNUM%
  %DBG% echo in gtinfo2 %SVNINFO% %SVNREPO_PATH% %SVNDIR% %i% !flnme! %RLSNUM%
      
   set NFOCMD="%SVNINFO% %SVNREPO_PATH%%SVNDIR%!flnme!|Find "Rev:" "
   set NFOCMD=!NFOCMD:^&=^^^&!
   %DBG% echo NFOCMD: !NFOCMD!

   for /f "tokens=* delims= " %%a in (' !NFOCMD! 2^>null_2 ') do (set str=%%a)
   %DBG% echo NFOCMD: %ERRORLEVEL%
   if /I "%ERRORLEVEL%" EQU "1" (goto :NFOCMD_fail)
   
   for /f "tokens=1,4 delims= "  %%a in ( "!str!" ) do (set ver=%%b)
 
   call :GetCharCount FwdslashCount "!flnme!" "/"
   if /I "%ERRORLEVEL%" EQU "1"  goto END
   call :FileDetails "!flnme!" !FwdslashCount!
   if /I "%ERRORLEVEL%" EQU "1"  goto END
   
   
   %DBG% echo !lnenum!^|%SVNREPO_PATH%%SVNDIR%!flnme!@!ver! to file_cfg_long.txt 
   echo !lnenum!^|%SVNREPO_PATH%%SVNDIR%!flnme!@!ver!>>file_cfg_long.txt
    
  If NOT "%flnme%"=="%flnme:/=%" (  
   %DBG% echo !lnenum!^|!fle!to file0_cfg.txt  
   set "fle=!fle: =!"
::   set "a=%a: =%"  
   echo !lnenum!^|!fle!>>file_cfg.txt
   echo Yes >Nul
   goto expt
) else (  
    
    %DBG% echo !lnenum!^|!flnme! to file1_cfg.txt
    echo !lnenum!^|!flnme!>>file_cfg.txt
    echo No >Nul
)
      
:expt
   set EXPCMD=SVN export --force -q %SVNREPO_PATH%%SVNDIR%!flnme! .
   %DBG% echo SVN Export: !EXPCMD!
   !EXPCMD!
   echo Downloading: !flnme!
   echo.
   
exit /b
goto EOF
::
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: 
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:SkipComp
echo "Skipping Build as requested: @"
Call :Tstamp
goto END

::
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: 
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
::
:SpaceErr
echo %parent%%me%
@echo in %0  ********************* Space Error - NO spaces in File name allowed ********************* 
 exit /b 1 
::
:DIRERR
echo %parent%%me%
@echo in %0  ********************* DIRECTORY ERROR - Nested too deep - !FwdslashCount! ********************* 
 exit /b 1 
::
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: Routine to Display Error Mesg for the Svn INITFAIL
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:Init_fail
    echo on
    echo  Error on Initialize: Check to See if SVN REPO is Available
    exit /b 
    goto :EOF
    goto END

::
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: Routine to Display Error Mesg for the Svn INITFAIL
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:Release_fail
    
    echo  Error on Release: Check to See if %RLSNUM% is Available
	echo off
    exit /b 
    goto :EOF
    goto END
::
::
::
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: Routine to Display Error Mesg for the Svn List Command
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:LSTCMD_fail 
    echo on
    echo  Error on %LSTCMD%
    exit /b 
    goto :EOF
    goto END
::
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: Routine to Display Error Mesg for the Svn Info Command
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:NFOCMD_fail 
    echo Error on %NFOCMD%
      exit /b 
    goto :EOF
    goto END
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: Routine to get the Char Count
:: REM echo in "GetCharCount" A:  %~1 %~2 %~3
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:GetCharCount <Variable> <string> <Char>
setlocal
set String=%~2
set /a i = 0
set /a CharCount = 0
:GetCharCountLoop
set Char=!String:~%i%,1!
if not "%Char%"=="" (
	if /i "%Char%"=="%~3" (set /a CharCount += 1)
	set /a i+= 1
	goto GetCharCountLoop	
)
endlocal&set %~1=%CharCount%

goto :eof

:EOF
ENDLOCAL
endlocal
:: Exit from the Program
:END 
ENDLOCAL