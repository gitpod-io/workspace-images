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

# Get thealer
COPY dockerfiles/core/scripts/thealer.bash /usr/bin/thealer
RUN chmod +x /usr/bin/thealer

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

# Configure repos.conf
# We need pentoo for powershell-bin
RUN true \
	curl "https://raw.githubusercontent.com/pentoo/pentoo-overlay/a5f9c65b14cc84e98c351f5e141b9ee6ba9faba6/pentoo/wctf-client/files/pentoo.conf" >/dev/null > /etc/portage/repos.conf/pentoo.conf

# Make sure that all packages are available
RUN emerge sync

# Get eix and it's database to be used in thealer
# WARNING(Krey): Gentoo has !@#% ton of packages: 'Database contains 19073 packages in 168 categories'
RUN true \
	&& emerge -vuDNj eix \
	# Required to get the list cached
	&& eix-update

# Install core dependencies
# FIXME: We should allow logic based on expected 'shell' i.e using `shell: bash` in gitpod.yml should expand in installing bash-completion
RUN thealer novnc

# Configure default NoVNC in theia
# FIXME: Make sure that this is the location used by gentoo
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