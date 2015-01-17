# Nginx Reverse-Proxy

Tools for metamind's gateway instance. Manages a utility docker container that routes different requests to the appropriate servers.

Currently it is configured to

 - Serve Static Content
 - Route Websockets
 - Route HTTP Requests

## Build Utility Docker

```bash
 $ ./ctl.sh build
```

## Set Environment

```bash
 $ ./ctl.sh set-env dev
 $ ./ctl.sh set-env release
```

## Enable the systemctl service

```bash
 $ ./ctl.sh on
 $ ./ctl.sh off

 # same as on then off
 $ ./ctl.sh reload 

 # check the logs
 $ ./ctl.sh logs
```

Make sure the port forwarding lines up, run ``docker ps`` to check on docker's port