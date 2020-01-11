FROM gitpod/workspace-full-vnc

# Install the latest rr.
RUN __RR_VERSION__="5.2.0" \
 && cd /tmp \
 && wget -qO rr.deb https://github.com/mozilla/rr/releases/download/${__RR_VERSION__}/rr-${__RR_VERSION__}-Linux-$(uname -m).deb \
 && dpkg -i rr.deb \
 && rm -f rr.deb

USER gitpod

# Install LinuxBrew.
# RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"
# ENV PATH="$PATH:/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin/"
# ENV MANPATH="/home/linuxbrew/.linuxbrew/share/man:$MANPATH"
# ENV INFOPATH="/home/linuxbrew/.linuxbrew/share/info:$INFOPATH"

# Install Firefox build dependencies.
# One-line setup command from:
# https://developer.mozilla.org/en-US/docs/Mozilla/Developer_guide/Build_Instructions/Linux_Prerequisites#Most_Distros_-_One_Line_Bootstrap_Command
ENV SHELL=/bin/bash
RUN sudo apt-get update \
 && git clone https://github.com/mozilla/gecko-dev/ /tmp/gecko \
 && cd /tmp/gecko \
 && python2.7 python/mozboot/bin/bootstrap.py --no-interactive --application-choice=browser \
 && sudo rm -rf /tmp/gecko /var/lib/apt/lists/*

# Install git-cinnabar.
RUN git clone https://github.com/glandium/git-cinnabar $HOME/.git-cinnabar \
 && $HOME/.git-cinnabar/git-cinnabar download \
 && echo "\n# Add git-cinnabar to the PATH." >> $HOME/.bashrc \
 && echo "PATH=\"\$PATH:$HOME/.git-cinnabar\"" >> $HOME/.bashrc
ENV PATH $PATH:$HOME/.git-cinnabar

# Install the latest Phabricator helper.
RUN mkdir $HOME/.phacility \
 && cd $HOME/.phacility \
 && git clone https://github.com/phacility/libphutil \
 && git clone https://github.com/phacility/arcanist \
 && echo "\n# Phabricator helper." >> $HOME/.bashrc \
 && echo "PATH=\"\$PATH:$HOME/.phacility/arcanist/bin\"" >> $HOME/.bashrc

# Install Phlay to support uploading multiple commits to Phabricator.
RUN git clone https://github.com/mystor/phlay/ $HOME/.phlay \
 && echo "\n# Add Phlay to the PATH." >> $HOME/.bashrc \
 && echo "PATH=\"\$PATH:$HOME/.phlay\"" >> $HOME/.bashrc

# Also install moz-phab to support uploading multiple commits to Phabricator.
RUN git clone https://github.com/mozilla-conduit/review/ $HOME/.moz-phab \
 && echo "\n# Add moz-phab to the PATH." >> $HOME/.bashrc \
 && echo "PATH=\"\$PATH:$HOME/.moz-phab\"" >> $HOME/.bashrc
