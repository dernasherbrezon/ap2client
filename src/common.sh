#!/bin/bash

function log() {
	printf "$1" | systemd-cat -t ap2client
}