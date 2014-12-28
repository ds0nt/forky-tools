#!/bin/bash

_sym=/mm-web
_service=mm-web.service 
_d_image=mm-web

graceful_exit () {
	echo $@
	exit 1
}

check_service () {
	if [[ ! -f $_service ]]; then
		echo "missing file: $_service"
		graceful_exit "make a service file for this instance"
	fi
}

check_app () {
	if [[ ! -d web ]]; then
		echo "missing symlink: ./web -> /path/to/metamind/web"
		graceful_exit "make sure to run $0 setup"
	fi
}

# commands
logs () {
	sudo journalctl -f -n 35 -u $_service
}

off () {
	sudo systemctl stop $_service || graceful_exit "failed to stop $_service";
	sudo systemctl disable $_service || graceful_exit "failed to disable $_service";
}

on () {
	sudo systemctl daemon-reload || graceful_exit "systemctl daemon-reload exited with error code $?"
	sudo systemctl enable $(pwd)/$_service || graceful_exit "systemctl enable $(pwd)/$service exited with error code $?"
	sudo systemctl start $_service || graceful_exit "sudo systemctl start $_service exited with error code $?"
}

web_sym () {
	ln -s $1 web || graceful_exit "Failed to create symlink from web to $1"
}

global_sym () {
	# Symlink Directory
	if [[ ! -d $_sym ]]; then
		echo "Creating Symlink"
		sudo ln -sv $(pwd) $_sym || graceful_exit "Failed to create symlink from $_sym to $(pwd)"
	fi
}

build () {
	docker build --tag="$_d_image" ./
}

usage () {
	echo -e "\n  Usage $0 COMMAND [options]" \
		"\n" \
		"\n\t setup <path>   create required symlink to web code" \
		"\n\t build          build docker image with tag $_d_image" \
		"\n\t logs           show logs for $_service" \
		"\n" \
		"\n\t Service Commands:" \
		"\n\t   on      enable and start $_service" \
		"\n\t   off     stop and disable $_service" \
		"\n\t   reload  stop, disable, daemon-reload, enable, and start $_service"
}

[[ -z $1 ]] && usage && exit 1

[[ "$1" == "setup" ]] && web_sym $2 && exit 0
[[ "$1" == "build" ]] && build && exit 0

check_app
check_service
global_sym

[[ "$1" == "off" ]] && off && exit 0
[[ "$1" == "on" ]] && on && exit 0
[[ "$1" == "reload" ]] && off && on && exit 0
[[ "$1" == "logs" ]] && logs && exit 0