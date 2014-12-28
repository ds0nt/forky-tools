#!/bin/bash

_global_sym=/nginx
_local_sym=www

_service=nginx-$(hostname).service 
_d_image=nginx

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
	if [[ ! -d $_local_sym ]]; then
		echo "missing symlink: ./$_local_sym -> /path/to/metamind/$_local_sym"
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

create_local_sym () {
	ln -s $1 $_local_sym || graceful_exit "Failed to create symlink from $_local_sym to $1"
}

create_global_sym () {
	# Symlink Directory
	if [[ ! -d $_global_sym ]]; then
		echo "Creating Symlink"
		sudo ln -sv $(pwd) $_global_sym || graceful_exit "Failed to create symlink from $_global_sym to $(pwd)"
	fi
}

build () {
	docker build --tag="$_d_image" ./
}

usage () {
	echo -e "\n  Usage $0 COMMAND [options]" \
		"\n" \
		"\n\t setup <path>   create required symlink to web assets" \
		"\n\t build          build docker image with tag $_d_image" \
		"\n\t logs           show logs for $_service" \
		"\n" \
		"\n\t Service Commands:" \
		"\n\t   on      enable and start $_service" \
		"\n\t   off     stop and disable $_service" \
		"\n\t   reload  stop, disable, daemon-reload, enable, and start $_service"
}

[[ -z $1 ]] && usage && exit 1

[[ "$1" == "setup" ]] && create_local_sym $2 && exit 0
[[ "$1" == "build" ]] && build && exit 0

check_app
check_service
create_global_sym

[[ "$1" == "off" ]] && off && exit 0
[[ "$1" == "on" ]] && on && exit 0
[[ "$1" == "reload" ]] && off && on && exit 0
[[ "$1" == "logs" ]] && logs && exit 0
