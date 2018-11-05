FROM buildpack-deps:bionic

# Install useful tools
RUN apt-get update --fix-missing \
    && apt-get install -y \
      sudo \
      curl \
      build-essential \
      libssl-dev \
      vim \
      nano \
      less \
      man \
      bash-completion \
      locales make zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev llvm libncurses5-dev xz-utils \
      ca-certificates \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 \
    && apt-get clean && rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/*

# Enable passwordless sudo for users under the "sudo" group
RUN sed -i.bkp -e \
      's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' \
      /etc/sudoers
# Create Gitpod user
RUN useradd -u 33333 -d /home/gitpod -ms /bin/bash -p gitpod gitpod
# Add sudo prev
RUN adduser gitpod sudo

RUN echo "gitpod:gitpod" | chpasswd

USER gitpod
WORKDIR /home/gitpod
ENV HOME /home/gitpod

###############################################################################
# CONVENIENCE
###############################################################################
# Prompt color
RUN echo "PS1='\[\e]0;\u \w\a\]${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u\[\033[00m\] \[\033[01;34m\]\w \$ \[\033[00m\]'" >> ~/.bashrc


#Python
ENV PYENV_ROOT="$HOME/.pyenv" \
    PATH="$HOME/.pyenv/bin:$HOME/.pyenv/shims:$PATH" \
    LANG="en_US.UTF-8"

RUN curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash

RUN echo "export PATH=\"${PYENV_ROOT}/bin:\$PATH\"" >> ~/.bashrc\
    && echo "eval \"\$(pyenv init -)\"" >> ~/.bashrc\
    && echo "eval \"\$(pyenv virtualenv-init -)\"" >> ~/.bashrc

RUN pyenv install 3.6.6 && \
    pyenv global 3.6.6

RUN pip install virtualenv 'python-language-server[all]'==0.19.0

#Ruby
RUN gpg --verbose --keyserver hkp://pgp.mit.edu --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
RUN curl -sSL https://get.rvm.io | bash -s stable

ENV RUBY_VERSION=2.5.1
RUN /bin/bash -l -c "rvm requirements && rvm install $RUBY_VERSION && rvm use $RUBY_VERSION --default && rvm rubygems current && gem install bundler --no-doc --no-ri"

# Rust
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
RUN $HOME/.cargo/bin/rustup update \
    && $HOME/.cargo/bin/rustup component add rls-preview rust-analysis rust-src

# Install nvm with node and npm
ENV NODE_VERSION 8

RUN curl https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
RUN /bin/bash -l -c "\
       source $HOME/.nvm/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default \
    && npm config set python /usr/bin/python --global \
    && npm config set python /usr/bin/python \
    && npm install -g typescript"

ENV NODE_PATH ~/.nvm/v$NODE_VERSION/lib/node_modules
ENV PATH      ~/.nvm/versions/node/v$NODE_VERSION/bin:$PATH

# Install yarn
USER root
RUN curl -L https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -

RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends yarn \
    && apt-get clean && rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/* \
    && echo Installing Yarn newer than 1.10.1

## Install GO
ENV GO_VERSION 1.9.2
ENV GOROOT=/usr/local/go
ENV PATH $PATH:${GOROOT}/bin
ENV GOPATH=/usr/local/go-packages
ENV PATH $PATH:${GOPATH}/bin

RUN curl -sS https://storage.googleapis.com/golang/go$GO_VERSION.linux-amd64.tar.gz | tar -C /usr/local -xzf -
RUN go get -u -v github.com/ramya-rao-a/go-outline
RUN go get -u -v github.com/acroca/go-symbols
RUN go get -u -v github.com/nsf/gocode
RUN go get -u -v github.com/rogpeppe/godef
RUN go get -u -v golang.org/x/tools/cmd/godoc
RUN go get -u -v github.com/zmb3/gogetdoc
RUN go get -u -v golang.org/x/lint/golint
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
ENV GOPATH=/workspace:${GOPATH}
ENV PATH $PATH:/workspace/bin

# Install Java & Maven
RUN apt-get update \
  && apt-get install -y software-properties-common \
  && apt-get clean && rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/*

RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN add-apt-repository ppa:webupd8team/java \
  && apt-get update \
  && apt-get install -y \
        oracle-java8-installer \
        gradle \
  && apt-get clean && rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/*

# Maven
ARG MAVEN_VERSION=3.5.4
ARG USER_HOME_DIR="$HOME"
ARG SHA=ce50b1c91364cb77efe3776f756a6d92b76d9038b0a0782f7d53acf1e997a14d
ARG BASE_URL=https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries

RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
  && curl -fsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
  && echo "${SHA}  /tmp/apache-maven.tar.gz" | sha256sum -c - \
  && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
  && rm -f /tmp/apache-maven.tar.gz \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn
ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"
ENV PATH $PATH:${MAVEN_HOME}/bin

#C/C++
RUN curl https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -
RUN echo "deb http://apt.llvm.org/bionic/ llvm-toolchain-bionic-6.0 main" > /etc/apt/sources.list.d/llvm.list
RUN apt-get update \
    && apt-get install -y \
        clang-tools-6.0 \
        cmake \
        clang-format \
    && apt-get clean && rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/*
RUN ln -s /usr/bin/clangd-6.0 /usr/bin/clangd

# PHP
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get install -y \
        php \
        apache2 \
        composer \
        php-all-dev \
        php-intl \
        php-mysql \
        php-pgsql \
        php-xml \
        php-gd \
        php-json \
        php-curl \
        php-mbstring \
        php-sqlite3 \
        php-tokenizer \
        php-ctype \
        php-date \
        php-net-ftp \
        php-gettext \
        php-zip \
    && apt-get clean && rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/*
 # the PHP language server is installed by the theia-php-extension

# Install .NET Core SDK
# USER root
RUN wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && rm packages-microsoft-prod.deb \
    && rm .wget-hsts

RUN apt-get install -y apt-transport-https \
    && apt-get update \
    && apt-get install -y dotnet-sdk-2.1 \
    && apt-get clean && rm -rf /var/cache/apt/* && rm -rf /var/lib/apt/lists/* && rm -rf /tmp/*
