#!/bin/bash

workingdir="./bash_unit"
scriptLocation=../src/ap2client.sh

_not_assotiated_wifi() {
	printf "wlan0     IEEE 802.11  ESSID:off/any\n"
	printf "          Mode:Managed  Access Point: Not-Associated   Tx-Power=31 dBm\n"
	printf "          Retry short limit:7   RTS thr:off   Fragment thr:off\n"
	printf "          Power Management:on\n"
	return 0
}

_connected_to_wifi() {
	printf "wlan0     IEEE 802.11  ESSID:\"HOMENET\"\n"
	printf "          Mode:Managed  Frequency:5.18 GHz  Access Point: 90:72:40:1D:70:6D\n"
	printf "          Bit Rate=78 Mb/s   Tx-Power=31 dBm\n"
	printf "          Retry short limit:7   RTS thr:off   Fragment thr:off\n"
	printf "          Power Management:on\n"
	printf "          Link Quality=70/70  Signal level=-40 dBm\n"
	printf "          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0\n"
	printf "          Tx excessive retries:0  Invalid misc:0   Missed beacon:0\n"
	return 0
}

_access_point() {
	printf "wlan0     IEEE 802.11  Mode:Master  Tx-Power=31 dBm\n"
	printf "          Retry short limit:7   RTS thr:off   Fragment thr:off\n"
	printf "          Power Management:on\n"
	return 0
}

test_success() {
	echo "success"
}
