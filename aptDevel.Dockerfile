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

ENV KAPT_DIR="/home/gitpod/makeshift"

RUN true \
  && mkdir "$KAPT_DIR" \
  && mkdir "$KAPT_DIR/etc" \
  && cp -r /etc/apt "$KAPT_DIR/etc" \
  && mkdir "$KAPT_DIR" \
  && apt-get -o Dir="$KAPT_DIR" install -y debootstrap \
  && chown -R gitpod:gitpod "$KAPT_DIR"

# Experiment
COPY core/scripts/kapt.bash /usr/bin/kapt
RUN chmod +x /usr/bin/kapt