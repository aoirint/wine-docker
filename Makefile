# Build Commands
## Stable branch
### Plain Images
.PHONY: build
build:
	docker build --target ubuntu-base \
		-t aoirint/wine:latest \
		.

.PHONY: build-ubuntu
build-ubuntu:
	docker build --target ubuntu-base \
		-t aoirint/wine:ubuntu \
		.

.PHONY: build-ubuntu-win32
build-ubuntu-win32:
	docker build --target ubuntu-base \
		-t aoirint/wine:ubuntu-win32 \
		--build-arg WINEARCH=win32 \
		.

.PHONY: build-nvidia
build-nvidia:
	docker build --target ubuntu-base \
		-t aoirint/wine:nvidia \
		--build-arg BASE_IMAGE=nvidia/opengl:base-ubuntu18.04 \
		.

.PHONY: build-nvidia-win32
build-nvidia-win32:
	docker build --target ubuntu-base \
		-t aoirint/wine:nvidia-win32 \
		--build-arg BASE_IMAGE=nvidia/opengl:base-ubuntu18.04 \
		--build-arg WINEARCH=win32 \
		.

### Python Images
.PHONY: build-ubuntu-py38
build-ubuntu-py38:
	docker build --target python \
		-t aoirint/wine:ubuntu-py38 \
		--build-arg PYTHON_VERSION=3.8.9 \
		.

.PHONY: build-ubuntu-win32-py38
build-ubuntu-win32-py38:
	docker build --target python \
		-t aoirint/wine:ubuntu-win32-py38 \
		--build-arg WINEARCH=win32 \
		--build-arg PYTHON_VERSION=3.8.9 \
		--build-arg PYTHON_ARCH= \
		.

.PHONY: build-nvidia-py38
build-nvidia-py38:
	docker build --target python \
		-t aoirint/wine:nvidia-py38 \
		--build-arg BASE_IMAGE=nvidia/opengl:base-ubuntu18.04 \
		--build-arg PYTHON_VERSION=3.8.9 \
		.

.PHONY: build-nvidia-win32-py38
build-nvidia-win32-py38:
	docker build --target python \
		-t aoirint/wine:nvidia-win32-py38 \
		--build-arg BASE_IMAGE=nvidia/opengl:base-ubuntu18.04
		--build-arg WINEARCH=win32 \
		--build-arg PYTHON_VERSION=3.8.9 \
		--build-arg PYTHON_ARCH= \
		.


## Development branch
.PHONY: build-ubuntu-devel
build-ubuntu-devel:
	docker build --target ubuntu-base \
		-t aoirint/wine:ubuntu-devel \
		--build-arg WINE_BRANCH=devel \
		.

.PHONY: build-ubuntu-devel-win32
build-ubuntu-devel-win32:
	docker build --target ubuntu-base \
		-t aoirint/wine:ubuntu-devel-win32 \
		--build-arg WINE_BRANCH=devel \
		--build-arg WINEARCH=win32 \
		.

.PHONY: build-nvidia-devel
build-nvidia-devel:
	docker build --target ubuntu-base \
		-t aoirint/wine:nvidia-devel \
		--build-arg BASE_IMAGE=nvidia/opengl:base-ubuntu18.04 \
		--build-arg WINE_BRANCH=devel \
		.

.PHONY: build-nvidia-devel-win32
build-nvidia-devel-win32:
	docker build --target ubuntu-base \
		-t aoirint/wine:nvidia-devel-win32 \
		--build-arg BASE_IMAGE=nvidia/opengl:base-ubuntu18.04 \
		--build-arg WINE_BRANCH=devel \
		--build-arg WINEARCH=win32 \
		.

### Python Images
.PHONY: build-ubuntu-devel-py38
build-ubuntu-devel-py38:
	docker build --target python \
		-t aoirint/wine:ubuntu-devel-py38 \
		--build-arg WINE_BRANCH=devel \
		--build-arg PYTHON_VERSION=3.8.9 \
		.

.PHONY: build-ubuntu-devel-win32-py38
build-ubuntu-devel-win32-py38:
	docker build --target python \
		-t aoirint/wine:ubuntu-devel-win32-py38 \
		--build-arg WINE_BRANCH=devel \
		--build-arg WINEARCH=win32 \
		--build-arg PYTHON_VERSION=3.8.9 \
		--build-arg PYTHON_ARCH= \
		.

.PHONY: build-nvidia-devel-py38
build-nvidia-devel-py38:
	docker build --target python \
		-t aoirint/wine:nvidia-devel-py38 \
		--build-arg BASE_IMAGE=nvidia/opengl:base-ubuntu18.04 \
		--build-arg WINE_BRANCH=devel \
		--build-arg PYTHON_VERSION=3.8.9 \
		.

.PHONY: build-nvidia-devel-win32-py38
build-nvidia-devel-win32-py38:
	docker build --target upython \
		-t aoirint/wine:nvidia-devel-win32 \
		--build-arg BASE_IMAGE=nvidia/opengl:base-ubuntu18.04 \
		--build-arg WINE_BRANCH=devel \
		--build-arg WINEARCH=win32 \
		--build-arg PYTHON_VERSION=3.8.9 \
		--build-arg PYTHON_ARCH= \
		.


# Run Commands
## Stable branch
### Plain Images
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

### Python Images
.PHONY: run-ubuntu-py38
run-ubuntu-py38: build-ubuntu-py38
	docker run --rm \
		-e LANG=ja_JP.UTF-8 \
		-e DISPLAY \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		aoirint/wine:ubuntu-py38

.PHONY: run-nvidia-py38
run-nvidia-py38: build-nvidia-py38
	docker run --rm \
		--gpus all \
		-e LANG=ja_JP.UTF-8 \
		-e DISPLAY \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		aoirint/wine:nvidia-py38

## Development branch
.PHONY: run-ubuntu-devel
run-ubuntu-devel: build-ubuntu-devel
	docker run --rm \
		-e LANG=ja_JP.UTF-8 \
		-e DISPLAY \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		aoirint/wine:ubuntu-devel

.PHONY: run-nvidia-devel
run-nvidia-devel: build-nvidia-devel
	docker run --rm \
		--gpus all \
		-e LANG=ja_JP.UTF-8 \
		-e DISPLAY \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		aoirint/wine:nvidia-devel

### Python Images
.PHONY: run-ubuntu-devel-py38
run-ubuntu-devel-py38: build-ubuntu-devel-py38
	docker run --rm \
		-e LANG=ja_JP.UTF-8 \
		-e DISPLAY \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		aoirint/wine:ubuntu-devel-py38

.PHONY: run-nvidia-devel-py38
run-nvidia-devel-py38: build-nvidia-devel-py38
	docker run --rm \
		--gpus all \
		-e LANG=ja_JP.UTF-8 \
		-e DISPLAY \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		aoirint/wine:nvidia-devel-py38
