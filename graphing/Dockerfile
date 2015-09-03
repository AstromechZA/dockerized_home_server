FROM ubuntu:14.04.1

# update repos
RUN     apt-get update

# install packages
RUN     apt-get install -y python-cairo python-dev git wget curl python-pip
RUN     apt-get install -y nginx uwsgi uwsgi-plugin-python python-django-tagging python-twisted
RUN     apt-get install -y supervisor adduser libfontconfig
RUN     pip install pytz
RUN     pip install pyparsing

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

# add supervisord config
ADD     ./config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD     ./config/nginx/nginx.conf /etc/nginx/nginx.conf

# ============================================================================ #

RUN     apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN     rm -rf /src/*
RUN     rm grafana_2.1.3_amd64.deb

# ============================================================================ #

# nginx port
EXPOSE  80

# grafana port
EXPOSE 3000

# carbon-cache port (we want to be able to receive data from other containers)
EXPOSE 2003
EXPOSE 2004

# default command
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
