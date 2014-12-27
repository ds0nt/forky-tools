#!/bin/bash

_sym=/mm
_service=mm-$(hostname).service 

graceful_exit () {
	echo $@;
	exit 1;	
}

check_service () {
	if [[ ! -f $_service ]]; then
		echo "missing file: $_service";
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
	sudo systemctl stop $_service || exit 1;
	sudo systemctl disable $_service || exit 1;
}

on () {
	# Symlink Directory
	if [[ ! -d $_sym ]]; then
		echo "Creating Symlink"
		sudo ln -sv $(pwd) $_sym
	fi

	sudo systemctl daemon-reload
	sudo systemctl enable $(pwd)/$_service
	sudo systemctl start $_service
}

[[ "$1" == "app" ]] && ln -s $2 app 

check_app
check_service

[[ "$1" == "off" ]] && off
[[ "$1" == "on" ]] && on
[[ "$1" == "reload" ]] && off && on
[[ "$1" == "logs" ]] && logs