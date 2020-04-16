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


# Experiment - Krey's rootless APT! ^-^
ENV KAPT_DIR="/home/gitpod/makeshift"

RUN true && true \
  && apt install -y debootstrap \
  && debootstrap --arch=amd64 stable "$KAPT_DIR" http://deb.debian.org/debian \
  && chown -R gitpod:gitpod "$KAPT_DIR"

# RUN true \
#   && apt-get \
#     -o Dir="$KAPT_DIR" \
#     # Use /etc/apt from host
#     -o Dir::Etc="/etc/apt" \
#     # Baka apt does not respect FSH3_0 standard
#     -o Dir::Cache="$HOME/.cache/apt" \
#   install -y debootstrap \
#   && chown -R gitpod:gitpod "$KAPT_DIR"

COPY core/scripts/kapt.bash /usr/bin/kapt
RUN chmod +x /usr/bin/kapt