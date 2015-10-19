#!/bin/bash

set -e

echo "Building Docker images"

if [ ! -d ./graphing -o ! -d ./samba -o ! -d ./torrents ]; then
    echo "Please execute from the correct directory"
    exit 1
fi

docker build -t usvr_graphing ./graphing
docker build -t usvr_diamond ./diamond
docker build -t usvr_samba ./samba
docker build -t usvr_torrents ./torrents
docker build -t usvr_lighttpd ./lighttpd

echo "done"
