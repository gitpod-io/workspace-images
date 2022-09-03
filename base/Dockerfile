FROM buildpack-deps:focal

COPY install-packages upgrade-packages /usr/bin/

### base ###
RUN yes | unminimize \
    && install-packages \
        zip \
        unzip \
        bash-completion \
        build-essential \
        ninja-build \
        htop \
        jq \
        less \
        locales \
        man-db \
        nano \
        ripgrep \
        software-properties-common \
        sudo \
        stow \
        time \
        emacs-nox \
        vim \
        multitail \
        lsof \
        ssl-cert \
        fish \
        zsh \
    && locale-gen en_US.UTF-8

ENV LANG=en_US.UTF-8

### Update and upgrade the base image ###
RUN upgrade-packages

### Git ###
RUN add-apt-repository -y ppa:git-core/ppa
RUN install-packages git git-lfs

### Gitpod user ###
# '-l': see https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#user
RUN useradd -l -u 33333 -G sudo -md /home/gitpod -s /bin/bash -p gitpod gitpod \
    # passwordless sudo for users in the 'sudo' group
    && sed -i.bkp -e 's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' /etc/sudoers \
    # To emulate the workspace-session behavior within dazzle build env
    && mkdir /workspace && chown -hR gitpod:gitpod /workspace

ENV HOME=/home/gitpod
WORKDIR $HOME
# custom Bash prompt
RUN RC='\033[0m' GREEN='\033[1;32m' BLUE='\033[1;34m' && \
    printf '%s\n' PS1="'${GREEN}\u${RC} ${BLUE}\w${RC}\$(__git_ps1 \" (%s)\") $ '" >> "$HOME/.bashrc"

COPY default.gitconfig /etc/gitconfig
COPY --chown=gitpod:gitpod default.gitconfig "$HOME/.gitconfig"

# configure git-lfs
RUN git lfs install --system --skip-repo

### Gitpod user (2) ###
USER gitpod
# use sudo so that user does not get sudo usage info on (the first) login
RUN sudo echo "Running 'sudo' for Gitpod: success" && \
    # create .bashrc.d folder and source it in the bashrc
    mkdir -p "$HOME/.bashrc.d" && \
    printf '\n%s\n' 'shopt -s nullglob; for s in "$HOME/.bashrc.d/"*; do source "$s"; done; shopt -u nullglob' >> "$HOME/.bashrc" && \
    # create a completions dir for gitpod user
    mkdir -p "$HOME/.local/share/bash-completion/completions"

# Custom PATH additions
ENV PATH="$HOME/.local/bin:/usr/games:$PATH"

# Install bashrc.d scripts
COPY --chown=gitpod:gitpod bashrc.d/* $HOME/.bashrc.d
