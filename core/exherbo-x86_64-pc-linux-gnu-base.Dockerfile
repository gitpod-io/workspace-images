FROM exherbo/exherbo-x86_64-pc-linux-gnu-base:latest

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

# Configure expected shell
COPY core/scripts/shellConfig.bash /usr/bin/shellConfig
# FIXME: This is expected to be set by gitpod based on end-user preference
ENV expectedShell="bash"
RUN true \
  && chmod +x /usr/bin/shellConfig \
  && /usr/bin/shellConfig \
  && rm /usr/bin/shellConfig