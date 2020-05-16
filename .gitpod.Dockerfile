FROM gitpod/workspace-full-vnc
                    
USER gitpod

RUN sudo apt-get -q update && sudo apt-get install -yq cmake && sudo rm -rf /var/lib/apt/lists/*
RUN wget https://www.klayout.org/downloads/Ubuntu-18/klayout_0.26.5-1_amd64.deb && dpkg -i klayout_0.26.5-1_amd64.deb


# Install custom tools, runtime, etc. using apt-get
# For example, the command below would install "bastet" - a command line tetris clone:
#
# RUN sudo apt-get -q update && #     sudo apt-get install -yq bastet && #     sudo rm -rf /var/lib/apt/lists/*
#
# More information: https://www.gitpod.io/docs/config-docker/
