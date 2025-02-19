ARG base
FROM ${base}

USER gitpod

# Dazzle does not rebuild a layer until one of its lines are changed. Increase this counter to rebuild this layer.
ENV TRIGGER_REBUILD=1

# Install MongoDB Shell aka MongoSH (was part of Mongo 5, but, is separate now)
RUN mkdir -p /tmp/mongosh && \
    cd /tmp/mongosh && \
    wget -qOmongosh.tgz https://downloads.mongodb.com/compass/mongosh-1.8.0-linux-x64.tgz && \
    tar xf mongosh.tgz && \
    cd mongosh-* && \
    sudo cp bin/* /usr/local/bin/ && \
    rm -rf /tmp/mongosh

# Install MongoDB
# Source: https://docs.mongodb.com/manual/tutorial/install-mongodb-on-ubuntu-tarball/#install-mongodb-community-edition
RUN mkdir -p /tmp/mongodb && \
    cd /tmp/mongodb && \
    wget -qOmongodb.tgz https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-ubuntu2204-6.0.4.tgz && \
    tar xf mongodb.tgz && \
    cd mongodb-* && \
    sudo cp bin/* /usr/local/bin/ && \
    rm -rf /tmp/mongodb && \
    sudo mkdir -p /data/db && \
    sudo chown gitpod:gitpod -R /data/db
