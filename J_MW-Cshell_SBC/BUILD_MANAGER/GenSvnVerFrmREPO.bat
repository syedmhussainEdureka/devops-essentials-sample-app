@echo off & setlocal
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: 	Name of File: GenSvnVerFrmREPO.bat
::
:: 	Ver: 0.1
::
::	Author: Syed M Hussain @ DRS
::
::      SEE HELP FOR DETAILS
::
::
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
SETLOCAL ENABLEEXTENSIONS
SETLOCAL ENABLEDELAYEDEXPANSION
SET me=%~n0
SET parent=%~dp0
set argCount=0
set tld=no
set "xstr=^^^&" 
for %%x in (%*) do (
   set /A argCount+=1
)

if "%1"=="" (call :help && exit /b 1)
if "%2"=="" (call :help && exit /b 1)
if NOT "%3"=="" (call :help && exit /b 1)

set "BLNK= "
set SVNLST=svn ls -R 
set SVNINFO=svn info 
set space=no

:: Time Stamp Start of Process
Call :Tstamp
set tStr=%Time%
set f1name=!tStr!_null
set f2name=!tStr!_null

:: Verify and Validate the Input Strings
:: First: SVN Repo
set str="%~1"
set LBL=ONE
goto CheckInput 
:ONE
set SVNREPO_PATH=%str1%
if "%1"=="D" (set SVNREPO_PATH=https://davms120131.core.drs.master/svn/) 

:: Second: SVN Repo Directory
set str="%~2"
set LBL=TWO
goto CheckInput 

:TWO
set SVNDIR=%str2%
::
:: Control CSCI 
:: if "%2"=="D" (set SVNDIR=/J_CTRL_SW/branches/1_X_INTEGRATION/BUILD_MANAGER/ARM_ONLY/)
:: if "%2"=="D" (set SVNDIR=/J_CTRL_SW/tags/2132/ARM_ONLY/)
:: CP_FPGA_CSCI 
:: if "%2"=="D" (set SVNDIR=J0015_CP_FPGA/trunk_1400/asp_fpga/)
::
:: LW CPLD CSCI: **************
:: if "%2"=="D" (set SVNDIR=J0015_Sensor_CPLD/tags/Sensor_CPLD_1400/)
::
:: PS CP_CPLD:
:: if "%2"=="D" (set SVNDIR=J0015_CP_CPLD//trunk_1400/)
::
:: SBC CSCI
if "%2"=="D" (set SVNDIR=J_MW_Cshell/tags/2132/)
::
:: Sensor_FPGA_CSCI: ******
:: if "%2"=="D" (set SVNDIR=J0015_Sensor_FPGA/tags/D2S_FPGA_1400/d2s_top/)
::
:: Sensor_SW 
:: if "%2"=="D" (set SVNDIR=J0015_Sensor_OMAP/tags/2132/)

		        
:: OUT The Inputs on Screen for Validation

echo Inputs:  %SVNREPO_PATH%  %SVNDIR%

:: Form the SVN List Command and Later the SVN Info Command

set LSTCMD="%SVNLST%%SVNREPO_PATH%%SVNDIR%"
echo LISTCMD is =%LSTCMD%
echo.

:: For Loop to get the individual File Names


for /f "tokens=* delims= " %%a in (' %LSTCMD% 2^>null_1') do  (if errorlevel 1 call :LSTCMD_fail
    set flnme=%%a
    set mainstring=%%a 
    
   if errorlevel 1 call :LSTCMD_fail 
   if "!flnme!"==" " (echo " Completed " && goto :EOF)

   for /f "tokens=2" %%a in ("!flnme!") do (set space=yes)
   if "%space%"=="yes" (echo *** FILE NAME CONTAINS SPACES *** && set space=no)
   if "%space%"=="yes" (call :SpaceErr)
   
   set NFOCMD="%SVNINFO% %SVNREPO_PATH%%SVNDIR%!flnme!|Find "Rev:" "
   set NFOCMD=!NFOCMD:^&=^^^&!

   echo NFOCMD: !NFOCMD! >NUL
   
   for /f "tokens=* delims= " %%a in (' !NFOCMD! 2^>null_2 ') do (set str=%%a)
   if errorlevel 1 (goto :NFOCMD_fail)

   for /f "tokens=1,4 delims= "  %%a in ( "!str!" ) do (set ver=%%b)

   set mainstring=!mainstring:^&=^^^&!

   echo STR: %str% Ver: %ver% MStr: !mainstring! >NUL
   
   call :GetCharCount FwdslashCount !mainstring! "/"
   if errorlevel 1 goto END
   call :FileDetails "!flnme!" !FwdslashCount!
   if errorlevel 1 goto END
   )

) 
   echo.
   echo "Completed Processing"  
:: Time Stamp END of Processing
Call :Tstamp
ENDLOCAL
exit /b 0
:END
ENDLOCAL
goto EOF
:: REM ++++++++++++++++++++++++++++++++++++++++++++
:: REM ***** Only functions below this line *****
:: REM ++++++++++++++++++++++++++++++++++++++++++++

:help
@echo in %0
echo %parent%%me%
echo *** INVALID ENTRY ***
echo ::
echo :: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
echo ::	Description:
echo ::		This file will generate the version number of the directories and files
echo ::		given the SVN repository and the Path to the Source Directory
echo ::
echo :: 	Input Required: 
echo ::		1. The SVN Repository Name and Path
echo ::		2. Fll Path and Name of the Source Directory
echo :: 		
echo ::		You can choice the Default repository or Enter the Name
echo ::
echo ::		Example:
echo ::		GenSvnVerFrmREPO.bat Def [J0015_CP_FPGA/tags]
echo ::		GenSvnVerFrmREPO.bat [https://davms120131.core.drs.master/svn/] [J0015_CP_FPGA/tags]
echo ::
echo :: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
::
goto EOF
exit /b 
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
:Tstamp
echo %DATE% %TIME%
goto EOF
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: Routine for Checking the Recursive Directories and Display the "File Name"  Ver and Dir 
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:FileDetails "!flnme!" !FwdslashCount!
             if "%tld%"=="no" (if "!FwdslashCount!"=="0" (Echo This is First Level Dircetory ONLY && set tld=yes)) 
             if "!FwdslashCount!"=="0"(for /f "tokens=1,2 delims=/"  %%a in ( "!flnme!" ) do (set dir=%%a && set fle=%%b && set loc=%%a))      
             if "!FwdslashCount!"=="1" (for /f "tokens=1,2 delims=/"  %%a in ( "!flnme!" ) do (set dir=%%a && set fle=%%b && set loc=%%a))      
             if "!FwdslashCount!"=="2" (for /f "tokens=1,2,3 delims=/"  %%a in ( "!flnme!" ) do (set dir=%%b && set fle=%%c && set loc=%%a/%%b))
             if "!FwdslashCount!"=="3" (for /f "tokens=1,2,3,4 delims=/"  %%a in ( "!flnme!" ) do (set dir=%%c && set fle=%%d && set loc=%%a/%%b/%%c)) 
             if "!FwdslashCount!"=="4" (for /f "tokens=1,2,3,4,5 delims=/"  %%a in ( "!flnme!" ) do (set dir=%%d && set fle=%%e && set loc=%%a/%%b/%%c/%%d)) 
	     if "!FwdslashCount!"=="5" (for /f "tokens=1,2,3,4,5,6 delims=/"  %%a in ( "!flnme!" ) do (set dir=%%e && set fle=%%f && set loc=%%a/%%b/%%c/%%d/%%e)) 
	     if "!FwdslashCount!"=="6" (for /f "tokens=1,2,3,4,5,6,7 delims=/"  %%a in ( "!flnme!" ) do (set dir=%%f && set fle=%%g && set loc=%%a/%%b/%%c/%%d/%%e/%%f)) 
	     if "!FwdslashCount!"=="7" (for /f "tokens=1,2,3,4,5,6,7,8 delims=/"  %%a in ( "!flnme!" ) do (set dir=%%g && set fle=%%h && set loc=%%a/%%b/%%c/%%d/%%e/%%f/%%g)) 
	     if "!FwdslashCount!"=="8" (for /f "tokens=1,2,3,4,5,6,7,8,9 delims=/"  %%a in ( "!flnme!" ) do (set dir=%%h && set fle=%%i && set loc=%%a/%%b/%%c/%%d/%%e/%%f/%%g/%%h))    
	     if "!FwdslashCount!"=="9" (for /f "tokens=1,2,3,4,5,6,7,8,9,10 delims=/"  %%a in ( "!flnme!" ) do (set dir=%%i && set fle=%%j && set loc=%%a/%%b/%%c/%%d/%%e/%%f/%%g/%%h/%%i))    
	     if "!FwdslashCount!"=="10" (for /f "tokens=1,2,3,4,5,6,7,8,9,10,11 delims=/"  %%a in ( "!flnme!" ) do (set dir=%%j && set fle=%%k && set loc=%%a/%%b/%%c/%%d/%%e/%%f/%%g/%%h/%%i/%%j)) 
             if "!FwdslashCount!"=="11" (for /f "tokens=1,2,3,4,5,6,7,8,9,10,11,12 delims=/"  %%a in ( "!flnme!" ) do (set dir=%%k && set fle=%%l && set loc=%%a/%%b/%%c/%%d/%%e/%%f/%%g/%%h/%%i/%%j/%%k))
             if "!FwdslashCount!"=="12" (for /f "tokens=1,2,3,4,5,6,7,8,9,10,11,12,13 delims=/"  %%a in ( "!flnme!" ) do (set dir=%%l && set fle=%%m && set loc=%%a/%%b/%%c/%%d/%%e/%%f/%%g/%%h/%%i/%%j/%%k/%%l))
             if "!FwdslashCount!"=="13" (goto DIRERR)  
  	     if "!FwdslashCount!"=="14" (goto DIRERR)
             
	     
             if "!FwdslashCount!"=="0" (echo !flnme!, !ver!, !dir!, !loc! )
             if NOT "!FwdslashCount!"=="0" (echo !fle!,	!ver!, !dir!, !loc!)
:Cont 
exit /b 
goto END
:SpaceErr
echo %parent%%me%
@echo in %0  ********************* Space Error - NO spaces in File name allowed ********************* 
 exit /b 1 
:END
:DIRERR
echo %parent%%me%
@echo in %0  ********************* DIRECTORY ERROR - Nested too deep - !FwdslashCount! ********************* 
 exit /b 1 
:END
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:: Routine to Display Error Mesg for the Svn List Command
:: +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:LSTCMD_fail 
    echo on
    echo  Error on %LSTCMD%
    exit /b 
    goto :EOF
    goto END
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
