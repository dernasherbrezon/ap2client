#!/bin/bash

WPA_SUPPLICANT_CONFIG=$1
WIFI_INTERFACE=wlan0

function log() {
	printf $1 | systemd-cat -t ap2client
}

function onConfigurationChanged() {
	echo "config changed"
	local HAS_NETWORK_CONFIG=`grep network ${WPA_SUPPLICANT_CONFIG} | wc -l`
	local IS_ACCESS_POINT_MODE=`iwconfig ${WIFI_INTERFACE} | grep "Access Point:Master" | wc -l`
	if [ ${HAS_NETWORK_CONFIG} -eq 0 ] && [ ${IS_ACCESS_POINT_MODE} -eq 1 ]; then
		echo "test"
	fi
	local IS_CLIENT_MODE=`iwconfig ${WIFI_INTERFACE} | grep "Access Point:Master" | wc -l`
	local IS_UNASSIGNED=`iwconfig ${WIFI_INTERFACE} | grep "TODO" | wc -l`
}

fswatch -0 ${WPA_SUPPLICANT_CONFIG} | 
while read -d "" event; do
	onConfigurationChanged
done



