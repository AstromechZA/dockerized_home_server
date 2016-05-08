FROM    alpine:3.3
MAINTAINER astromechza

RUN     apk add --update vsftpd python py-pip
RUN     pip install supervisor
ADD     ./supervisord.conf /etc/supervisord.conf

COPY    /configure   /configure
COPY    /vsftpd.conf /etc/vsftpd.conf

VOLUME  /fileshare

# data port
EXPOSE  20
# command port
EXPOSE  21
# passive ftp ports
EXPOSE 21100 21101 21102 21103 21104 21105 21106 21107 21108 21109 21110

CMD     ["sh", "-c", "/configure && exec /usr/bin/supervisord"]
