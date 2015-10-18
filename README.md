# µServer Docker Containers

This docker setup contains 4 docker containers to be run on the host:

- samba : A Samba file share for serving a public and a private folder.
- torrents : Transmission torrent client.
- graphing : Carbon, Graphite, and Grafana for storing and displaying metrics.
- diamond : A Diamond installation for recording metrics about the host and the containers being run.

## Build all images

First step is to build and tag all the Docker images.

```
./build_all.sh
```

## Running 'Samba'

The samba container serves 2 directories: `/opt/samba/share/public` and `/opt/samba/share/private`.
The public folder is readable by guests and writeable by only the `sambapublic` user. The private
folder is not readable or browseable and is only accessibly by the `sambaprivate` user. Passwords
for both users must be set via `-e` environment variables when launching the container.

The public and private directories will be empty unless you mount folders under them using `-v`.

## Running 'Torrents'

The torrent container uses `/opt/torrents/downloads` for its completed downloads and `/opt/torrents/incomplete`
for partial downloads. You should mount a folder from the host on the `/opt/torrents/downloads` path using the `-v`
option so that your downloads persist. It also requires a password to be set for the web interface (port 9091) via
a `-e` environment variable.


## Running 'Graphing' and 'Diamond'

```
docker run --rm -p 80:80 -p 3000:3000 --name usvr_g usvr_graphing
docker run --rm --link usvr_g:usvr_g -v /proc:/host_proc -e GRAPHITE_HOST=@USVR_G_PORT_2003_TCP_ADDR -e GRAPHITE_PORT=@USVR_G_PORT_2003_TCP_PORT -e HOST_HOSTNAME=$(hostname) --name usvr_d usvr_diamond
```
