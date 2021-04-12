.PHONY: build
build:
	docker build . -t aoirint/wine:latest

.PHONY: build-nvidia
build-nvidia:
	docker build . -t aoirint/wine:nvidia --build-arg BASE_IMAGE=nvidia/opengl:base-ubuntu18.04


.PHONY: run
run: build
	docker run --rm \
		-e DISPLAY \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		aoirint/wine:latest

# not working yet
.PHONY: run-nvidia
run-nvidia: build-nvidia
	docker run --rm \
		--gpus all \
		-e DISPLAY \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		aoirint/wine:nvidia

# Use WINEPREFIX=/wine wine python

