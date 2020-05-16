FROM gitpod/workspace-full-vnc
                    
USER gitpod

RUN sudo apt-get -q update && sudo apt-get install -yq cmake pip
# RUN sudo apt-get install -yq sudo apt install libqt4-designer libqt4-opengl libqt4-svg libqtgui4 libruby2.5 libpython3.6 
RUN sudo rm -rf /var/lib/apt/lists/*
RUN sudo wget https://www.klayout.org/downloads/Ubuntu-18/klayout_0.26.5-1_amd64.deb && sudo dpkg -i klayout_0.26.5-1_amd64.deb


# Install custom tools, runtime, etc. using apt-get
# For example, the command below would install "bastet" - a command line tetris clone:
#
# RUN sudo apt-get -q update && #     sudo apt-get install -yq bastet && #     sudo rm -rf /var/lib/apt/lists/*
#
# More information: https://www.gitpod.io/docs/config-docker/
