# µServer Docker Containers

This docker setup contains 4 docker containers to be run on the host:

- ftp-share : A vsftp server for serving file share directories
- graphing : Carbon, Graphite, and Grafana for storing and displaying metrics.
- torrents : Transmission torrent client.

## All together now!

3. Build all containers

Run `./build_all.sh`

2. Add systemd config

Put the containers.supervisord.conf configuration in /etc/supervisord/conf.d and
then reload systemd to begin them.
