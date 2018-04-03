#!/bin/bash

cd $(dirname "$0") 
. ./common.sh

INTERFACE=${1}
MAX_RETRY=5
RETRY_TIMEOUT_SECONDS=15
CONNECTED=0

function onConnected() { 
	log "wifi connected"
	CONNECTED=1
	local IS_MASTER_MODE=`iwconfig ${INTERFACE} | grep "Mode:Master" | wc -l`
	if [ ${IS_MASTER_MODE} -eq 1 ]; then
		log "connected as access point"
		return 0
	fi	
	dhclient ${INTERFACE}
	# ensure hostapd stopped
	# it won't be possible to connect in client mode
	# and remain access point
	systemctl stop hostapd
	return 0
}

function onDisconnected() {
	log "wifi disconnected"
	CONNECTED=0
	# disconnected might be caused by auth failure
	# however there is no such event from wpa_cli, 
	# so retry even if connection definitely won't be established
	# currently responsiveness is MAX_RETRY * RETRY_TIMEOUT_SECONDS
	local retry=0
	until [ ${retry} -ge ${MAX_RETRY} ] || [ ${CONNECTED} -eq 1 ]
	do
		log "reconnect...attempt ${retry}"
		killall -HUP wpa_supplicant
		((retry++))
		sleep ${RETRY_TIMEOUT_SECONDS}
	done
	if [ ${CONNECTED} -eq 0 ]; then
		log "not reconnected within timeout. init access point mode"
		systemctl start hostapd
	fi
	return 0
}

case "$2" in
    CONNECTED)
        onConnected
        ;;
    DISCONNECTED)
        onDisconnected
        ;;
esac