FROM gitpod/workspace-full-vnc
                    
USER gitpod

RUN cat /etc/os-release
RUN sudo apt-get -q update && sudo apt-get install -yq cmake
# RUN sudo pip install conan
RUN sudo apt-get install -yq sudo apt install gcc g++ make
RUN sudo apt-get install -yq sudo apt isntall libqt4-dev-bin libqt4-dev ruby ruby-dev python3 python3-dev libz-dev
# RUN sudo rm -rf /var/lib/apt/lists/*
RUN sudo wget https://www.klayout.org/downloads/Ubuntu-18/klayout_0.26.5-1_amd64.deb && sudo dpkg -i klayout_0.26.5-1_amd64.deb


# Install custom tools, runtime, etc. using apt-get
# For example, the command below would install "bastet" - a command line tetris clone:
#
# RUN sudo apt-get -q update && #     sudo apt-get install -yq bastet && #     sudo rm -rf /var/lib/apt/lists/*
#
# More information: https://www.gitpod.io/docs/config-docker/
