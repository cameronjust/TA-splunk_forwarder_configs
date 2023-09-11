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

# Use a for loop to list directory names
targetDirectory="$SPLUNK_HOME/etc/apps"
for directory in "$targetDirectory"/*; do
    if [ -d "$directory" ]; then
        echo "$(basename "$directory")"
    fi
done