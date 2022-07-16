ARG base
# hadolint ignore=DL3006
FROM ${base}

USER root

# Dazzle does not rebuild a layer until one of its lines are changed. Increase this counter to rebuild this layer.
ENV TRIGGER_REBUILD=1

# https://docs.docker.com/engine/install/ubuntu/
# hadolint ignore=DL4006
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gosu root gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | gosu root tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && install-packages docker-ce docker-ce-cli containerd.io

RUN curl -o /usr/bin/slirp4netns -fsSL https://github.com/rootless-containers/slirp4netns/releases/download/v1.2.0/slirp4netns-"$(uname -m)" \
    && chmod +x /usr/bin/slirp4netns

RUN curl -o /usr/local/bin/docker-compose -fsSL https://github.com/gitpod-io/compose/releases/download/2.6.1-gitpod.0/docker-compose-linux-x86_64 \
    && chmod +x /usr/local/bin/docker-compose && mkdir -p /usr/local/lib/docker/cli-plugins && \
    ln -s /usr/local/bin/docker-compose /usr/local/lib/docker/cli-plugins/docker-compose

# https://github.com/wagoodman/dive
# hadolint ignore=DL3027
RUN curl -o /tmp/dive.deb -fsSL https://github.com/wagoodman/dive/releases/download/v0.10.0/dive_0.10.0_linux_amd64.deb \
    && apt install /tmp/dive.deb \
    && rm /tmp/dive.deb

USER gitpod
