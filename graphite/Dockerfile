FROM alpine:3.3

ENV     GRAPHITE_VERSION 0.9.15
ENV     GRAFANA_VERSION v2.6.0
ENV     GOPATH /go

# install apks
RUN     apk add --update \
        python python-dev py-pip libffi-dev \
        sqlite nginx curl \
        build-base go nodejs git mercurial py-cairo-dev

# install python packages
RUN     pip install supervisor \
                cairocffi \
                Django==1.4 \
                django-tagging==0.3.1 \
                gunicorn \
                pytz

# Checkout the stable branches of Graphite, Carbon and Whisper and install from there
RUN     pip install "whisper==${GRAPHITE_VERSION}" \
                    "carbon==${GRAPHITE_VERSION}" \
                    "graphite-web==${GRAPHITE_VERSION}"

ENV     GRAPHITE_ROOT /opt/graphite
ENV     PYTHONPATH "$GRAPHITE_ROOT/lib:$GRAPHITE_ROOT/webapp"

# copy in dependency map
ADD     package.json /tmp/package.json

# do build
RUN     mkdir -p /go/src/github.com/grafana && cd /go/src/github.com/grafana && \
        git clone https://github.com/grafana/grafana.git -b ${GRAFANA_VERSION} && \
        cd grafana && \
        cp /tmp/package.json /go/src/github.com/grafana/grafana/package.json && \
        go run build.go setup && \
        /go/bin/godep restore && \
        go run build.go build && \
        npm install && \
        npm install -g grunt-cli && \
        grunt && \
        npm uninstall -g grunt-cli && \
        npm cache clear

# do setup/install
RUN     mkdir -p /usr/share/grafana/bin &&\
        cd /go/src/github.com/grafana/grafana &&\
        cp -a ./bin/grafana-server /usr/share/grafana/bin/grafana-server && \
        cp -ra ./public_gen /usr/share/grafana && \
        mv /usr/share/grafana/public_gen /usr/share/grafana/public && \
        cp -ra ./conf /usr/share/grafana && \
        apk del --purge build-base nodejs go git mercurial && \
        rm -rf /go /tmp/* /var/cache/apk/* /root/.n*

# remove defaults
RUN     mkdir /opt/graphite/conf/examples && mv -v /opt/graphite/conf/*.example /opt/graphite/conf/examples

# add in only the needed files
RUN     cp /opt/graphite/conf/examples/graphite.wsgi.example /opt/graphite/webapp/graphite/wsgi.py
ADD     ./conf/graphite/storage-schemas.conf /opt/graphite/conf/storage-schemas.conf
ADD     ./conf/graphite/storage-aggregation.conf /opt/graphite/conf/storage-aggregation.conf
ADD     ./conf/graphite/carbon.conf /opt/graphite/conf/carbon.conf

# copy over some config
ADD     ./conf/graphite/local_settings.py /opt/graphite/webapp/graphite/local_settings.py

# copy over nginx and uwsgi configs
RUN     mkdir -p /etc/nginx/sites-available && mkdir -p /etc/nginx/sites-enabled
ADD     ./conf/nginx/nginx_site_graphite.conf /etc/nginx/sites-available/nginx_site_graphite

# enable the sites
RUN     ln -s /etc/nginx/sites-available/nginx_site_graphite  /etc/nginx/sites-enabled/nginx_site_graphite
RUN     mkdir -p /var/log/graphite-web && mkdir -p /var/log/supervisor

RUN     adduser -DH grafana
ADD     ./conf/grafana/grafana.ini /etc/grafana/grafana.ini
RUN     mkdir -p /var/log/grafana /var/lib/grafana && chown grafana:grafana /var/log/grafana /var/lib/grafana
RUN     touch /var/run/grafana-server.pid && chown grafana:grafana /var/run/grafana-server.pid
RUN     chown -R grafana:grafana /usr/share/grafana

# add supervisord config
ADD     ./conf/supervisord.conf /etc/supervisord.conf
ADD     ./conf/nginx/nginx.conf /etc/nginx/nginx.conf

ADD     ./bootstrap-graphite /bootstrap-graphite

# default command
CMD     /bootstrap-graphite && /usr/bin/supervisord
