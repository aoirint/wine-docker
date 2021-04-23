# Build Commands
## Plain Images
.PHONY: build
build:
	docker build --target ubuntu-base -t aoirint/wine:latest .

.PHONY: build-ubuntu
build-ubuntu:
	docker build --target ubuntu-base -t aoirint/wine:ubuntu .

.PHONY: build-nvidia
build-nvidia:
	docker build --target ubuntu-base -t aoirint/wine:nvidia --build-arg BASE_IMAGE=nvidia/opengl:base-ubuntu18.04 .

## Python Images
.PHONY: build-ubuntu-py38
build-ubuntu-py38:
	docker build --target python -t aoirint/wine:ubuntu-py38 --build-arg PYTHON_VERSION=3.8.9 .

.PHONY: build-nvidia-py38
build-nvidia-py38:
	docker build --target python -t aoirint/wine:nvidia-py38 --build-arg BASE_IMAGE=nvidia/opengl:base-ubuntu18.04 --build-arg PYTHON_VERSION=3.8.9 .


# Run Commands
## Plain Images
.PHONY: run
run: build
	docker run --rm \
	        -e LANG=ja_JP.UTF-8 \
		-e DISPLAY \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		aoirint/wine:latest

.PHONY: run-ubuntu
run-ubuntu: build-ubuntu
	docker run --rm \
	        -e LANG=ja_JP.UTF-8 \
		-e DISPLAY \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		aoirint/wine:ubuntu

.PHONY: run-nvidia
run-nvidia: build-nvidia
	docker run --rm \
		--gpus all \
	        -e LANG=ja_JP.UTF-8 \
		-e DISPLAY \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		aoirint/wine:nvidia

## Python Images
.PHONY: run-ubuntu-py38
run-ubuntu-py38: build-ubuntu-py38
	docker run --rm \
	        -e LANG=ja_JP.UTF-8 \
		-e DISPLAY \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		aoirint/wine:ubuntu-py38

.PHONY: run-nvidia
run-nvidia-py38: build-nvidia-py38
	docker run --rm \
		--gpus all \
	        -e LANG=ja_JP.UTF-8 \
		-e DISPLAY \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		aoirint/wine:nvidia-py38

