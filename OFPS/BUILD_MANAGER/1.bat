SETLOCAL ENABLEEXTENSIONS
SETLOCAL ENABLEDELAYEDEXPANSION

   for /f "tokens=1,2 delims=/="  %%a in ( 'env.bat' ) do (set ver=%%a 
   echo %ver%
   echo set %%a=>>2.bat
   )