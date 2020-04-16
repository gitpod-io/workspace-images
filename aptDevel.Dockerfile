FROM debian:stable

###! Additional info:
###! - Do not use sudo -> Set proper group permission

LABEL Gitpod Maintainers

# To avoid bricked workspaces assuming interactive shell breaks the build (https://github.com/gitpod-io/gitpod/issues/1171)
ENV DEBIAN_FRONTEND=noninteractive

# FIXME: We should allow end-users to set this
ENV LANG="en_US.UTF-8"
ENV LC_ALL=C

USER root

# Add 'gitpod' user
RUN useradd \
	--uid 33333 \
	--create-home --home-dir /home/gitpod \
	--shell /bin/bash \
	--password gitpod \
	gitpod

RUN apt update

RUN true \
  && mkdir /home/gitpod/makeshift \
  && apt-get -o Dir="/home/gitpod/makeshift/" install -y debootstrap \
  && chown -R gitpod:gitpod /home/gitpod/makeshift

# Experiment
COPY core/scripts/kapt.bash /usr/bin/kapt
RUN chmod +x /usr/bin/kapt