FROM buildpack-deps:jammy

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
        iputils-ping \
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
    # Remove `use_pty` option and enable passwordless sudo for users in the 'sudo' group
    && sed -i.bkp -e '/Defaults\tuse_pty/d' -e 's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' /etc/sudoers \
    # To emulate the workspace-session behavior within dazzle build env
    && mkdir /workspace && chown -hR gitpod:gitpod /workspace

ENV HOME=/home/gitpod
WORKDIR $HOME

# Configure Git
COPY default.gitconfig /etc/gitconfig
COPY --chown=gitpod:gitpod default.gitconfig $HOME/.gitconfig
RUN git lfs install --system --skip-repo

### Gitpod user (2) ###
USER gitpod
# use sudo so that user does not get sudo usage info on (the first) login
RUN sudo echo "Running 'sudo' for Gitpod: success" \
    # create .bashrc.d and .runonce dirs
    && mkdir -p $HOME/.bashrc.d $HOME/.runonce \
    # create a completions dir for gitpod user
    && mkdir -p $HOME/.local/share/bash-completion/completions

RUN <<'EOF'
cat >> "${HOME}/.bashrc" <<'SCRIPT'

# custom Bash prompt
PS1="\033[1;32m\u\033[0m \033[1;34m\w\033[0m$(__git_ps1 " (%s)") $ "

# runonce startup scripts loader
# This should not modify the shell environment, hence subshell.
(
    runonce_dir="$HOME/.runonce"
    lock_dir="${runonce_dir}/.lock"
    lock_done="${lock_dir}/done"

    if mkdir "${lock_dir}" 2>/dev/null; then {
        # First terminal holds the Atomic lock and others jump into the `else` block
            shopt -s nullglob
            for script in "${runonce_dir}/"*; do {
                # shellcheck source=/dev/null
                source "${script}"
            }; done
        touch "${lock_done}" # Unlock
    }; else {
        # Other terminals awaits for unlock
        until test -e "${lock_done}"; do sleep 0.3; done
    }; fi
)

# shell environment scripts loader
for i in $(ls -A $HOME/.bashrc.d/); do source $HOME/.bashrc.d/$i; done
SCRIPT
EOF

# Custom PATH additions
ENV PATH=$HOME/.local/bin:/usr/games:$PATH
