build:
  docker build . -t aoirint/wine:latest

build-nvidia:
  docker build . -t aoirint/wine:nvidia --build-arg BASE_IMAGE=nvidia/opengl:base-ubuntu18.04

run: build
  docker run --rm \
    -e "HOST_UID=$(shell id -u)" \
    -e "HOST_GID=$(shell id -g)" \
    -e DISPLAY \
    -e "WINEPREFIX=/wine" \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v "${PWD}/wine:/wine" \
    aoirint/wine:latest

# not working yet
run-nvidia: build-nvidia
  docker run --rm \
    --gpus all \
    -e "HOST_UID=$(shell id -u)" \
    -e "HOST_GID=$(shell id -g)" \
    -e DISPLAY \
    -e "WINEPREFIX=/wine" \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v "${PWD}/wine:/wine" \
    aoirint/wine:nvidia
