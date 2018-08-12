FROM buildpack-deps:bionic

# Create Gitpod user
RUN useradd -u 33333 -d /home/gitpod -ms /bin/bash -p gitpod gitpod
RUN echo "gitpod:gitpod" | chpasswd

# Install useful tools
RUN apt-get update --fix-missing \
    && apt-get install -y \
      curl \
      build-essential \
      libssl-dev \
      vim \
      less \
      man \
      bash-completion \
      locales make zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev llvm libncurses5-dev xz-utils \
      ca-certificates \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 \
    && apt-get clean && rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/*


# Install nvm with node and npm
USER gitpod

ENV NODE_VERSION 8

RUN curl https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
RUN /bin/bash -l -c "\
       source ~/.nvm/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default \
    && npm config set python /usr/bin/python --global \
    && npm config set python /usr/bin/python"

ENV NODE_PATH ~/.nvm/v$NODE_VERSION/lib/node_modules
ENV PATH      ~/.nvm/versions/node/v$NODE_VERSION/bin:$PATH

# Install yarn
USER root
RUN curl https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends yarn \
    && apt-get clean && rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/*

## Install GO
USER gitpod
ENV GO_VERSION 1.9.2
ENV GOROOT=/usr/local/go
ENV PATH $PATH:${GOROOT}/bin
ENV GOPATH=/usr/local/go-packages
ENV PATH $PATH:${GOPATH}/bin

USER root
RUN curl -sS https://storage.googleapis.com/golang/go$GO_VERSION.linux-amd64.tar.gz | tar -C /usr/local -xzf -
RUN go get -u -v github.com/ramya-rao-a/go-outline
RUN go get -u -v github.com/acroca/go-symbols
RUN go get -u -v github.com/nsf/gocode
RUN go get -u -v github.com/rogpeppe/godef
RUN go get -u -v golang.org/x/tools/cmd/godoc
RUN go get -u -v github.com/zmb3/gogetdoc
RUN go get -u -v github.com/golang/lint/golint
RUN go get -u -v github.com/fatih/gomodifytags
RUN go get -u -v github.com/uudashr/gopkgs/cmd/gopkgs
RUN go get -u -v golang.org/x/tools/cmd/gorename
RUN go get -u -v sourcegraph.com/sqs/goreturns
RUN go get -u -v github.com/cweill/gotests/...
RUN go get -u -v golang.org/x/tools/cmd/guru
RUN go get -u -v github.com/josharian/impl
RUN go get -u -v github.com/haya14busa/goplay/cmd/goplay
RUN go get -u -v github.com/davidrjenni/reftools/cmd/fillstruct

# Keep the GO packages installed under /usr/local/go-packages but install all user packages to /workspace
USER gitpod

ENV GOPATH=/workspace:${GOPATH}
ENV PATH $PATH:/workspace/bin

# Install Java
# Install add-apt-repository
USER root

RUN apt-get update \
  && apt-get install -y software-properties-common \
  && apt-get clean && rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/*

RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN add-apt-repository ppa:webupd8team/java \
  && apt-get update \
  && apt-get install -y oracle-java8-installer \
  && apt-get clean && rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/*

#C/C++
RUN curl https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -
RUN echo "deb http://apt.llvm.org/bionic/ llvm-toolchain-bionic-6.0 main" > /etc/apt/sources.list.d/llvm.list
RUN apt-get update \
    && apt-get install -y clang-tools-6.0 \
    && apt-get clean && rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/*
RUN ln -s /usr/bin/clangd-6.0 /usr/bin/clangd

#Python
ENV PYENV_ROOT="/.pyenv" \
    PATH="/.pyenv/bin:/.pyenv/shims:$PATH" \
    LANG="en_US.UTF-8"

RUN curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash

RUN pyenv install 3.6.6 && \
    pyenv global 3.6.6

RUN pip install virtualenv 'python-language-server[all]'

#Ruby
RUN gpg --verbose --keyserver hkp://pgp.mit.edu --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
RUN curl -sSL https://get.rvm.io | bash -s stable
RUN usermod -a -G rvm gitpod

ENV RUBY_VERSION=2.5.1
RUN /bin/bash -l -c "rvm requirements && rvm install $RUBY_VERSION && rvm use $RUBY_VERSION --default && rvm rubygems current && gem install bundler --no-doc --no-ri"

# PHP
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
        php \
        php-zip \
        composer \
        php-all-dev \
    && apt-get clean && rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/*
 # the PHP language server is installed by the theia-php-extension

# Install .NET Core SDK
RUN wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb

RUN apt-get install -y apt-transport-https \
    && apt-get update \
    && apt-get install -y dotnet-sdk-2.1

# Rust
USER gitpod
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
RUN bin/bash -l -c "rustup update && rustup component add rls-preview rust-analysis rust-src"

###############################################################################
# CONVENIENCE
###############################################################################
# Prompt color
USER gitpod
RUN echo "PS1='\[\e]0;\u \w\a\]${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u\[\033[00m\] \[\033[01;34m\]\w \$ \[\033[00m\]'" >> ~/.bashrc

USER root