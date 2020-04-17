FROM gitpod/debian:latest

###! The idea of this dockerimage is to provide everything that end-users might need for their workflow on gitpod

# Used for docker
ENV XDG_RUNTIME_DIR=/tmp/docker-33333
ENV DOCKER_HOST="unix:///tmp/docker-33333/docker.sock"

# Install default dependencies
RUN true \
  # Docker, see https://github.com/gitpod-io/gitpod/issues/52#issuecomment-546844862
  && curl -sSL https://get.docker.com/rootless | sh \
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
    openjdk-11-jdk

USER gitpod
RUN true \
  # Homebrew, see https://docs.brew.sh/Homebrew-on-Linux
  && test -d ~/.linuxbrew && eval $(~/.linuxbrew/bin/brew shellenv) \
  && test -d /home/linuxbrew/.linuxbrew && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv) \
  && test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile \
  && printf '%s\n' "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.profile

# Add custom functions
RUN true \
  if ! grep -qF 'ix()' /etc/bash.bashrc; then printf '%s\n' \
	'# Custom' \
	"ix() { curl -F 'f:1=<-' ix.io 2>/dev/null ;}" \
	>> /etc/bash.bashrc; fi