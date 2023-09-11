# Since the order of the btool can get lost due to _time being the same for all events you can force Splunk to return the exact order the events arrived with this search


index=main sourcetype="forwarder_config:inputs" conf_file_full=* | rex field=_cd "(?<bucket>\d+):(?<address>\d+)" | sort + _indextime address
| table conf* stanza setting setting_var setting_value


# It uses the hidden field _cd which contains the bucket_name and the location of the event inside the bucket. This can guarantee you get the same order of the btool output

You will see some weird bugs from btool in your logs like these just ignore them or make sure to include conf_file_full=* in your base search
host = $decideOnStartup
index = default

######## Search to merge configs on a per stanza basis ########
index=main sourcetype="forwarder_config:inputs" conf_file_full=* | rex field=_cd "(?<bucket>\d+):(?<address>\d+)" | sort 0 + host  _indextime address, stanza
| table conf* host stanza setting setting_var setting_value
| filldown stanza
| stats values(setting) as settings values(conf_app_name) as app by host, stanza
``` include below to only show enabled stanzas ```
| search settings="disabled*=*0" OR settings="disabled*=*true"


##### A bit more advanced search of apps to see common configs across deployment
index=main sourcetype="forwarder_config:inputs" conf_file_full=*  | rex field=_cd "(?<bucket>\d+):(?<address>\d+)" | sort 0 + host  _indextime address, stanza, app 

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

