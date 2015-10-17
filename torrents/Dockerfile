FROM ubuntu:14.04.1
MAINTAINER astromechza

ENV TORRENT_DOWNLOADS /opt/torrents/downloads
ENV TORRENT_INCOMPLETE /opt/torrents/incomplete

RUN     apt-get update &&\
        apt-get install -y supervisor software-properties-common
RUN     add-apt-repository -y ppa:transmissionbt/ppa
RUN     apt-get update &&\
        apt-get install -y transmission-cli transmission-common transmission-daemon

RUN     mkdir -p /home/debian-transmission &&\
        chown -R debian-transmission: /home/debian-transmission

# configure
ADD     ./config/settings.json /etc/transmission/settings.json
ADD     ./config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN     mkdir -p $TORRENT_DOWNLOADS &&\
        chown -R debian-transmission: $TORRENT_DOWNLOADS
RUN     mkdir -p $TORRENT_INCOMPLETE &&\
        chown -R debian-transmission: $TORRENT_INCOMPLETE
RUN     chown -R debian-transmission: /etc/transmission

EXPOSE  9091

VOLUME  $TORRENT_DOWNLOADS $TORRENT_INCOMPLETE

CMD     ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
