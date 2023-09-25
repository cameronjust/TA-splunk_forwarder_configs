@echo off

REM Perform Different Call if this is a HF or UF

set "directory_uf=C:\Program Files\SplunkUniversalForwarder\bin\"
set "directory_hf=C:\Program Files\Splunk\bin\"

if exist "%directory_uf%" (
	"C:\Program Files\SplunkUniversalForwarder\bin\splunk.exe" btool inputs list --debug | findstr /V "etc\system\default"
	
) else if exist "%directory_hf%" (
	"C:\Program Files\Splunk\bin\splunk.exe" btool inputs list --debug | findstr /V "etc\system\default"
	
) else (
	echo WARNING: No Splunk path found. ignore=1
)

