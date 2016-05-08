# FTP Container

This Docker container hosts a specific folder via FTP.

Environment variables passed through to the container allow
you to set the username and password of the ftp user that has
read and write access to the folder.

WARNING: if there is a 'public' folder in the shared folder, it
will be available in read only form to any anonymous users.
You can log in as anonymous by using the username 'ftp' or 'anonymous'
with an empty password. If there is no 'public' subfolder. The
anonymous user will not be able to log in.

## Configuration:

4 Environment variables can be set in the container:

LOGIN_USER: the username to log in as (default 'public')
LOGIN_PASSWORD: the password for this login user (no default)
LOGIN_USER_UID: the UID for the login user (optiona)
CHOWN_GID: an GID to use for chmodding the fileshare (optiona)

The latter two variables are useful when exposing a folder from
the docker host if you want to keep its existing ownership bits.

There is 1 volume that you can mount into the container:

'/fileshare': the folder that will be shared.

## Ports:

The container hosts a variety of ports that should all be bound on
the host.

20 - ftp data port
21 - ftp command port
21100 -> 21110 - ports for passive ftp connections
