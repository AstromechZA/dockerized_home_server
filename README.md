# µServer Docker Containers

This docker setup contains 4 docker containers to be run on the host:

- samba : A Samba file share for serving a public and a private folder.
- torrents : Transmission torrent client.
- graphing : Carbon, Graphite, and Grafana for storing and displaying metrics.
- diamond : A Diamond installation for recording metrics about the host and the containers being run.

## All together now!

Use the scripts `build_all.sh`, `launch_all.sh`, `stop_all.sh`, and `remove_all.sh` to manage
the lifecycle and linking of the containers. These scripts should really be combined into
one and should use a config file to manage shared settings.

For configuration and settings see the variables at the top of `launch_all.sh`.
