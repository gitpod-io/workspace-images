#!/bin/bash

# this script is intended to be called from .bashrc
# This is a workaround for not having something like supervisord

if [ ! -e /var/run/mysqld/gitpod-init.lock ]
then
    touch /var/run/mysqld/gitpod-init.lock

    # initialize database structures on disk, if needed
    [ ! -d /workspace/mysql ] && mysqld --initialize-insecure

    # launch database, if not running
    [ ! -e /var/run/mysqld/mysqld.pid ] && mysqld --daemonize
    
    # secure the installation
    [ ! -e /workspace/mysql/.secured ] && mysql_secure_installation && touch /workspace/mysql/.secured

    rm /var/run/mysqld/gitpod-init.lock
fi
