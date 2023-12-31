
# ###################################
# TA-splunk_forwarder_configs Splunk addon

## About
This addon runs two scripted inputs to collect a inputs btool and a listing of all directories in SPLUNK_HOME/etc/apps. It works on both windows and linux.

* Author: Cameron Just
* Version: 1.1.1
* Splunkbase URL: n/a
* Source type(s): forwarder_config:inputs, forwarder_config:apps
* Has index-time operations: Yes
* Has search-time extractions: Yes
* Input requirements: None
* Supported product(s): Search Heads, Indexers and Heavy Forwarders

## IMPORTANT
This addon must also be on the indexers and/or aggregate HFs as it contains index time operations. If you forget the data will all come in as multiple lines instead of one line per event.

Also don't forget to change the forwarder_config_data_index macro which points to the index you want to send this data to or all your dashboards won't work.

## Search Examples

### Basic Config Output

Since the order of the btool can get lost due to _time being the same for all events you can force Splunk to return the exact order the events arrived with this search

```
index=main sourcetype="forwarder_config:inputs" conf_file_full=* 
| rex field=_cd "(?<bucket>\d+):(?<address>\d+)" 
| sort + _indextime address 
| table conf* stanza setting setting_var setting_value
```

The above uses the hidden field _cd which contains the bucket_name and the location of the event inside the bucket. This can guarantee you get the same order of the btool output

You will see some weird bugs from btool in your logs like these just ignore them or make sure to include `conf_file_full=*` in your base search
```
host = $decideOnStartup
index = default
```

### Search to merge configs on a per stanza basis


```
index=main sourcetype="forwarder_config:inputs" conf_file_full=* 
| rex field=_cd "(?<bucket>\d+):(?<address>\d+)" 
| sort 0 + host  _indextime address, stanza
| table conf* host stanza setting setting_var setting_value
| filldown stanza
| stats values(setting) as settings values(conf_app_name) as app by host, stanza

``` include below to only show enabled stanzas ```
| search settings="disabled*=*0" OR settings="disabled*=*true"
```


### Advanced Deployment Wide Configs

A bit more advanced search of apps to see common configs across deployment
```
index=main sourcetype="forwarder_config:inputs" conf_file_full=*
| rex field=_cd "(?<bucket>\d+):(?<address>\d+)"
| sort 0 + host  _indextime address, stanza, app 

``` exclude host from system local as it will break the md5 calc at the end of this search ```
| search (conf_type!="system" AND setting_var!="host") OR stanza=*

| table conf* host stanza setting setting_var setting_value
| filldown stanza
| stats values(setting) as settings values(conf_app_name) as app by host, stanza

``` include below to only show enabled stanzas ```
| search settings="disabled*=*0" OR settings="disabled*=*false"

``` Add an md5 of the settings so you can see common apps on fwders ```
| eval md5sum = md5(mvjoin(settings,""))
| eval full_settings = mvjoin(settings,"
")
| stats dc(host) values(host) first(full_settings) by app, stanza, md5sum
```

## Changelog

* 1.0.0 - Initial creation
* 1.1.0 - Expanding monitoring to HFs
* 1.1.1 - Added some dashboarding which can be seen by making app visible.