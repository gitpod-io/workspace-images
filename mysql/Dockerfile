FROM gitpod/workspace-full:latest

USER root

# Install MySQL
RUN apt-get update \
 && apt-get install -y mysql-server \
 && apt-get clean && rm -rf /var/cache/apt/* /var/lib/apt/lists/* /tmp/* \
 && mkdir /var/run/mysqld \
 && chown -R gitpod:gitpod /etc/mysql /var/run/mysqld /var/log/mysql /var/lib/mysql /var/lib/mysql-files /var/lib/mysql-keyring /var/lib/mysql-upgrade

# Install our own MySQL config
COPY mysql.cnf /etc/mysql/mysql.conf.d/mysqld.cnf

# Install default-login for MySQL clients
COPY client.cnf /etc/mysql/mysql.conf.d/client.cnf


USER gitpod

# Initialize MySQL Database via .bashrc, but only if ther is no database data yet.
RUN echo "[ ! -d /workspace/mysql ] && mysqld --initialize-insecure" >> ~/.bashrc

# Launch the MySQL daemon via .bashrc, but only if it is not yet running.
RUN echo "[ ! -e /var/run/mysqld/mysqld.pid ] && mysqld --daemonize" >> ~/.bashrc
