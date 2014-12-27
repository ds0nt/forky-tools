#!/bin/bash

_sym=/nginx
_service=nginx.service

[[ "$(hostname)" == "tier-01" ]] && ./build && _service=nginx-tier-01.service

# commands
if [[ "$1" == "logs" ]]; then	
	sudo journalctl -f -n 35 -u $_service
	exit 0;
fi;

_off=false
_on=false

[[ "$1" == "off" ]] && _on=false && _off=true
[[ "$1" == "on" ]] && _on=true && _off=false
[[ "$1" == "reload" ]] && _on=true && _off=true

if $_off; then
	sudo systemctl stop $_service || exit 1;
	sudo systemctl disable $_service || exit 1;
fi;

if $_on; then
	
	# Symlink Directory
	if [[ ! -d $_sym ]]; then
		echo "Creating Symlink"
		sudo ln -sv $(pwd) $_sym
	fi

	sudo systemctl daemon-reload;
	sudo systemctl enable $(pwd)/$_service || exit 1;
	sudo systemctl start $_service || exit 1;
	echo "Run $0 logs to see logs"
fi
