#!/bin/bash

source ../config.sh


usage () {
	echo -e "\n  Usage $0 COMMAND [options]" \
		"\n" \
		"\n\t build            build dockerfile" \
		"\n\t bundle-dev       bundle files for development" \
		"\n\t bundle-release   bundle files for release" \
		"\n\t logs      show logs for $_service" 
}

# Usage
[[ -z $1 ]] && usage && exit 1



# Scripting Goodies

graceful_exit () {
	echo $@
	exit 1
}


# Check over things...

if [[ ! -d $WEB_SRC ]]; then
	echo "missing symlink -> metamind/"
	graceful_exit "make sure to run $0 setup"
fi

echo "Using $WEB_SRC"



# Commands
build () {
	docker build --tag="webpack" .
}

bundle_dev () {
	docker run -it \
		-e MM_ENV=dev \
		-v $WEB_SRC:/src \
		-v $WEB_DEV:/dist \
		webpack
}

bundle_release () {
	docker run -it \
		-e MM_ENV=release \
		-v $WEB_SRC:/src \
		-v $WEB_RELEASE:/dist \
		webpack
}

[[ "$1" == "build" ]] && build
[[ "$1" == "bundle-dev" ]] && bundle_dev
[[ "$1" == "bundle-release" ]] && bundle_release