FROM gitpod/workspace-full

ENV RETRIGGER=1

ENV BUILDKIT_VERSION=0.9.3
ENV BUILDKIT_FILENAME=buildkit-v${BUILDKIT_VERSION}.linux-amd64.tar.gz

USER root

# Install dazzle, buildkit and pre-commit deps
RUN cd /usr \
    && curl -sSL https://github.com/moby/buildkit/releases/download/v${BUILDKIT_VERSION}/${BUILDKIT_FILENAME} | tar -xvz \
    && curl -sSL https://github.com/gitpod-io/dazzle/releases/download/v0.1.8/dazzle_0.1.8_Linux_x86_64.tar.gz | tar -xvz dazzle \
    && curl -sSL https://github.com/mvdan/sh/releases/download/v3.4.2/shfmt_v3.4.2_linux_amd64 -o /usr/bin/shfmt \
    && chmod +x /usr/bin/shfmt \
    && install-packages shellcheck
