FROM archlinux:latest

LABEL Gitpod Maintainers

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

# Make sure the DNS resolution is set
RUN printf 'nameserver %s\n' \
	"1.1.1.1" "1.0.0.1" "2606:4700:4700::1111" "2606:4700:4700::1001" > /etc/resolv.conf

### Code below should be in a sourcable file ###

# Configure expected shell
COPY core/scripts/shellConfig.bash /usr/bin/shellConfig
# FIXME: This is expected to be set by gitpod based on end-user preference
ENV expectedShell="bash"
RUN true \
  && chmod +x /usr/bin/shellConfig \
  && /usr/bin/shellConfig \
  && rm /usr/bin/shellConfig