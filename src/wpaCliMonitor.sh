#!/bin/bash

cd $(dirname "$0") 
. ./common.sh

INTERFACE=${1}
MAX_RETRY=5
RETRY_TIMEOUT_SECONDS=15

function onConnected() { 
	log "wifi connected: `iwconfig ${INTERFACE} | grep ${INTERFACE}`"
	local IS_MASTER_MODE=`iwconfig ${INTERFACE} | grep "Mode:Master" | wc -l`
	if [ ${IS_MASTER_MODE} -eq 1 ]; then
		log "connected as access point"
		return 0
	fi	
	# ensure hostapd stopped
	# it won't be possible to connect in client mode
	# and remain access point
	systemctl stop hostapd
	systemctl stop dnsmasq

	dhclient ${INTERFACE}
	return 0
}

function onDisconnected() {
	log "wifi disconnected: `iwconfig ${INTERFACE} | grep ${INTERFACE}`"
	local connected=0
	# disconnected might be caused by auth failure
	# however there is no such event from wpa_cli, 
	# so retry even if connection definitely won't be established
	# currently responsiveness is MAX_RETRY * RETRY_TIMEOUT_SECONDS
	local retry=0
	until [ ${retry} -ge ${MAX_RETRY} ] || [ ${connected} -eq 1 ]
	do
		log "reconnect...attempt ${retry}"
		killall -HUP wpa_supplicant
		((retry++))
		sleep ${RETRY_TIMEOUT_SECONDS}
		connected=`iwconfig ${INTERFACE} | grep ESSID:\" | wc -l`
	done
	if [ ${connected} -eq 0 ]; then
		log "not reconnected within timeout. init access point mode"
		systemctl start dnsmasq
		systemctl start hostapd
		
		dhclient ${INTERFACE}
	fi
	return 0
}

case "${2}" in
    CONNECTED)
        onConnected
        ;;
    DISCONNECTED)
        onDisconnected
        ;;
esac