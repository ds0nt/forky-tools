#!/bin/bash

# generated with ./scriptify.sh by "core"

echo 'Starting Docker';

docker run -d -t \
	--env-file=dev.env \
	-p 80:3000 --name=mm-dev mm