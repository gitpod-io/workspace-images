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
# FIXME: We are expecting `rm -rf /var/lib/apt/lists/*` in gitpod-layer to downsize the dockerimage
RUN apt update

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
###! - [X] Dotnet
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
###! - [X] Docker (for development) -- See https://github.com/gitpod-io/gitpod/issues/52

# Used for docker
ENV XDG_RUNTIME_DIR=/tmp/docker-33333
ENV DOCKER_HOST="unix:///tmp/docker-33333/docker.sock"

# Install default dependencies
RUN true \
  # Dotnet, see https://docs.microsoft.com/en-us/dotnet/core/install/linux-package-manager-debian10
  && wget -O- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /etc/apt/trusted.gpg.d/ \
  && wget https://packages.microsoft.com/config/debian/10/prod.list -O /etc/apt/sources.list.d/microsoft-prod.list \
  && apt-get install -y \
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
    golang-go \
    php \
    ruby \
    apache2 \
    nginx \
    apt-transport-https \
    dotnet-sdk-3.1 \
    aspnetcore-runtime-3.1 \
    dotnet-runtime-3.1 \
    nodejs \
    java-common \
    default-jre \
    default-jdk \
    openjdk-11-jre \
    openjdk-11-jdk \
    curl \
    gpg \
    apt-utils

USER gitpod
RUN true \
  # Homebrew, see https://docs.brew.sh/Homebrew-on-Linux
  && test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv) \
  && test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv) \
  && test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile \
  && printf '%s\n' "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.profile \
  # Docker, see https://github.com/gitpod-io/gitpod/issues/52#issuecomment-546844862
  && curl -sSL https://get.docker.com/rootless | sh

# Add custom functions
RUN true \
  if ! grep -qF 'ix()' /etc/bash.bashrc; then printf '%s\n' \
	'# Custom' \
	"ix() { curl -F 'f:1=<-' ix.io 2>/dev/null ;}" \
	>> /etc/bash.bashrc; fi
