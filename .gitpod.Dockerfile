FROM gitpod/workspace-full

ENV RETRIGGER=1

ENV BUILDKIT_VERSION=0.9.3
ENV BUILDKIT_FILENAME=buildkit-v${BUILDKIT_VERSION}.linux-amd64.tar.gz

# Install custom tools, runtime, etc.
RUN cd /usr \
    && curl -sSL https://github.com/moby/buildkit/releases/download/v${BUILDKIT_VERSION}/${BUILDKIT_FILENAME} | sudo tar -xvz \
    && curl -sSL https://github.com/gitpod-io/dazzle/releases/download/v0.1.8/dazzle_0.1.8_Linux_x86_64.tar.gz | sudo tar -xvz dazzle \
    && sudo install-packages shellcheck
