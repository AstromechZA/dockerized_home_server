#!/bin/bash

set -e

# Passwords for access
SAMBA_PUBLIC_PASSWORD=test
SAMBA_PRIVATE_PASSWORD=test
TRANSMISSION_PASSWORD=test

# Persistent directories
SAMBA_PUBLIC_PATH=/tmp/spublic
SAMBA_PRIVATE_PATH=/tmp/sprivate
TRANSMISSION_DOWNLOADS_PATH=/tmp/spublic/torrents
GRAPHITE_STORAGE=/tmp/whispers

# Web ports
GRAFANA_PORT=3000
TRANSMISSION_PORT=9091

echo "launching containers"

docker run -d \
        -p $GRAFANA_PORT:3000 \
        -v $GRAPHITE_STORAGE:/opt/graphite/storage/whisper \
        --name usvr_g \
        usvr_graphing

docker run -d \
        --link usvr_g:usvr_g \
        -v /proc:/host_proc \
        -e GRAPHITE_HOST=@USVR_G_PORT_2003_TCP_ADDR \
        -e GRAPHITE_PORT=@USVR_G_PORT_2003_TCP_PORT \
        -e HOST_HOSTNAME=$(hostname) \
        --name usvr_d \
        usvr_diamond

docker run -d \
        -p 137:137/udp \
        -p 138:138/udp \
        -p 139:139 \
        -p 445:445 \
        -e SMB_PUB_PWD=$SAMBA_PUBLIC_PASSWORD \
        -e SMB_PRV_PWD=$SAMBA_PRIVATE_PASSWORD \
        -v $SAMBA_PUBLIC_PATH:/samba_public \
        -v $SAMBA_PRIVATE_PATH:/samba_private \
        --name usvr_s \
        usvr_samba

docker run -d \
        -p $TRANSMISSION_PORT:9091 \
        -e WEBUI_PASSWORD=$TRANSMISSION_PASSWORD \
        -v $TRANSMISSION_DOWNLOADS_PATH:/torrent_downloads \
        --name usvr_t \
        usvr_torrents

echo "done"
