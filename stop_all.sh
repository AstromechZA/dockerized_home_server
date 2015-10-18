#!/bin/bash

echo "Stopping Docker containers"

docker stop usvr_t
docker stop usvr_s
docker stop usvr_d
docker stop usvr_g

echo "done"
