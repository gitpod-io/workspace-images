FROM gitpod/workspace-full-vnc

# Install the latest rr.
RUN __RR_VERSION__="5.3.0" \
	&& wget -qO /tmp/rr.deb "https://github.com/mozilla/rr/releases/download/${__RR_VERSION__}/rr-${__RR_VERSION__}-Linux-$(uname -m).deb" \
	&& sudo dpkg -i /tmp/rr.deb \
	&& rm -f /tmp/rr.deb

# Install Firefox build dependencies.
# One-line setup command from:
# https://developer.mozilla.org/en-US/docs/Mozilla/Developer_guide/Build_Instructions/Linux_Prerequisites#Most_Distros_-_One_Line_Bootstrap_Command
# FIXME-QA(Krey): Shoudn't we be using `SHELL` instead?
ENV SHELL=/bin/bash
RUN sudo apt-get update \
	&& pyenv global "3.8.2" "2.7.17" \
	&& git clone https://github.com/mozilla/gecko-dev/ /tmp/gecko \
	# FIXME-QA(Krey): Can't we do this without cd?
	&& cd /tmp/gecko \
	&& ./mach bootstrap --no-interactive --application-choice=browser \
	&& sudo rm -rf /tmp/gecko /var/lib/apt/lists/*

# Install git-cinnabar.
RUN git clone https://github.com/glandium/git-cinnabar "$HOME/.git-cinnabar" \
	# FIXME-QA(Krey): Verify that git-cinnabar returns a sane exit code
	&& "$HOME/.git-cinnabar/git-cinnabar" download \
	&& printf '\n#%s\n.' "Add git-cinnabar to the PATH" >> "$HOME/.bashrc" \
	&& printf '%s\n' "PATH=\"\$PATH:\$HOME/.git-cinnabar\"" >> "$HOME/.bashrc"
ENV PATH="$PATH:$HOME/.git-cinnabar"

# Install the latest Phabricator helper.
RUN mkdir "$HOME/.phacility" \
	&& git clone https://github.com/phacility/libphutil "$HOME/.phacility/libphutil" \
	&& git clone https://github.com/phacility/arcanist "$HOME/.phacility/arcanist" \
	&& printf '\n#%s.\n' "Phabricator helper" >> "$HOME/.bashrc" \
	&& printf '%s\n' "PATH=\"\$PATH:\$HOME/.phacility/arcanist/bin\"" >> "$HOME/.bashrc"

# Install Phlay to support uploading multiple commits to Phabricator.
RUN git clone https://github.com/mystor/phlay/ "$HOME/.phlay" \
	&& printf '\n#%s.\n' "Add Phlay to the PATH" >> "$HOME/.bashrc" \
	&& printf '%s\n' "PATH=\"\$PATH:$HOME/.phlay\"" >> "$HOME/.bashrc"

# Also install moz-phab to support uploading multiple commits to Phabricator.
RUN git clone https://github.com/mozilla-conduit/review/ "$HOME/.moz-phab" \
	&& printf '\n#%s.\n' "Add moz-phab to the PATH" >> "$HOME/.bashrc" \
	&& printf "PATH=\"\$PATH:\$HOME/.moz-phab\"" >> "$HOME/.bashrc"
