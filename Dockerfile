FROM ubuntu:14.04.1

# update repos
RUN     apt-get update

# install nginx
RUN     apt-get install -y nginx uwsgi uwsgi-plugin-python python-django-tagging python-twisted
RUN     pip install pytz
RUN     pip install pyparsing

# disable default site
RUN     rm /etc/nginx/sites-enabled/default

# make temp dir
RUN     mkdir temp && cd temp && TEMP_DIR=$(pwd)

# Checkout the stable branches of Graphite, Carbon and Whisper and install from there
RUN     git clone https://github.com/graphite-project/whisper.git
RUN     cd whisper
RUN     git checkout 0.9.x
RUN     python setup.py install
RUN     cd $TEMP_DIR

RUN     git clone https://github.com/graphite-project/carbon.git
RUN     cd carbon
RUN     git checkout 0.9.x
RUN     python setup.py install
RUN     cd $TEMP_DIR

RUN     git clone https://github.com/graphite-project/graphite-web.git
RUN     cd graphite-web
RUN     git checkout 0.9.x
RUN     python setup.py install
RUN     cd $TEMP_DIR

# remote defaults
RUN     cd /opt/graphite/conf
RUN     mkdir examples
RUN     mv *.example examples

# add in only the needed files
RUN     cp examples/storage-schemas.conf.example storage-schemas.conf
RUN     cp examples/storage-aggregation.conf.example storage-aggregation.conf
RUN     cp examples/carbon.conf.example carbon.conf
RUN     cp examples/graphite.wsgi.example wsgi.py

ADD     ./config/local_settings.py /opt/graphite/webapp/graphite/local_settings.py
ADD     ./config/initial_data.json /opt/graphite/webapp/graphite/initial_data.json

RUN     python /opt/graphite/webapp/graphite/manage.py syncdb --noinput
RUN     chown -R www-data:www-data /opt/graphite/webapp/ /opt/graphite/storage/

ADD     ./config/nginx_default /etc/nginx/sites-available/default
ADD     ./config/graphite.ini /etc/uwsgi/apps-available/graphite.ini

RUN     ln -s /etc/nginx/sites-available/default  /etc/nginx/sites-enabled/
RUN     ln -s /etc/uwsgi/apps-available/graphite.ini /etc/uwsgi/apps-enabled/

