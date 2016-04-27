# Torrents Container

This container hosts a basic Transmission torrent client.

The container exposes the Transmission web interface in order to allow the
user to administer torrents.

## Build

```
$ docker build -t usvr_torrents .
```

## Run

The most important thing is for the `downloads` and `incomplete` folders to be
mounted outside of the container (since this is where your torrents will
download to). You can keep the `incomplete` folder in the container if you wish
but remember to clean it up if it starts accumulating junk.

The second most important arguments are the ports to listen on and the webui
password you want to use to secure the web interface.

```
$ docker run -d \
        -p 9091:9091 \
        -p 51413:51413/udp -p 51413:51413/tcp \
        -e WEBUI_PASSWORD=<your password here> \
        -v $TRANSMISSION_DOWNLOADS_PATH:/t/downloads \
        --name usvr_t \
        usvr_torrents
```

Now you can access the webui by hitting the local ip on port 9091 and logging
in with `transmission` and the `WEBUI_PASSWORD` you set when you launched the
container.
