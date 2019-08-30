FROM    gitpod/workspace-full
USER    gitpod


##
## -- Set up the environment for a Docker build -- want debconf-utils for later
##    -------------------------------------------------------------------------
RUN     sudo apt-get update \
  &&    sudo apt-get install debconf-utils -y -q \
  &&    sudo apt-get clean \
  &&    sudo rm -rf /var/cache/apt/* /var/lib/apt/lists/* /tmp/* 


##
## -- Install the Oracle Repo for MySQL
##    ---------------------------------
RUN     sudo wget https://dev.mysql.com/get/mysql-apt-config_0.8.13-1_all.deb -O /usr/mysql-apt-config_0.8.13-1_all.deb \
  &&    echo 4 | sudo dpkg -i /usr/mysql-apt-config_0.8.13-1_all.deb \
  &&    sudo rm /usr/mysql-apt-config_0.8.13-1_all.deb


##
## -- Install MySQL server on top of the basic Docker Container & Freshen up all the other packages just in case
##    -----------------------------------------------------------------------------------------------------------
USER    root
RUN     apt-get update \
  &&    DEBIAN_FRONTEND=noninteractive apt-get install mysql-server mysql-shell -y -q \
  &&    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y -q \
  &&    apt-get clean \
  &&    rm -rf /var/cache/apt/* /var/lib/apt/lists/* /tmp/* 
 USER   gitpod


##
## -- Now, we need to prepare for MySQL
##    ---------------------------------
RUN     sudo mkdir -p /var/run/mysqld /var/lib/mysql-upgrade /usr/share/mysql \
  &&    sudo chown -R gitpod:gitpod /etc/mysql /var/run/mysqld /var/log/mysql /var/lib/mysql /var/lib/mysql-files /var/lib/mysql-keyring /var/lib/mysql-upgrade /usr/share/mysql 
COPY    mysql.cnf /etc/mysql/mysql.conf.d/mysqld.cnf
COPY    client.cnf /etc/mysql/mysql.conf.d/client.cnf
COPY    launch.sh /etc/mysql/mysql-bashrc-launch.sh
RUN     sudo chmod +x /etc/mysql/mysql-bashrc-launch.sh


##
## -- Set mysql to start under the gitpod user
##    ----------------------------------------
RUN echo "/etc/mysql/mysql-bashrc-launch.sh" >> ~/.bashrc