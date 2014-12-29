#!/bin/bash

source ../config.sh

_service=nginx-$(hostname).service 
_image=nginx

graceful_exit () {
	echo $@
	exit 1
}

# Symlink Directory
sym='/nginx'
if ! [ -d "$sym" ]; then
	echo "Creating Symlink"
	sudo ln -sv $(pwd) $sym || graceful_exit "Failed to create symlink from $sym to $(pwd)"
fi

if [[ ! -f $_service ]]; then
	echo "missing file: $_service"
	graceful_exit "make a service file for this instance"
fi


check_app () {
	if [[ ! -d www ]]; then
		echo "missing symlink: ./www -> /path/to/metamind/www"
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


build () {
	docker build --tag="$_image" ./
}

set_env () {
	rm www
	if [[ "$1" == "release" ]]; then
		ln -sv $WEB_RELEASE www
	else
		ln -sv $WEB_DEV www		
	fi
}

usage () {
	echo -e "\n  Usage $0 COMMAND [options]" \
		"\n" \
		"\n\t set-env        serve release or dev bundle" \
		"\n\t build          build docker image with tag $_image" \
		"\n\t logs           show logs for $_service" \
		"\n" \
		"\n\t Service Commands:" \
		"\n\t   on      enable and start $_service" \
		"\n\t   off     stop and disable $_service" \
		"\n\t   reload  stop, disable, daemon-reload, enable, and start $_service"
}

[[ -z $1 ]] && usage && exit 1

[[ "$1" == "set-env" ]] && set_env $2 && exit 0
[[ "$1" == "build" ]] && build && exit 0
[[ "$1" == "off" ]] && off && exit 0
[[ "$1" == "logs" ]] && logs && exit 0

check_app

[[ "$1" == "on" ]] && on && exit 0
[[ "$1" == "reload" ]] && off && on && exit 0
