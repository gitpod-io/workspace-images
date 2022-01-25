FROM gitpod/workspace-full

USER gitpod

### Install Flutter
# dependencies
RUN set -ex; \
    sudo apt-get update; \
    sudo apt-get install -y libglu1-mesa; \
    sudo rm -rf /var/lib/apt/lists/*

RUN set -ex; \
    mkdir ~/development; \
    cd ~/development; \
    git clone --depth 1 https://github.com/flutter/flutter.git -b stable --no-single-branch

ENV PATH="$PATH:/home/gitpod/development/flutter/bin"

RUN set -ex; \
    flutter channel beta; \
    flutter upgrade; \
    flutter config --enable-web; \
    flutter precache
