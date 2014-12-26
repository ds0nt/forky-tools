#!/bin/bash

# generated with ./scriptify.sh by "core"

echo 'Starting Docker';

docker run -d -t \
	--env-file=prod.env \
	-p 80:3000 --name=mm-prod mm