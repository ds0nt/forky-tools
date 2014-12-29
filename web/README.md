# Web Bundle Builder

The code here turns the front-end source code into a website. allows you to build and watch the web bundle.

##Configure

Open ../config.sh. Configure local path to [MetaMind](http://github.com/21cdawn/metamind), and destination folder for the bundled assets

```bash
 # absolute paths
 WEB_SRC=/path/of/21cdawn/metamind
 WEB_DEV=/dev/build/target/path
 WEB_RELEASE=/release/build/target/path
```

First you need to build the Dockerfile, producing a docker image.

```bash
 $ ./ctl.sh build
```

## Build

```bash
 $ ./ctl.sh build-dev
 $ ./ctl.sh build-release
```

## Build Continuously

```bash
 $ ./ctl.sh watch-dev
 $ ./ctl.sh watch-release
```

Note that watch can have some trouble triggering quickly over nfs mounts, such as a typical vagrant shared folder.