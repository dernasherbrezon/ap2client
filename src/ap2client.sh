#!/bin/bash

#entry point to ap2client

cd $(dirname "$0") 
. ./common.sh

function _term() {
	log "caught termination. stop child process"
	kill $(ps -s $$ -o pid=) 
}

trap _term SIGTERM

`pwd`/configMonitor.sh /etc/wpa_supplicant/wpa_supplicant.conf &
wpa_cli -i wlan0 -G 1 -a `pwd`/wpaCliMonitor.sh
