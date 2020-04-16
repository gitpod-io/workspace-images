FROM ubuntu:latest

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

# Make sure that end-users have packages available for their dockerimages
# FIXME: We are expecting `rm -rf /var/lib/apt/lists/*` in gitpod-layer to downsize the dockerimage
RUN apt update

# Install core dependencies
# FIXME: We should allow logic based on expected 'shell' i.e using `shell: bash` in gitpod.yml should expand in installing bash-completion
RUN apt-get install -y \
	novnc

# Configure default NoVNC in theia
COPY core/misc/novnc-index.html /opt/novnc/index.html

### Code below should be in a sourcable file ###
# Configure expected shell
COPY core/scripts/shellConfig.bash /usr/bin/shellConfig
# FIXME: This is expected to be set by gitpod based on end-user preference
ENV expectedShell="bash"
RUN true \
  && chmod +x /usr/bin/shellConfig \
  && /usr/bin/shellConfig \
  && rm /usr/bin/shellConfig