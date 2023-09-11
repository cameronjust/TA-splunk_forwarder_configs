@echo off

"C:\Program Files\SplunkUniversalForwarder\bin\splunk.exe" btool inputs list --debug | findstr /V "etc\system\default"

