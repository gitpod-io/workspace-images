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

# Configure apt to be used on non-root
## NOTICE: We need read+write in /var/lib/dpkg/lock-frontend
RUN true \
	&& groupadd apt \
	&& usermod -a -G apt gitpod \
	&& chown -R root:apt /var/lib/dpkg/ \
	&& chmod -R g+w /var/lib/dpkg/ \
	&& chown -R root:apt /var/lib/apt/ \
	&& chmod -R g+w /var/lib/apt \