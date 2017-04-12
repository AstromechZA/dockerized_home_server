FROM alpine:3.3
MAINTAINER astromechza

ENV     WEBUI_PASSWORD changeme
ENV     DOWNLOADER_USR torrentuser
ENV     DOWNLOADER_UID 1001

RUN     apk add --update python py-pip transmission-daemon iptables openvpn &&\
        rm -rf /var/cache/apk/*

RUN     pip install supervisor
RUN     mkdir /var/log/supervisor

# nordvpn
RUN     mkdir nordvpn
RUN     cd nordvpn && wget https://nordvpn.com/api/files/zip -O nord.zip && unzip nord.zip && rm -rfv nord.zip

RUN     mkdir -p /t/downloads &&\
        mkdir -p /t/incomplete &&\
        mkdir -p /etc/transmission-daemon

# configure
ADD     ./config-transmission /config-transmission
ADD     ./config/settings.json /etc/transmission-daemon/settings.json
ADD     ./config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD     ./scripts/torrent-finished.sh /torrent-finished.sh

VOLUME  /t/downloads
VOLUME  /t/incomplete
EXPOSE  9091 51413/tcp 51413/udp

CMD     ["sh", "-c", "/config-transmission && exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf"]
