FROM ubuntu:14.04.1
MAINTAINER astromechza

# update repos and install packages
RUN     apt-get update &&\
        apt-get install -y python-cairo python-dev git wget curl python-pip &&\
        apt-get install -y nginx uwsgi uwsgi-plugin-python sqlite3 &&\
        apt-get install -y supervisor adduser libfontconfig
RUN     pip install pytz pyparsing Twisted==11.1.0 Django==1.5 django-tagging==0.3.6

# disable default site
RUN     rm /etc/nginx/sites-enabled/default

# make temp dir
RUN     mkdir /src

# Checkout the stable branches of Graphite, Carbon and Whisper and install from there
RUN     git clone https://github.com/graphite-project/whisper.git /src/whisper &&\
        cd /src/whisper &&\
        git checkout 0.9.x &&\
        python setup.py install

RUN     git clone https://github.com/graphite-project/carbon.git /src/carbon &&\
        cd /src/carbon &&\
        git checkout 0.9.x &&\
        python setup.py install

RUN     git clone https://github.com/graphite-project/graphite-web.git /src/graphite-web &&\
        cd /src/graphite-web &&\
        git checkout 0.9.x &&\
        python setup.py install

# install grafana
RUN     wget https://grafanarel.s3.amazonaws.com/builds/grafana_2.1.3_amd64.deb && dpkg -i grafana_2.1.3_amd64.deb
RUN     mkdir -p /var/log/grafana /var/lib/grafana && chown grafana:grafana /var/log/grafana /var/lib/grafana
RUN     touch /var/run/grafana-server.pid && chown grafana:grafana /var/run/grafana-server.pid
ADD     ./config/grafana/grafana.ini /etc/grafana/grafana.ini

# remote defaults
RUN     mkdir /opt/graphite/conf/examples && mv /opt/graphite/conf/*.example /opt/graphite/conf/examples

# add in only the needed files
RUN     cp /opt/graphite/conf/examples/graphite.wsgi.example /opt/graphite/conf/wsgi.py
ADD     ./config/graphite/storage-schemas.conf /opt/graphite/conf/storage-schemas.conf
ADD     ./config/graphite/storage-aggregation.conf /opt/graphite/conf/storage-aggregation.conf
ADD     ./config/graphite/carbon.conf /opt/graphite/conf/carbon.conf

# copy over some config
ADD     ./config/graphite/local_settings.py /opt/graphite/webapp/graphite/local_settings.py
ADD     ./config/graphite/initial_data.json /opt/graphite/webapp/graphite/initial_data.json

# init django admin user and database
RUN     cd /opt/graphite/webapp/graphite && python manage.py syncdb --noinput
# make sure www-data owns its own storage
RUN     chown -R www-data:www-data /opt/graphite/webapp/ /opt/graphite/storage/

# copy over nginx and uwsgi configs
ADD     ./config/nginx/nginx_site_graphite.conf /etc/nginx/sites-available/nginx_site_graphite
ADD     ./config/graphite_uwsgi.ini /etc/uwsgi/apps-available/graphite_uwsgi.ini

# enable the sites
RUN     ln -s /etc/nginx/sites-available/nginx_site_graphite  /etc/nginx/sites-enabled/nginx_site_graphite
RUN     ln -s /etc/uwsgi/apps-available/graphite_uwsgi.ini /etc/uwsgi/apps-enabled/graphite_uwsgi.ini
RUN     mkdir -p /var/log/graphite-web

# add supervisord config
ADD     ./config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD     ./config/nginx/nginx.conf /etc/nginx/nginx.conf

# time for hacks! need to inject the graphite data source into the grafana database
RUN     chown -R grafana:grafana /usr/share/grafana
USER    grafana
RUN     cd /usr/share/grafana; /usr/sbin/grafana-server --config=/etc/grafana/grafana.ini --pidfile=/var/run/grafana-server.pid 2>&1 >/dev/null & WPID=$!; sleep 5 && kill $WPID; wait $WPID; exit 0
ADD     ./config/grafana/default_data_source.sql /tmp/default_data_source.sql
RUN     sqlite3 /usr/share/grafana/data/grafana.db < /tmp/default_data_source.sql
USER    root

# ============================================================================ #

RUN     apt-get clean &&\
        rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* &&\
        rm -rf /src/* &&\
        rm grafana_2.1.3_amd64.deb &&\
        rm -rf /var/log*

RUN     mkdir -p /var/log/grafana && chown grafana:grafana /var/log/grafana &&\
        mkdir -p /var/log/supervisor &&\
        mkdir -p /var/log/nginx &&\
        mkdir -p /var/log/uwsgi &&\
        mkdir -p /var/log/graphite-web && chown www-data:www-data /var/log/graphite-web

# ============================================================================ #

# grafana port
EXPOSE 3000

# carbon-cache port
EXPOSE 2003

# expose graphite storage as a volume so that we can easily mount a directory from the host
VOLUME /opt/graphite/storage/whisper

# default command
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
