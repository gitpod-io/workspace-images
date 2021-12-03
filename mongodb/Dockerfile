FROM gitpod/workspace-full

# Install MongoDB
# Source: https://docs.mongodb.com/manual/tutorial/install-mongodb-on-ubuntu-tarball/#install-mongodb-community-edition
RUN mkdir -p /tmp/mongodb && \
    cd /tmp/mongodb && \
    wget -qOmongodb.tgz https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-ubuntu2004-5.0.2.tgz && \
    tar xf mongodb.tgz && \
    cd mongodb-* && \
    sudo cp bin/* /usr/local/bin/ && \
    rm -rf /tmp/mongodb && \
    sudo mkdir -p /data/db && \
    sudo chown gitpod:gitpod -R /data/db

RUN wget -q https://fastdl.mongodb.org/tools/db/mongodb-database-tools-ubuntu1804-x86_64-100.5.1.deb
RUN sudo apt-get -qq install ./mongodb-database-tools-*-100.5.1.deb

RUN wget -q https://downloads.mongodb.com/compass/mongodb-mongosh_1.1.6_amd64.deb
RUN sudo apt-get -qq install ./mongodb-mongosh_1.1.6_amd64.deb

RUN rm -fr mongodb-*
