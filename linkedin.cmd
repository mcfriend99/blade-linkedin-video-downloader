@ECHO OFF
SETLOCAL
set SCRIPT_DIR="%~dp0"
set LINKEDIN_DIR=%SCRIPT_DIR:~0,-1%
blade.exe "%LINKEDIN_DIR%\linkedin" %*
