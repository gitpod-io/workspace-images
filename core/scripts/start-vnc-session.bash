#!/bin/bash

###! This script is used on each gitpod dockerimage to configure noVNC
###! Abstract:
###! - 
###! Additional informations:
###! - https://en.wikipedia.org/wiki/Xvfb#Remote_control_over_SSH

DISP=${DISPLAY:1}

# FIXME-QA: Why is this required?
Xvfb -screen $DISP 1920x1080x16 -ac -pn -noreset &

$WINDOW_MANAGER &

VNC_PORT=$(expr 5900 + $DISP)
NOVNC_PORT=$(expr 6080 + $DISP)

x11vnc -localhost -shared -display :$DISP -forever -rfbport ${VNC_PORT} -bg -o "/tmp/x11vnc-${DISP}.log"
cd /opt/novnc/utils && ./launch.sh --vnc "localhost:${VNC_PORT}" --listen "${NOVNC_PORT}" &