FROM alpine:3.3
MAINTAINER astromechza

ENV SMB_PUB_PATH /samba/public
ENV SMB_PUB_USR sambapublic
ENV SMB_PUB_PWD changeme

ENV SMB_PRV_PATH /samba/private
ENV SMB_PRV_USR sambaprivate
ENV SMB_PRV_PWD changeme

RUN     apk add --update samba samba-common-tools python py-pip &&\
        rm -rf /var/cache/apk/*

RUN     pip install supervisor

# configure
ADD     ./config-samba /config-samba
ADD     ./config/smb.conf /etc/samba/smb.conf
ADD     ./config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# create users
RUN     adduser -D -s /bin/false "$SMB_PUB_USR"
RUN     echo "$SMB_PUB_USR:$(echo $SMB_PUB_PWD | mkpasswd)" | chpasswd
RUN     adduser -D -s /bin/false "$SMB_PRV_USR"
RUN     echo "$SMB_PRV_USR:$(echo $SMB_PRV_PWD | mkpasswd)" | chpasswd
RUN     smbpasswd -an nobody

# create mount directories
RUN     mkdir -p $SMB_PUB_PATH &&\
        chown $SMB_PUB_USR:$SMB_PUB_USR $SMB_PUB_PATH &&\
        chmod 755 $SMB_PUB_PATH

RUN     mkdir -p $SMB_PRV_PATH &&\
        chown $SMB_PRV_USR:$SMB_PRV_USR $SMB_PRV_PATH &&\
        chmod 750 $SMB_PRV_PATH

# expose smbd and nmdb ports
EXPOSE  137/udp 138/udp 139 445

# define volumes
VOLUME  $SMB_PUB_PATH $SMB_PRV_PATH

CMD     ["sh", "-c", "/config-samba && exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf"]
