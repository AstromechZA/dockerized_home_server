FROM jprjr/lighttpd
MAINTAINER astromechza

COPY    ./landing_page /srv/http
COPY    ./config-httpd /config-httpd

CMD     ["/config-httpd && exec lighttpd -D -f /etc/lighttpd/lighttpd.conf"]
