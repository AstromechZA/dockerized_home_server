FROM jprjr/lighttpd
MAINTAINER astromechza

COPY    ./landing_page /srv/http
COPY    ./entrypoint.sh /entrypoint.sh

ENTRYPOINT  ["/entrypoint.sh"]
