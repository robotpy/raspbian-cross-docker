
VERSION=$(shell git describe --tags)

.PHONY: image
image: base
	docker build . \
		-t robotpy/raspbian-cross-ubuntu:$(VERSION) \
		--build-arg VERSION=$(VERSION) \
		-f cross.dockerfile

.PHONY: base
base:
	docker build . \
		-t robotpy/raspbian-cross-ubuntu:$(VERSION)-base \
		-f base.dockerfile
