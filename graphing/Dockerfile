FROM debian:latest

ENV     GRAPHITE_VERSION 0.9.15
ENV     GRAFANA_VERSION 3.0.4-1464167696
ENV     GRAPHITE_ROOT /opt/graphite
ENV     PYTHONPATH "$GRAPHITE_ROOT/lib:$GRAPHITE_ROOT/webapp"

# === PACKAGES =================================================================
# install packages
RUN     apt-get update && apt-get install -y \
        python-dev python-cairo python-pip \
        nginx sqlite3 libfontconfig curl git adduser  wget

# install python packages
RUN     pip install supervisor \
                Django==1.5 \
                django-tagging==0.3.6 \
                gunicorn \
                pytz

# Checkout the stable branches of Graphite, Carbon and Whisper and install from there
RUN     pip install "whisper==${GRAPHITE_VERSION}" \
                    "carbon==${GRAPHITE_VERSION}" \
                    "graphite-web==${GRAPHITE_VERSION}"

# === GRAFANA ==================================================================
RUN     wget "https://grafanarel.s3.amazonaws.com/builds/grafana_${GRAFANA_VERSION}_amd64.deb" -O grafana.deb &&\
            dpkg -i grafana.deb &&\
            rm -v grafana.deb
RUN     mkdir -p /var/log/grafana /var/lib/grafana
RUN     touch /var/run/grafana-server.pid && chown grafana:grafana /var/run/grafana-server.pid
ADD     ./conf/grafana/grafana.ini /etc/grafana/grafana.ini

# === GRAPHITE =================================================================
RUN     mkdir /opt/graphite/conf/examples &&\
        mv -v /opt/graphite/conf/*.example /opt/graphite/conf/examples
RUN     mv /opt/graphite/conf/examples/graphite.wsgi.example /opt/graphite/webapp/graphite/wsgi.py
ADD     ./conf/graphite/storage-schemas.conf /opt/graphite/conf/storage-schemas.conf
ADD     ./conf/graphite/storage-aggregation.conf /opt/graphite/conf/storage-aggregation.conf
ADD     ./conf/graphite/carbon.conf /opt/graphite/conf/carbon.conf
ADD     ./conf/graphite/local_settings.py /opt/graphite/webapp/graphite/local_settings.py

# === NGINX / UWSGI for GRAPHITE ===============================================
RUN     mkdir -p /etc/nginx/sites-available &&\
        mkdir -p /etc/nginx/sites-enabled
RUN     rm -rfv /etc/nginx/sites-enabled/*
ADD     ./conf/nginx/nginx_site_graphite.conf /etc/nginx/sites-available/nginx_site_graphite
RUN     ln -s /etc/nginx/sites-available/nginx_site_graphite  /etc/nginx/sites-enabled/nginx_site_graphite
ADD     ./conf/nginx/nginx.conf /etc/nginx/nginx.conf

# === SUPERVISORD ==============================================================
ADD     ./conf/supervisord.conf /etc/supervisord.conf
RUN     mkdir -p /var/log/graphite-web && mkdir -p /var/log/supervisor

ADD     ./bootstrap /bootstrap

# === CLEANUP ==================================================================
RUN     apt-get clean &&\
        rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# === PORTS ====================================================================
# graphite web port
EXPOSE  80
# carbon tcp port
EXPOSE 2003
# grafana port
EXPOSE 3000

# === VOLUMES ==================================================================
# grafana database directory
VOLUME /var/lib/grafana
# grafana config directory
VOLUME /etc/grafana
# carbon storage
VOLUME /opt/graphite/storage
# graphite settings
VOLUME /opt/graphite/conf

# === ENTRYPOINT ===============================================================
# default command
CMD     /bootstrap && exec /usr/local/bin/supervisord
