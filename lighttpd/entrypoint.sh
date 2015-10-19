#!/bin/sh

set -ex

if [ "x$SELF_ADDRESS" == "x" ]; then echo "Need to set SELF_ADDRESS to ip address or hostname"; exit 1; fi

sed -i "s/localhost/$SELF_ADDRESS/g" /srv/http/index.html

lighttpd -D -f /etc/lighttpd/lighttpd.conf
