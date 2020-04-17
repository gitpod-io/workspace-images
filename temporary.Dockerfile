FROM debian:stable

###! Additional info:
###! - Do not use sudo -> Set proper group permission
###! - Set variable SPEEDTEST_TRIES on the integer of expected speedtests
###!   - More tries -> More accurate result
###!   - Recommended value: 5
###! - Set variable APT_MIRROR on hard-codded mirror (stub in case gitpod will provide it's own mirror), speedtest will be performed anyway to verify that hardcoded mirror is faster then alternatives

LABEL Gitpod Maintainers

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
ENV APT_MIRROR="http://mirror.dkm.cz/debian"
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
COPY core/scripts/apt-mirror-benchmark.sh /usr/bin/apt-mirror-benchmark
RUN true "fdhsdfh" \
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
	&& apt-key adv --keyserver keys.openpgp.org --recv-keys 0x76F1A20FF987672F \
	&& apt-get update

# Install core dependencies
# FIXME: We should allow logic based on expected 'shell' i.e using `shell: bash` in gitpod.yml should expand in installing bash-completion
RUN apt-get install -y \
	novnc

# Configure default NoVNC in theia
COPY core/misc/novnc-index.html /opt/novnc/index.html

###! The idea of this dockerimage is to provide everything that end-users might need for their workflow on gitpod
###! We need following:
###! - [X] Rust
###! - [X] Java
###! - [ ] Dotnet
###! - [X] Python
###! - [X] Openbox (Used in theia desktop)
###! - [X] nano
###! - [X] vim
###! - [X] Shellcheck
###! - [X] emacs
###! - [X] htop
###! - [X] zip
###! - [X] unzip
###! - [X] tar
###! - [X] Packages for building (build-essentials)
###! - [X] less
###! - [X] git
###! - [X] Apache2
###! - [X] PHP
###! - [X] Nginx
###! - [X] Homebrew
###! - [X] Go
###! - [X] Node.js
###! - [X] Ruby
###! - [ ] Docker (for development) -- See https://github.com/gitpod-io/gitpod/issues/52
###! Additional info:
###! - [ ] End-users are expected to use apt

# Used for docker
#ENV XDG_RUNTIME_DIR=/tmp/docker-33333
#ENV DOCKER_HOST="unix:///tmp/docker-33333/docker.sock"

# Install default dependencies
RUN true \
  && apt-get install -y \
    build-essential \
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
    golang-go \
    php \
    ruby \
    apache2 \
    nginx \
    apt-transport-https \
    nodejs \
    java-common \
    default-jre \
    default-jdk \
    openjdk-11-jre \
    openjdk-11-jdk \
    curl \
    gpg \
    apt-utils \
  # We need a shellcheck >=0.7.0, see https://github.com/gitpod-io/workspace-images/pull/204#issuecomment-614463958
  && apt-get install -t testing -y \
    shellcheck

USER gitpod
# RUN true \
#   # Homebrew, see https://docs.brew.sh/Homebrew-on-Linux
#   && /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)" \ 
#   && test -d "$HOME/.linuxbrew" && eval "$(~/.linuxbrew/bin/brew shellenv)" \
#   && test -d "/home/linuxbrew/.linuxbrew" && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" \
#   && test -r "$HOME/.bash_profile" && printf '%s\n' "eval \$($(brew --prefix)/bin/brew shellenv)" >> "$HOME/.bash_profile" \
#   && printf '%s\n' "eval \$($(brew --prefix)/bin/brew shellenv)" >> "$HOME/.profile" \
#   # Docker, see https://github.com/gitpod-io/gitpod/issues/52#issuecomment-546844862
#   && curl -sSL https://get.docker.com/rootless | sh
