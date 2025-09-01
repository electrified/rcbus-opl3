#!/bin/sh
export USER_ID=$(id -u)
export GROUP_ID=$(id -g)
docker run --rm -it \
    --user $USER_ID:$GROUP_ID \
    --env NO_AT_BRIDGE=1 \
    --env DISPLAY=$DISPLAY \
    --env HOME=$HOME \
    --workdir=$HOME \
    --volume=/tmp/.X11-unix:/tmp/.X11-unix \
    --volume="/etc/group:/etc/group:ro" \
    --volume="$HOME:$HOME:rw" \
    --volume="/etc/passwd:/etc/passwd:ro" \
    --volume="/etc/shadow:/etc/shadow:ro" \
    ghcr.io/inti-cmnb/kicad9_auto_full:latest /bin/bash
