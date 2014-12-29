# Web Bundle Builder

Build tools for metamind front-end. Manages a utility docker container for consistent and convinient building.

##Configure

Open ../config.sh. Configure local path to [MetaMind](http://github.com/21cdawn/metamind), and destination folder for the bundled assets

```bash
 # absolute paths
 WEB_SRC=/path/to/21cdawn/metamind
 WEB_DEV=/path/to/save/dev-bundle
 WEB_RELEASE=/path/to/save/release-bundle
```

## Build Utility Docker

```bash
 $ ./ctl.sh build
```

## Build

```bash
 $ ./ctl.sh bundle-dev
 $ ./ctl.sh bundle-release
```

## Build Continuously

```bash
 $ ./ctl.sh watch-dev
 $ ./ctl.sh watch-release
```

Note that watch can have some trouble triggering quickly over nfs mounts, such as a typical vagrant shared folder.