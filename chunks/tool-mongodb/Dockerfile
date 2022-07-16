ARG base
# hadolint ignore=DL3006
FROM ${base}

USER gitpod

# Dazzle does not rebuild a layer until one of its lines are changed. Increase this counter to rebuild this layer.
ENV TRIGGER_REBUILD=1

# Install MongoDB
# Source: https://docs.mongodb.com/manual/tutorial/install-mongodb-on-ubuntu-tarball/#install-mongodb-community-edition
# hadolint ignore=DL3003
RUN mkdir -p /tmp/mongodb && \
    cd /tmp/mongodb && \
    wget -qOmongodb.tgz https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-ubuntu2004-5.0.2.tgz && \
    tar xf mongodb.tgz && \
    cd mongodb-* && \
    gosu root cp bin/* /usr/local/bin/ && \
    rm -rf /tmp/mongodb && \
    gosu root mkdir -p /data/db && \
    gosu root chown gitpod:gitpod -R /data/db
