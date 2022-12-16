
VERSION=$(shell git describe --tags)

.PHONY: all
all: image32 image64

.PHONY: image32
image32: base32
	docker build . \
		-t robotpy/raspbian-cross-ubuntu:$(VERSION)-arm32 \
		--build-arg VERSION=$(VERSION) \
		-f arm32-cross.dockerfile

.PHONY: image64
image64: base64
	docker build . \
		-t robotpy/raspbian-cross-ubuntu:$(VERSION)-aarch64 \
		--build-arg VERSION=$(VERSION) \
		-f aarch64-cross.dockerfile

.PHONY: base32
base32:
	docker build . \
		-t robotpy/raspbian-cross-ubuntu:$(VERSION)-base-arm32 \
		-f arm32-base.dockerfile

.PHONY: base64
base64:
	docker build . \
		-t robotpy/raspbian-cross-ubuntu:$(VERSION)-base-aarch64 \
		-f aarch64-base.dockerfile