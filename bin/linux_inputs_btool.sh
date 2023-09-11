#!/bin/bash

# Allows this to work on a Indexer/HF/UF. 
# If you can work out how to access SPLUNK_HOME this will be simpler

if [ -d "/opt/splunkforwarder" ]; then
    SPLUNK_HOME="/opt/splunkforwarder"

elif [ -d "/opt/splunk" ]; then
    SPLUNK_HOME="/opt/splunk"
	
else
    echo "WARNING: Splunk directory not detected. ignore=1"
	exit 1
fi

$SPLUNK_HOME/bin/splunk btool inputs list --debug | grep -v "etc/system/default"
