FROM gitpod/workspace-full-vnc

ENV RETRIGGER=3

ENV BUILDKIT_VERSION=0.10.3
ENV BUILDKIT_FILENAME=buildkit-v${BUILDKIT_VERSION}.linux-amd64.tar.gz

USER root

# Install dazzle, buildkit and pre-commit
RUN curl -sSL https://github.com/moby/buildkit/releases/download/v${BUILDKIT_VERSION}/${BUILDKIT_FILENAME} | tar -xvz -C /usr
RUN curl -sSL https://github.com/gitpod-io/dazzle/releases/download/v0.1.12/dazzle_0.1.12_Linux_x86_64.tar.gz | tar -xvz -C /usr/local/bin
RUN curl -sSL https://github.com/mvdan/sh/releases/download/v3.5.1/shfmt_v3.5.1_linux_amd64 -o /usr/bin/shfmt \
    && chmod +x /usr/bin/shfmt
RUN install-packages shellcheck \
    && pip3 install pre-commit
RUN curl -sSL https://github.com/mikefarah/yq/releases/download/v4.22.1/yq_linux_amd64 -o /usr/bin/yq && chmod +x /usr/bin/yq

ENV CYPRESS_CACHE_FOLDER=/workspace/.cypress-cache

# Install Cypress dependencies.
RUN sudo apt-get update \
 && sudo DEBIAN_FRONTEND=noninteractive apt-get install -y \
   libgtk2.0-0 \
   libgtk-3-0 \
   libnotify-dev \
   libgconf-2-4 \
   libnss3 \
   libxss1 \
   libasound2 \
   libxtst6 \
   xauth \
   xvfb \
 && sudo rm -rf /var/lib/apt/lists/*

RUN mkdir -p /workspace/persist/.cache/go-build
ENV GOCACHE=/workspace/persist/.cache/go-build
