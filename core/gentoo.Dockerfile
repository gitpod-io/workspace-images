# This logic has been grabbed from https://hub.docker.com/r/gentoo/stage3-amd64/dockerfile

FROM busybox:latest

LABEL Gitpod Maintainers

# FIXME: We should allow end-users to set this
ENV LANG="en_US.UTF-8"
ENV LC_ALL=C

# This one should be present by running the build.sh script
ADD build.sh /

RUN /build.sh amd64 x86_64

# Setup the rc_sys
RUN sed -e 's/#rc_sys=""/rc_sys="docker"/g' -i /etc/rc.conf

# By default, UTC system
RUN printf '%s\n' 'UTC' > /etc/timezone

# Add 'gitpod' user
RUN useradd \
	--uid 33333 \
	--create-home --home-dir /home/gitpod \
	--shell /bin/bash \
	--password gitpod \
	gitpod

# Make sure the DNS resolution is set
RUN printf 'nameserver %s\n' \
	"1.1.1.1" "1.0.0.1" "2606:4700:4700::1111" "2606:4700:4700::1001" > /etc/resolv.conf

# Make sure that all packages are available
RUN emerge sync

# Install core dependencies
# FIXME: We should allow logic based on expected 'shell' i.e using `shell: bash` in gitpod.yml should expand in installing bash-completion
RUN emerge -vuDNj \
	www-apps/novnc

# Configure default NoVNC in theia
# FIXME: Make sure that this is the location used by gentoo
COPY core/misc/novnc-index.html /opt/novnc/index.html
