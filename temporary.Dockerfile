FROM debian:stable

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
# FIXME: We are expecting `rm -rf /var/lib/apt/lists/*` in gitpod-layer to downsize 
# NOTICE: You can use `gpg --search-keys` to get the recv-keys value, this requires upstream to upload in relevant keyserver and sync them
# NOTICE: Do not use debian/ubuntu keyserver --https://unix.stackexchange.com/questions/530778/what-is-debians-default-gpg-keyserver-and-where-is-it-configured -> Use keys.opengpg.org which also sets standard for keyserver instead of fregmenting
RUN true \
  # FIXME: Pipe the key in apt-key somehow
  && dpkg --add-architecture i386 \
  && apt update \
  && apt-get install -y gnupg \
  && apt-key adv --keyserver keys.openpgp.org --recv-keys 76F1A20FF987672F

# Configure sources.list
# NOTICE: Heredoc would be nicer here, but that seems to be pita in dockerfile
# NOTICE: We need to update again to get base dependencies
RUN printf '%s\n' \
    "# Testing" \
    "deb http://mirror.dkm.cz/debian testing main non-free contrib" \
    "deb-src http://mirror.dkm.cz/debian testing main non-free contrib" \
    "" \
    "# Sid" \
    "deb http://mirror.dkm.cz/debian sid main non-free contrib" \
    "deb-src http://mirror.dkm.cz/debian sid main non-free contrib" \
    "" \
    "# Stable" \
    "deb http://mirror.dkm.cz/debian stable main non-free contrib" \
    "deb-src http://mirror.dkm.cz/debian stable main non-free contrib" \
    "" \
    "# WINE" \
    "#deb [arch=amd64,i386] https://dl.winehq.org/wine-builds/debian/ bullseye main" \
    "#deb-src [arch=amd64,i386] https://dl.winehq.org/wine-builds/debian/ bullseye  main" \
  > /etc/apt/sources.list \
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
RUN true \
  # Homebrew, see https://docs.brew.sh/Homebrew-on-Linux
  && test -d "$HOME/.linuxbrew" && eval "$(~/.linuxbrew/bin/brew shellenv)" \
  && test -d "/home/linuxbrew/.linuxbrew" && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" \
  && test -r "$HOME/.bash_profile" && printf '%s\n' "eval \$($(brew --prefix)/bin/brew shellenv)" >> "$HOME/.bash_profile" \
  && printf '%s\n' "eval \$($(brew --prefix)/bin/brew shellenv)" >> "$HOME/.profile" \
  # Docker, see https://github.com/gitpod-io/gitpod/issues/52#issuecomment-546844862
  && curl -sSL https://get.docker.com/rootless | sh
