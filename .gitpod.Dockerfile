# .gitpod.Dockerfile
FROM kalilinux/kali-rolling:latest

ENV DEBIAN_FRONTEND=noninteractive
ENV APT_LISTCHANGES_FRONTEND=none

# Ngăn services auto-start trong container (tránh lỗi exit 100)
RUN echo '#!/bin/sh\nexit 0' > /usr/sbin/policy-rc.d && chmod +x /usr/sbin/policy-rc.d

# Update + install full kali + runtime tools
RUN apt-get update && apt-get -y dist-upgrade && \
    apt-get install -y --no-install-recommends \
        kali-linux-everything \
        kali-tools-everything \
        sudo curl wget git unzip zip nano vim htop tmux \
        nodejs npm python3 python3-pip python3.13 python-is-python3 \
        openjdk-21-jdk maven gradle \
        golang rustc cargo ruby-full \
        docker.io docker-compose \
        firefox-esr \
        redis-server postgresql mariadb-server mongodb \
        && apt-get -y autoremove && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set default shell
SHELL ["/bin/bash", "-c"]
