ARG base
FROM ${base}

# Dazzle does not rebuild a layer until one of its lines are changed. Increase this counter to rebuild this layer.
ENV TRIGGER_REBUILD=1

USER root

# Install Desktop-ENV, tools
RUN install-packages \
	tigervnc-standalone-server tigervnc-xorg-extension \
	dbus dbus-x11 gnome-keyring xfce4 xfce4-terminal \
	xdg-utils x11-xserver-utils pip

# Install novnc and numpy module for it
RUN git clone --depth 1 https://github.com/novnc/noVNC.git /opt/novnc \
	&& git clone --depth 1 https://github.com/novnc/websockify /opt/novnc/utils/websockify \
	&& find /opt/novnc -type d -name '.git' -exec rm -rf '{}' + \
	&& sudo -H pip3 install numpy
COPY novnc-index.html /opt/novnc/index.html

# Add VNC startup script
COPY gp-vncsession /usr/bin/
RUN chmod 0755 "$(which gp-vncsession)" \
	&& printf '%s\n' 'export DISPLAY=:0' \
	'test -e "$GITPOD_REPO_ROOT" && gp-vncsession' >> "$HOME/.bashrc"
# Add X11 dotfiles
COPY --chown=gitpod:gitpod .xinitrc $HOME/

USER gitpod
