#!/bin/bash

if [[ $# < 1 || ! $1 ]]; then
    echo "Usage: $0 DISPLAY"
    exit 1
fi

DISP=$1

Xvfb -screen $DISP 1920x1080x16 -ac &

VNC_PORT=$(expr 5900 + $DISP)
NOVNC_PORT=$(expr 6080 + $DISP)

x11vnc -localhost -display :$DISP -forever -rfbport ${VNC_PORT} &> "/tmp/x11vnc-${DISP}.log" &
cd /opt/novnc/utils && ./launch.sh --vnc "localhost:${VNC_PORT}" --listen "${NOVNC_PORT}" &
