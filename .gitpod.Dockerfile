FROM gitpod/workspace-full

ENV BUILDKIT_VERSION=0.9.0
ENV BUILDKIT_FILENAME=buildkit-v${BUILDKIT_VERSION}.linux-amd64.tar.gz

# Install custom tools, runtime, etc.
RUN curl -OL https://github.com/moby/buildkit/releases/download/v${BUILDKIT_VERSION}/${BUILDKIT_FILENAME} \
    && tar xzfv ${BUILDKIT_FILENAME} \
    && rm ${BUILDKIT_FILENAME} \
    && sudo mv bin/* /usr/bin
