FROM    alpine:3.3
MAINTAINER astromechza

RUN     apk add --update vsftpd python py-pip
RUN     pip install supervisor
ADD     ./supervisord.conf /etc/supervisord.conf

COPY    /configure   /configure
COPY    /vsftpd.conf /etc/vsftpd.conf

VOLUME  /fileshare

EXPOSE  21

CMD     ["sh", "-c", "/configure && exec /usr/bin/supervisord"]
