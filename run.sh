#!/usr/bin/env bash

WORKSPACE="$PWD"

DOCKER_IMAGE="$1"

docker run -it \
  -e "TERM=xterm-256color" \
  -e "DISPLAY=$DISPLAY" \
  -v "/etc/localtime:/etc/localtime:ro" \
  -v "$WORKSPACE:/src" \
  -v "$HOME:/home/devo_docker" \
  -w "/src" \
  --network host \
  --privileged \
  ${DOCKER_IMAGE}
