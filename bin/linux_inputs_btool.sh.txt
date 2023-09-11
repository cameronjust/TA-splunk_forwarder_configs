#!/bin/bash

SPLUNK_HOME="/opt/splunkforwarder"
$SPLUNK_HOME/bin/splunk btool inputs list --debug | grep -v "etc/system/default"