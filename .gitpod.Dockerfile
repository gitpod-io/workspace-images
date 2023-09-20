FROM gitpod/workspace-full:2023-08-08-12-42-30

ENV RETRIGGER=4

ENV BUILDKIT_VERSION=0.12.2
ENV BUILDKIT_FILENAME=buildkit-v${BUILDKIT_VERSION}.linux-amd64.tar.gz
ENV DAZZLE_VERSION=0.1.17

USER root

# Install dazzle, buildkit and pre-commit
RUN curl -sSL https://github.com/moby/buildkit/releases/download/v${BUILDKIT_VERSION}/${BUILDKIT_FILENAME} | tar -xvz -C /usr
RUN curl -sSL https://github.com/gitpod-io/dazzle/releases/download/v${DAZZLE_VERSION}/dazzle_${DAZZLE_VERSION}_Linux_x86_64.tar.gz | tar -xvz -C /usr/local/bin
RUN curl -sSL https://github.com/mvdan/sh/releases/download/v3.5.1/shfmt_v3.5.1_linux_amd64 -o /usr/bin/shfmt \
    && chmod +x /usr/bin/shfmt
RUN install-packages shellcheck \
    && pip3 install pre-commit
RUN curl -sSL https://github.com/mikefarah/yq/releases/download/v4.22.1/yq_linux_amd64 -o /usr/bin/yq && chmod +x /usr/bin/yq
