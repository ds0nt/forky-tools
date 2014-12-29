#!/bin/bash
# Runs inside these dockers

if [[ "$MM_ENV" == "release" ]]; then
	release=--release
fi

if [[ "$MM_WATCH" == "true" ]]; then
	buildcmd=watch
else
	buildcmd=build
fi

cd /src

# npm install || exit $?;

gulp $buildcmd $release --dest=/tmp/dist --verbose=true || exit $?;

rm -rf /dist/*
mv /tmp/dist/* /dist

# if [[ -z $tar ]]; then
# 	cd /tmp/dist && tar -c * > ~/dist/$(date +%s).tar
# else
# fi