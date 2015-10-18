FROM ubuntu:14.04.1
MAINTAINER astromechza

ENV SMB_PUB_PATH /opt/samba/share/public
ENV SMB_PUB_USR sambapublic
ENV SMB_PUB_PWD changeme

ENV SMB_PRV_PATH /opt/samba/share/private
ENV SMB_PRV_USR sambaprivate
ENV SMB_PRV_PWD changeme

# update repos
RUN     apt-get update &&\
        apt-get install -y samba samba-common python-glade2 supervisor

# create users
RUN     useradd -s /bin/false "$SMB_PUB_USR"
RUN     (echo "$SMB_PUB_PWD"; echo "$SMB_PUB_PWD" ) | pdbedit -a -u "$SMB_PUB_USR"
RUN     useradd -s /bin/false "$SMB_PRV_USR"
RUN     (echo "$SMB_PRV_PWD"; echo "$SMB_PRV_PWD" ) | pdbedit -a -u "$SMB_PRV_USR"
RUN     smbpasswd -an nobody

# create mount directories
RUN     mkdir -p $SMB_PUB_PATH &&\
        chown $SMB_PUB_USR:$SMB_PUB_USR $SMB_PUB_PATH &&\
        chmod 755 $SMB_PUB_PATH

RUN     mkdir -p $SMB_PRV_PATH &&\
        chown $SMB_PRV_USR:$SMB_PRV_USR $SMB_PRV_PATH &&\
        chmod 750 $SMB_PRV_PATH

# configure
ADD     ./config/smb.conf /etc/samba/smb.conf
ADD     ./config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# expose smbd and nmdb ports
EXPOSE 137/udp 138/udp 139 445

# define volumes
VOLUME $SMB_PUB_PATH $SMB_PRV_PATH

CMD ["/usr/bin/python", "/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
