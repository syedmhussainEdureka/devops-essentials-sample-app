@ECHO OFF
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION
:: GOTO :STEP1

Echo Calling SvnExport_SBC.bat  tags 2129 1.3.25_src N N N S
Call SvnExport_SBC.bat tags 2129 1.3.25_src N N N N

:STEP1
Echo Calling Build_TRU.bat tags 2129 1.3.25_src B
Call Build_TRU.bat tags 2129 1.3.25_src B
:STEP2
Echo Calling Build_Tracker.bat 2129 1.3.25_src B
Call Build_Tracker.bat 2129 1.3.25_src B

Exit /B
:End