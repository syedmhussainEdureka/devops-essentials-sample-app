
goto STEP3

:STEP1
"C:\Program Files\Coverity\Coverity Static Analysis\bin\cov-build.exe" --no-log-server --dir "C:\Temp\cov-build_Sensor_SW" C:\ti\ccsv5\eclipse\eclipsec -noSplash -data "E:\DAIRCM\BUILDS\Sensor_SW_CSCI\J0015_Sensor_OMAP\WORKSPACES" -application com.ti.ccstudio.apps.projectBuild -ccs.projects ARM -ccs.buildType clean -ccs.configuration Debug -ccs.autoImport
IF /I "%ERRORLEVEL%" EQU "1" EXIT /B 1



:STEP2
"C:\Program Files\Coverity\Coverity Static Analysis\bin\cov-build.exe" --no-log-server --dir "C:\Temp\cov-build_Sensor_SW" C:\ti\ccsv5\eclipse\eclipsec -noSplash -data "E:\DAIRCM\BUILDS\Sensor_SW_CSCI\J0015_Sensor_OMAP\WORKSPACES" -application com.ti.ccstudio.apps.projectBuild -ccs.projects ARM -ccs.buildType full -ccs.configuration Debug -ccs.autoImport
IF /I "%ERRORLEVEL%" EQU "1" EXIT /B 1

goto END

:STEP3


:STEP4
"C:\Program Files\Coverity\Coverity Static Analysis\bin\cov-analyze.exe" --dir C:\temp\cov-build_Sensor_SW --all --enable-fnptr --enable-callgraph-metrics --strip-path E:\DAIRCM\BUILDS\Controls_CSCI\J_CTRL_SW\WORSPACES\INTEGRATION\ARM_ONLY --aggressiveness-level medium 
IF /I "%ERRORLEVEL%" EQU "1" EXIT /B 1

goto END
"C:\Program Files\Coverity\Coverity Static Analysis\bin\cov-commit-defects.exe" --dir C:\temp\cov-build_Sensor_SW --host coverity.core.drs.master --port 8009 --user coverity --password system --stream CI-INTEGRATION
IF /I "%ERRORLEVEL%" EQU "1" EXIT /B 1

:END