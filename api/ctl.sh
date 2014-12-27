#!/bin/bash

_sym=/mm
_service=mm-$(hostname).service 

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
	if [[ ! -d app ]]; then
		echo "missing symlink: ./app -> /path/to/metamind/server"
		graceful_exit "fix with $0 app /path/to/metamind/server"
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
	# Symlink Directory
	if [[ ! -d $_sym ]]; then
		echo "Creating Symlink"
		sudo ln -sv $(pwd) $_sym || graceful_exit "Failed to create symlink from $_sym to $(pwd)"
	fi

	sudo systemctl daemon-reload || graceful_exit "systemctl daemon-reload exited with error code $?"
	sudo systemctl enable $(pwd)/$_service || graceful_exit "systemctl enable $(pwd)/$service exited with error code $?"
	sudo systemctl start $_service || graceful_exit "sudo systemctl start $_service exited with error code $?"
}

app_sym () {
	ln -s $2 app || graceful_exit "Failed to create symlink from app to $2"
}

usage () {
	echo -e "\n  Usage $0 COMMAND [options]" \
		"\n\n\t setup <path>    create required symlink to nodejs code" \
		"\n\n\t Commands:" \
		"\n\t   on      enable and start $(hostname).service" \
		"\n\t   off     stop and disable $(hostname).service" \
		"\n\t   reload  stop, disable, daemon-reload, enable, and start $(hostname).service" \
		"\n\t   logs    show logs for $(hostname).service"
}

[[ -z $1 ]] && usage && exit 1

[[ "$1" == "setup" ]] && app_sym && exit 0

check_app
check_service

[[ "$1" == "off" ]] && off && exit 0
[[ "$1" == "on" ]] && on && exit 0
[[ "$1" == "reload" ]] && off && on && exit 0
[[ "$1" == "logs" ]] && logs && exit 0