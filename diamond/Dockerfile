FROM ubuntu:14.04.1
MAINTAINER astromechza

# update repos and install packages
RUN     apt-get update
RUN     apt-get install -y python-dev python-pip &&\
        apt-get install -y supervisor adduser
RUN     apt-get install -y python-setuptools make pbuilder python-mock python-configobj python-support cdbs git python-psutil

# download and install Diamond
RUN     git clone https://github.com/python-diamond/Diamond.git
RUN     cd /Diamond &&\
        make builddeb &&\
        sudo dpkg -i build/diamond_*_all.deb
RUN     rm -rf /Diamond

# copy over configuration
COPY    ./config-diamond /config-diamond
COPY    ./config/diamond.conf /etc/diamond/diamond.conf
COPY    ./config/collector_confs /etc/diamond/collectors
COPY    ./config/collectors /usr/share/diamond/collectors
ADD     ./config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# inject host_proc modification
RUN     find /usr/share/diamond/collectors/ -type f -name "*.py" -print0 | xargs -0 sed -i 's/\/proc/\/host\/proc/g'

CMD     ["sh", "-c", "/config-diamond && exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf"]
