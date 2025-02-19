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
COPY gp-vncsession /usr/bin/

# Add VNC startup script
COPY <<-"EOF" /home/gitpod/.bashrc.d/500-vnc
export DISPLAY=:0
test -e "$GITPOD_REPO_ROOT" && gp-vncsession
EOF

RUN chmod 0755 "$(which gp-vncsession)"

# Add X11 dotfiles
COPY --chown=gitpod:gitpod .xinitrc $HOME/

USER gitpod
