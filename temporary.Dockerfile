FROM debian:stable

LABEL Gitpod Maintainers

###! Additional info:
###! - Do not use sudo -> Set proper group permission
###! - Set variable SPEEDTEST_TRIES on the integer of expected speedtests
###!   - More tries -> More accurate result
###!   - Recommended value: 5
###! - Set variable APT_MIRROR on hard-codded mirror (stub in case gitpod will provide it's own mirror), speedtest will be performed anyway to verify that hardcoded mirror is faster then alternatives

# To avoid bricked workspaces assuming interactive shell breaks the build (https://github.com/gitpod-io/gitpod/issues/1171)
# NOTICE(Kreyren): double quotes are not needed here, but i think it looks nicer
ENV DEBIAN_FRONTEND="noninteractive"

# FIXME: We should allow end-users to set this (logic in code sets translation based on LANG variable)
ENV LANG="en_US.UTF-8"
ENV LC_ALL="C"

# Set on the number of expected speedtests performed
# - Use 'disabled' to skip speedtests, not-recommended!
ENV SPEEDTEST_TRIES="5"
# This is a penalty issued to mirrors that are we are unable to fetch from as a part of speedtest (mostly problem on unreliable mirrors and code-quality issues), higger value makes the mirror less likely to be selected as the fastest
ENV FAILED_MIRROR_PENALTY="5000"

USER root

# Get thealer
COPY dockerfiles/core/scripts/thealer.bash /usr/bin/thealer
RUN true "fhsdfh" \
	&& chmod +x /usr/bin/thealer

# Add 'gitpod' user
RUN useradd \
	--uid 33333 \
	--create-home --home-dir /home/gitpod \
	# NOTICE: We allow end-users to set their own shell, but bash is used by default
	--shell /bin/bash \
	--password gitpod \
	gitpod

# Grab bare minimum that we need for configuration
# NOTICE: You can use `gpg --search-keys` to get the recv-keys value, this requires upstream to upload in relevant keyserver and sync them
# NOTICE: Do not use debian/ubuntu keyserver (https://unix.stackexchange.com/questions/530778/what-is-debians-default-gpg-keyserver-and-where-is-it-configured) -> Use keys.opengpg.org which also sets standard for keyserver instead of fregmenting
# NOTICE(Kreyren): Netherlands mirror seems to be the fastest to Gitpod in Europe and has laws that protect end-user's privacy
ENV APT_MIRROR="http://debian.mirror.cambrium.nl/debian"
RUN printf '%s\n' \
		"# Stable" \
		"deb $APT_MIRROR stable main non-free contrib" \
		"deb-src $APT_MIRROR stable main non-free contrib" \
	> /etc/apt/sources.list \
	&& apt-get update \
	# NOTICE: We need apt-utils later for package configuration
	# NOTICE: We need bc in apt-mirror-benchmark script
	&& apt-get install -y gnupg wget apt-utils netselect-apt bc

# Initial configuration
# FIXME: Ideally this shoudn't be cached to avoid grabbing dead mirror
COPY scripts/apt-mirror-benchmark.sh /usr/bin/apt-mirror-benchmark
RUN true \
	# Make sure that sources.list is wiped
	&& printf '%s\n' "" > /etc/apt/sources.list \
	&& chmod +x /usr/bin/apt-mirror-benchmark \
	&& /usr/bin/apt-mirror-benchmark \
	&& rm /usr/bin/apt-mirror-benchmark \
	&& printf '%s\n' \
		"" \
		"# WINE" \
		"deb [arch=amd64,i386] https://dl.winehq.org/wine-builds/debian/ bullseye main" \
		"deb-src [arch=amd64,i386] https://dl.winehq.org/wine-builds/debian/ bullseye  main" \
	>> /etc/apt/sources.list \
	# Ensure that we have 32-bit available
	&& dpkg --add-architecture i386 \
	# WINEHQ dependencies
	&& wget -qnc https://dl.winehq.org/wine-builds/winehq.key -O - | apt-key add - \
	# FIXME: Outputs 'Warning: apt-key output should not be parsed (stdout is not a terminal)'
	&& apt-key adv --keyserver keys.openpgp.org --recv-keys 0x76F1A20FF987672F \
	&& apt-get update

# DO_NOT_MERGE: Experiment
ENV aptList="$(apt list 2>/dev/null)"

# Install core dependencies
# FIXME: We should allow logic based on expected 'shell' i.e using `shell: bash` in gitpod.yml should expand in installing bash-completion
RUN thealer install novnc

# Configure default NoVNC in theia
COPY dockerfiles/core/misc/novnc-index.html /opt/novnc/index.html

### Code below should be in a sourcable file ###
# FIXME: Needs rework
# Configure expected shell
# FIXME: This is expected to be set by gitpod based on end-user preference
# ENV expectedShell="bash"
# COPY dockerfiles/core/scripts/shellConfig.bash /usr/bin/shellConfig
# RUN true "dsgasdghhg" \
# 	&& chmod +x /usr/bin/shellConfig \
# 	&& /usr/bin/shellConfig \
# 	&& rm /usr/bin/shellConfig
###! This is a dockerfile expecting to be appended to any docker core

# FIXME: Disable linting err
USER root

# Install all required packages
RUN true "sdhsfh" \
	thealer install \
	build-essentials \
	git \
	nano \
	vim \
	emacs \
	htop \
	less \
	zip \
	unzip \
	tar \
	rustc \
	cargo \
	openbox \
	python \
	python3 \
	pylint \
	shellcheck \
	golang \
	php \
	ruby \
	nim \
	apache2 \
	nginx \
	apt-transport-https \