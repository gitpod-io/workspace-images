ARG BASE_IMAGE=devfactory/workspace-full
FROM $BASE_IMAGE

# Install MongoDB
# Source: https://docs.mongodb.com/manual/tutorial/install-mongodb-on-ubuntu-tarball/#install-mongodb-community-edition
RUN /bin/bash -c 'mkdir -p /tmp/mongodb && \
    cd /tmp/mongodb && \
    ARCH=`uname -m` && \
    if [ "$ARCH" == "x86_64" ]; then \
        wget -qOmongodb.tgz https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-ubuntu2004-4.4.6.tgz; \
    else \
        wget -qOmongodb.tgz https://fastdl.mongodb.org/linux/mongodb-linux-aarch64-ubuntu2004-4.4.6.tgz; \
    fi && \
    tar xf mongodb.tgz && \
    cd mongodb-* && \
    sudo cp bin/* /usr/local/bin/ && \
    rm -rf /tmp/mongodb && \
    sudo mkdir -p /data/db && \
    sudo chown gitpod:gitpod -R /data/db'
