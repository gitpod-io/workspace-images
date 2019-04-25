FROM gitpod/workspace-full:latest

USER root

# Install MySQL
RUN apt-get update \
 && apt-get install -y mysql-server \
 && apt-get clean && rm -rf /var/cache/apt/* /var/lib/apt/lists/* /tmp/* \
 && cp /etc/mysql/debian.cnf /etc/mysql/mysql.conf.d/debian.cnf \
 && mkdir /var/run/mysqld \
 && chown -R gitpod:gitpod /etc/mysql /var/run/mysqld /var/log/mysql /var/lib/mysql /var/lib/mysql-files /var/lib/mysql-keyring /var/lib/mysql-upgrade

# Install our own MySQL-Config
COPY mysql.cnf /etc/mysql/mysql.conf.d/mysqld.cnf

USER gitpod

# Launch the MySQL daemon via .bashrc, but only if it is not yet running.
RUN echo "[ ! -e /var/run/mysqld/mysqld.pid ] && mysqld --daemonize" >> ~/.bashrc