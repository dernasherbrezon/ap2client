#!/bin/bash

#entry point to ap2client

cd $(dirname "$0") 
. ./common.sh

# TODO shutdown child script during service restart
`pwd`/configMonitor.sh /etc/wpa_supplicant/wpa_supplicant.conf &
wpa_cli -i wlan0 -G 1 -a `pwd`/wpaCliMonitor.sh
