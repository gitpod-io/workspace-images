ARG base
FROM ${base}

USER root

# Dazzle does not rebuild a layer until one of its lines are changed. Increase this counter to rebuild this layer.
ENV TRIGGER_REBUILD=1

# https://docs.docker.com/engine/install/ubuntu/
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && apt update \
    && install-packages docker-ce=5:27.3.1-1~ubuntu.22.04~jammy docker-ce-cli=5:27.3.1-1~ubuntu.22.04~jammy containerd.io docker-buildx-plugin

RUN curl -o /usr/local/bin/docker-compose -fsSL https://github.com/docker/compose/releases/download/v2.24.1/docker-compose-linux-$(uname -m) \
    && chmod +x /usr/local/bin/docker-compose && mkdir -p /usr/local/lib/docker/cli-plugins && \
    ln -s /usr/local/bin/docker-compose /usr/local/lib/docker/cli-plugins/docker-compose

# https://github.com/wagoodman/dive
RUN curl -o /tmp/dive.deb -fsSL https://github.com/wagoodman/dive/releases/download/v0.12.0/dive_0.12.0_linux_amd64.deb \
    && apt install /tmp/dive.deb \
    && rm /tmp/dive.deb

USER gitpod
