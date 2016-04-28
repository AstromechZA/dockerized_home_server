# Samba Container

This container hosts a Samba share that can have external directories mounted.

It is configured to have share 2 directories:

- smb://<ip>/publicdir
    This share has guest access allowed (but just read only) to edit the files
    here, login with the `sambapublic` or `sambaprivate` users.

- smb://<ip>/privatedir
    This share is locked down to only the `sambaprivate` user. It is also not
    browseable. You need to add it with the explicit path.

You can't change the names of the users without modifying this Dockerfile and
related scripts, but it is possible.

## Build

```
$ docker build -t usvr_samba .
```

## Run

By default the 2 folders shared on the network will be empty since they
naturally exist only in the fresh container. To mount files in them and / or
persist changes, you need to mount an external volume to the path.

The two paths are:

- /samba/public
- /samba/private

The most important configuration options are the passwords for the
`sambaprivate` and `sambapublic` users. These should be changed using
environment variables passed to the Docker container.

Because the volume is mounted in the container and has differement permission
bits and possibly different users, we also allow the UID for each user to be
changed as well.

Things you can change at launch time (see config-samba):

- user names
- user passwords
- user uids
- share names

```
$ docker run -d \
        -p 137:137/udp \
        -p 138:138/udp \
        -p 139:139  \
        -p 445:445 \
        -e SMB_PUB_PWD=$SAMBA_PUBLIC_PASSWORD \
        -e SMB_PRV_PWD=$SAMBA_PRIVATE_PASSWORD \
        -v $SAMBA_PUBLIC_PATH:/samba/public \
        -v $SAMBA_PRIVATE_PATH:/samba/private \
        --name usvr_s \
        usvr_samba
```

Once the container is running, the publicdir share should be available on the
network.
