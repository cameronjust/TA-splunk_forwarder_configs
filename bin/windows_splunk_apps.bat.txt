@echo off

REM Windows why don't you have a decent ability to format a date time in a batch file??? Why?
set logTime=%date:~-4%-%date:~7,2%-%date:~4,2% %time:~0,2%:%time:~3,2%:%time:~6,2%

REM Set the directory you want to list - couldn't get this to work with below for some reason???
set targetDirectory="C:\Program Files\SplunkUniversalForwarder\etc\apps"

dir /b /ad "C:\Program Files\SplunkUniversalForwarder\etc\apps"
