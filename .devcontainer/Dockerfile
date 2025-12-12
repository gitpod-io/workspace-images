FROM gitpod/workspace-full:latest

# Disable npm/yarn lifecycle scripts for security
RUN npm config set ignore-scripts true --location=user && \
    echo 'ignore-scripts true' >> ~/.yarnrc

ENV RETRIGGER=5

ENV BUILDKIT_VERSION=0.12.3
ENV BUILDKIT_FILENAME=buildkit-v${BUILDKIT_VERSION}.linux-amd64.tar.gz
ENV DAZZLE_VERSION=0.1.17

USER root

# Update package lists and install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    shellcheck \
    && rm -rf /var/lib/apt/lists/*

# Install dazzle, buildkit and other tools
RUN curl -sSL https://github.com/moby/buildkit/releases/download/v${BUILDKIT_VERSION}/${BUILDKIT_FILENAME} | tar -xvz -C /usr
RUN curl -sSL https://github.com/gitpod-io/dazzle/releases/download/v${DAZZLE_VERSION}/dazzle_${DAZZLE_VERSION}_Linux_x86_64.tar.gz | tar -xvz -C /usr/local/bin
RUN curl -sSL https://github.com/mvdan/sh/releases/download/v3.5.1/shfmt_v3.5.1_linux_amd64 -o /usr/bin/shfmt \
    && chmod +x /usr/bin/shfmt
RUN curl -sSL https://github.com/mikefarah/yq/releases/download/v4.22.1/yq_linux_amd64 -o /usr/bin/yq && chmod +x /usr/bin/yq

# Install pre-commit using pip
USER gitpod
RUN pip3 install --user pre-commit

# Ensure tools are in PATH
RUN echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc

USER root
