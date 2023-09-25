@echo off

REM Windows why don't you have a decent ability to format a date time in a batch file??? Why?
set logTime=%date:~-4%-%date:~7,2%-%date:~4,2% %time:~0,2%:%time:~3,2%:%time:~6,2%

set "directory_uf=C:\Program Files\SplunkUniversalForwarder\bin\"
set "directory_hf=C:\Program Files\Splunk\bin\"

if exist "%directory_uf%" (
	dir /b /ad "C:\Program Files\SplunkUniversalForwarder\etc\apps"

) else if exist "%directory_hf%" (
	dir /b /ad "C:\Program Files\Splunk\etc\apps"
	
) else (
	echo WARNING: No Splunk path found. ignore=1
)