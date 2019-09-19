@echo OFF
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

SET SVN_USERNAME=Syed.Hussain
SET SVN_PASSWD=$yed4$yed0101
SET SVN_URL=https://davms120131.core.drs.master/svn/J_MW_Cshell
SET SVNLST=svn log --username=%SVN_USERNAME% --passwd=%SVN_PASSWD% ls %SVN_URL%
%SVNLST%
expect "(R)eject, accept (t)emporarily or accept (p)ermanently? "
send --"p\r"
expect "Store password unencrypted (yes/no)? "
send "no\r"
expect -re "root@.*:\/#"
