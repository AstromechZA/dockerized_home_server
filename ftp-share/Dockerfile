FROM    alpine:3.3
MAINTAINER astromechza

RUN     apk add --update vsftpd

COPY    /configure   /configure
COPY    /vsftpd.conf /etc/vsftpd.conf

VOLUME  /fileshare

# data ports and passive ftp ports
EXPOSE  20 21 21100 21101 21102 21103 21104 21105 21106 21107 21108 21109 21110

CMD ["vsftpd", "/etc/vsftpd.conf"]
