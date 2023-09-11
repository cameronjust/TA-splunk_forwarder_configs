#!/bin/bash

SPLUNK_HOME="/opt/splunkforwarder"
targetDirectory="$SPLUNK_HOME/etc/apps"


# Use a for loop to list directory names
for directory in "$targetDirectory"/*; do
    if [ -d "$directory" ]; then
        echo "$(basename "$directory")"
    fi
done