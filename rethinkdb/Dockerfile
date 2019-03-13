FROM gitpod/workspace-full

# Install RethinkDB build dependencies.
# Source: https://rethinkdb.com/docs/install/ubuntu/#compile-from-source
RUN sudo apt-get update \
 && sudo apt-get install -y \
  protobuf-compiler \
  libprotobuf-dev \
  libboost-all-dev \
  libncurses5-dev \
  libjemalloc-dev \
  libssl1.0-dev \
 && sudo rm -rf /var/lib/apt/lists/*

# Build and install RethinkDB from source.
RUN mkdir -p /tmp/rethinkdb \
 && cd /tmp/rethinkdb \
 && wget -qOrethinkdb.tgz https://download.rethinkdb.com/dist/rethinkdb-2.3.6.tgz \
 && tar xf rethinkdb.tgz \
 && cd rethinkdb-* \
 && ./configure --allow-fetch CXX=clang++-9 \
 && make -j`nproc` \
 && sudo make install \
 && sudo rm -rf /tmp/rethinkdb
