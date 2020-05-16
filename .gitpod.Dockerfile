FROM gitpod/workspace-full-vnc
                    
USER gitpod

RUN cat /etc/os-release
RUN sudo apt-get -yq update && sudo apt-get install -yq cmake klayout
# RUN sudo pip install conan
RUN sudo rm -rf /var/lib/apt/lists/*


# Install custom tools, runtime, etc. using apt-get
# For example, the command below would install "bastet" - a command line tetris clone:
#
# RUN sudo apt-get -q update && #     sudo apt-get install -yq bastet && #     sudo rm -rf /var/lib/apt/lists/*
#
# More information: https://www.gitpod.io/docs/config-docker/
