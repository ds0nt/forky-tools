#!/bin/bash

# generated with ./scriptify.sh by "core"

echo 'Starting Docker';

docker run -d -t \
	--env-file=prod.env \
	-p 80:8080 --name=mm-prod mm