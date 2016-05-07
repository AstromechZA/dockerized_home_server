FROM    alpine:3.3
MAINTAINER astromechza

RUN     apk add --update vsftpd python py-pip
RUN     pip install supervisor

ADD     ./supervisord.conf /etc/supervisord.conf

RUN     adduser -D publicuser
RUN     echo "publicuser:changeme" | chpasswd

RUN     mkdir -p /var/run/vsftpd/empty
RUN     mkdir -p /var/lib/ftp/public

COPY    /vsftpd.conf /etc/vsftpd.conf

RUN     chown -R publicuser /var/lib/ftp

VOLUME  /var/lib/ftp
WORKDIR /var/lib/ftp

EXPOSE  21

CMD     exec /usr/bin/supervisord
