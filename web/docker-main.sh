#!/bin/bash
# Runs inside these dockers

if [[ "$MM_ENV" == "release" ]]; then
	release=--release
fi

cd /src

npm install || exit $?;

gulp build $release --dest=/tmp/dist --verbose=true || exit $?;

mv /tmp/dist/* /dist

# if [[ -z $tar ]]; then
# 	cd /tmp/dist && tar -c * > ~/dist/$(date +%s).tar
# else
# fi