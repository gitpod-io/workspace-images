FROM buildpack-deps:cosmic

### base ###
RUN yes | unminimize \
    && apt-get install -yq \
        asciidoctor \
        bash-completion \
        build-essential \
        htop \
        jq \
        less \
        llvm \
        locales \
        man-db \
        nano \
        software-properties-common \
        sudo \
        vim \
    && locale-gen en_US.UTF-8 \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/*
ENV LANG=en_US.UTF-8

### Gitpod user ###
# '-l': see https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#user
RUN useradd -l -u 33333 -G sudo -md /home/gitpod -s /bin/bash -p gitpod gitpod \
    # passwordless sudo for users in the 'sudo' group
    && sed -i.bkp -e 's/%sudo\s\+ALL=(ALL\(:ALL\)\?)\s\+ALL/%sudo ALL=NOPASSWD:ALL/g' /etc/sudoers
ENV HOME=/home/gitpod
WORKDIR $HOME
# custom Bash prompt
RUN { echo && echo "PS1='\[\e]0;\u \w\a\]\[\033[01;32m\]\u\[\033[00m\] \[\033[01;34m\]\w\[\033[00m\] \\\$ '" ; } >> .bashrc

### C/C++ ###
RUN curl -fsSL https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - \
    && apt-add-repository -yu "deb http://apt.llvm.org/cosmic/ llvm-toolchain-cosmic-6.0 main" \
    && apt-get install -yq \
        clang-format-6.0 \
        clang-tools-6.0 \
        cmake \
    && ln -s /usr/bin/clangd-6.0 /usr/bin/clangd \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/*

### Java & Maven ###
RUN add-apt-repository -yu ppa:webupd8team/java \
    && echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections \
    && apt-get install -yq \
        gradle \
        oracle-java8-installer \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/*

ARG MAVEN_VERSION=3.5.4
ENV MAVEN_HOME=/usr/share/maven
ENV PATH=$MAVEN_HOME/bin:$PATH
RUN mkdir -p $MAVEN_HOME \
    && curl -fsSL https://apache.osuosl.org/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz \
        | tar -xzvC $MAVEN_HOME --strip-components=1

### PHP ###
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -yq \
        composer \
        php \
        php-all-dev \
        php-ctype \
        php-curl \
        php-date \
        php-gd \
        php-gettext \
        php-intl \
        php-json \
        php-mbstring \
        php-mysql \
        php-net-ftp \
        php-pgsql \
        php-sqlite3 \
        php-tokenizer \
        php-xml \
        php-zip \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/*
# PHP language server is installed by theia-php-extension

### Yarn ###
RUN curl -fsSL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && apt-add-repository -yu "deb https://dl.yarnpkg.com/debian/ stable main" \
    && apt-get install --no-install-recommends -yq yarn=1.12.3-1 \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/*

### Gitpod user (2) ###
USER gitpod
# use sudo so that user does not get sudo usage info on (the first) login
RUN sudo echo "Running 'sudo' for Gitpod: success"

### Go ###
ENV GO_VERSION=1.11.2 \
    GOPATH=$HOME/go-packages \
    GOROOT=$HOME/go
ENV PATH=$GOROOT/bin:$GOPATH/bin:$PATH
RUN curl -fsSL https://storage.googleapis.com/golang/go$GO_VERSION.linux-amd64.tar.gz | tar -xzv \
    && go get -u -v \
        github.com/acroca/go-symbols \
        github.com/cweill/gotests/... \
        github.com/davidrjenni/reftools/cmd/fillstruct \
        github.com/fatih/gomodifytags \
        github.com/haya14busa/goplay/cmd/goplay \
        github.com/josharian/impl \
        github.com/nsf/gocode \
        github.com/ramya-rao-a/go-outline \
        github.com/rogpeppe/godef \
        github.com/uudashr/gopkgs/cmd/gopkgs \
        github.com/zmb3/gogetdoc \
        golang.org/x/lint/golint \
        golang.org/x/tools/cmd/godoc \
        golang.org/x/tools/cmd/gorename \
        golang.org/x/tools/cmd/guru \
        sourcegraph.com/sqs/goreturns
# user Go packages
ENV GOPATH=/workspace:$GOPATH \
    PATH=/workspace/bin:$PATH

### Node.js ###
ARG NODE_VERSION=8.14.0
ENV PATH=/home/gitpod/.nvm/versions/node/v8.14.0/bin:$PATH
RUN curl -fsSL https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash \
    && bash -c ". .nvm/nvm.sh \
        && npm config set python /usr/bin/python --global \
        && npm config set python /usr/bin/python \
        && npm install -g typescript"

### Python ###
ENV PATH=$HOME/.pyenv/bin:$HOME/.pyenv/shims:$PATH
RUN curl -fsSL https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash \
    && { echo; \
        echo 'eval "$(pyenv init -)"'; \
        echo 'eval "$(pyenv virtualenv-init -)"'; } >> .bashrc \
    && pyenv install 3.6.6 \
    && pyenv global 3.6.6 \
    && pip install virtualenv pipenv python-language-server[all]==0.19.0 \
    && rm -rf /tmp/*

### Ruby ###
ENV RUBY_VERSION=2.6.0
RUN curl -sSL https://rvm.io/mpapis.asc | gpg --import - \
    && curl -sSL https://rvm.io/pkuczynski.asc | gpg --import - \
    && curl -fsSL https://get.rvm.io | bash -s stable \
    && bash -lc " \
        rvm requirements \
        && rvm install $RUBY_VERSION \
        && rvm use $RUBY_VERSION --default \
        && rvm rubygems current \
        && gem install bundler --no-document"

### Rust ###
RUN curl -fsSL https://sh.rustup.rs | sh -s -- -y \
    && .cargo/bin/rustup update \
    && .cargo/bin/rustup component add rls-preview rust-analysis rust-src \
    && .cargo/bin/rustup completions bash | sudo tee /etc/bash_completion.d/rustup.bash-completion > /dev/null

### checks ###
# no root-owned files in the home directory
RUN notOwnedFile=$(find . -not "(" -user gitpod -and -group gitpod ")" -print -quit) \
    && { [ -z "$notOwnedFile" ] \
        || { echo "Error: not all files/dirs in $HOME are owned by 'gitpod' user & group"; exit 1; } }
