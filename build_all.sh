#!/usr/bin/env bash

set -exu

docker build -t usvr_ftp ftp-share
docker build -t usvr_graphing graphing
docker build -t usvr_torrents torrents
