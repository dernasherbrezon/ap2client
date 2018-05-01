#!/bin/bash

WPA_SUPPLICANT_CONFIG=$1

cd $(dirname "$0") 
. ./common.sh

function onConfigurationChanged() {
	local HAS_NETWORK_CONFIG=`grep network ${WPA_SUPPLICANT_CONFIG} | wc -l`
	if [ ${HAS_NETWORK_CONFIG} -eq 0 ]; then
		log "no network configuration provided to connect to. init access point mode"
		systemctl start dnsmasq
		systemctl start hostapd
	else
		log "network configuration provided. init client mode"
		systemctl stop hostapd
		systemctl stop dnsmasq
	fi
	# reload wpa_supplicant configuration from ${WPA_SUPPLICANT_CONFIG}
	killall -HUP wpa_supplicant
}

# check configuration file on startup
onConfigurationChanged

inotifywait -m -r -e modify ${WPA_SUPPLICANT_CONFIG} |
while read output; do
	onConfigurationChanged
done
