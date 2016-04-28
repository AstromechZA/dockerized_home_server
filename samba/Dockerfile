FROM alpine:3.3
MAINTAINER astromechza

RUN     apk add --update samba samba-common-tools python py-pip &&\
        rm -rf /var/cache/apk/*
RUN     pip install supervisor

# default vars used by the config-samba script
ENV     SMB_PUB_SHARE publicdir
ENV     SMB_PUB_USR sambapublic
ENV     SMB_PUB_UID 1001
ENV     SMB_PRV_SHARE privatedir
ENV     SMB_PRV_USR sambaprivate
ENV     SMB_PRV_UID 1002

# configure
ADD     ./config-samba /config-samba
ADD     ./config/smb.conf /etc/samba/smb.conf
ADD     ./config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# setup root paths
RUN     mkdir -p /samba/public
RUN     mkdir -p /samba/private

# expose smbd and nmdb ports
EXPOSE  137/udp 138/udp 139 445

# define volumes
VOLUME  /samba/public /samba/private

CMD     ["sh", "-c", "/config-samba && exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf"]
