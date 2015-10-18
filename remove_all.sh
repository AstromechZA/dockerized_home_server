#!/bin/bash

echo "Removing Docker containers"

docker rm usvr_t
docker rm usvr_s
docker rm usvr_d
docker rm usvr_g

echo "done"
