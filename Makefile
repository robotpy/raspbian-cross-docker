
VERSION=$(shell git describe --tags)

ARCH32=arm32
TARGET_HOST_32=armv6-bullseye-linux-gnueabihf
AC_TARGET_HOST_32=armv7l-bullseye-linux-gnueabihf

ARCH64=aarch64
TARGET_HOST_64=aarch64-bullseye-linux-gnu
AC_TARGET_HOST_64=aarch64-bullseye-linux-gnu

.PHONY: all
all: py38_32 py38_64 py39_32 py39_64 py310_32 py310_64 py311_32 py311_64

#
# Python 3.8
#

.PHONY: py38_32
py38_32: base32
	docker build . \
		-t robotpy/raspbian-cross-ubuntu:$(VERSION)-py38-$(ARCH32) \
		--build-arg ARCH=$(ARCH32) \
		--build-arg TARGET_HOST=$(TARGET_HOST_32) \
		--build-arg AC_TARGET_HOST=$(AC_TARGET_HOST_32) \
		--build-arg VERSION=$(VERSION) \
		-f py38.dockerfile

.PHONY: py38_64
py38_64: base64
	docker build . \
		-t robotpy/raspbian-cross-ubuntu:$(VERSION)-py38-$(ARCH64) \
		--build-arg ARCH=$(ARCH64) \
		--build-arg TARGET_HOST=$(TARGET_HOST_64) \
		--build-arg AC_TARGET_HOST=$(AC_TARGET_HOST_64) \
		--build-arg VERSION=$(VERSION) \
		-f py38.dockerfile

#
# Python 3.9
#

.PHONY: py39_32
py39_32: base32
	docker build . \
		-t robotpy/raspbian-cross-ubuntu:$(VERSION)-py39-$(ARCH32) \
		--build-arg ARCH=$(ARCH32) \
		--build-arg TARGET_HOST=$(TARGET_HOST_32) \
		--build-arg AC_TARGET_HOST=$(AC_TARGET_HOST_32) \
		--build-arg VERSION=$(VERSION) \
		-f py39.dockerfile

.PHONY: py39_64
py39_64: base64
	docker build . \
		-t robotpy/raspbian-cross-ubuntu:$(VERSION)-py39-$(ARCH64) \
		--build-arg ARCH=$(ARCH64) \
		--build-arg TARGET_HOST=$(TARGET_HOST_64) \
		--build-arg AC_TARGET_HOST=$(AC_TARGET_HOST_64) \
		--build-arg VERSION=$(VERSION) \
		-f py39.dockerfile

#
# Python 3.10
#

.PHONY: py310_32
py310_32: base32
	docker build . \
		-t robotpy/raspbian-cross-ubuntu:$(VERSION)-py310-$(ARCH32) \
		--build-arg ARCH=$(ARCH32) \
		--build-arg TARGET_HOST=$(TARGET_HOST_32) \
		--build-arg AC_TARGET_HOST=$(AC_TARGET_HOST_32) \
		--build-arg VERSION=$(VERSION) \
		-f py310.dockerfile

.PHONY: py310_64
py310_64: base64
	docker build . \
		-t robotpy/raspbian-cross-ubuntu:$(VERSION)-py310-$(ARCH64) \
		--build-arg ARCH=$(ARCH64) \
		--build-arg TARGET_HOST=$(TARGET_HOST_64) \
		--build-arg AC_TARGET_HOST=$(AC_TARGET_HOST_64) \
		--build-arg VERSION=$(VERSION) \
		-f py310.dockerfile

#
# Python 3.11
#

.PHONY: py311_32
py311_32: base32
	docker build . \
		-t robotpy/raspbian-cross-ubuntu:$(VERSION)-py311-$(ARCH32) \
		--build-arg ARCH=$(ARCH32) \
		--build-arg TARGET_HOST=$(TARGET_HOST_32) \
		--build-arg AC_TARGET_HOST=$(AC_TARGET_HOST_32) \
		--build-arg VERSION=$(VERSION) \
		-f py311.dockerfile

.PHONY: py311_64
py311_64: base64
	docker build . \
		-t robotpy/raspbian-cross-ubuntu:$(VERSION)-py311-$(ARCH64) \
		--build-arg ARCH=$(ARCH64) \
		--build-arg TARGET_HOST=$(TARGET_HOST_64) \
		--build-arg AC_TARGET_HOST=$(AC_TARGET_HOST_64) \
		--build-arg VERSION=$(VERSION) \
		-f py311.dockerfile

#
# Base images
#

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

.PHONY: push
push:
	docker push robotpy/raspbian-cross-ubuntu:$(VERSION)-py38-$(ARCH32)
	docker push robotpy/raspbian-cross-ubuntu:$(VERSION)-py38-$(ARCH64)

	docker push robotpy/raspbian-cross-ubuntu:$(VERSION)-py39-$(ARCH32)
	docker push robotpy/raspbian-cross-ubuntu:$(VERSION)-py39-$(ARCH64)

	docker push robotpy/raspbian-cross-ubuntu:$(VERSION)-py310-$(ARCH32)
	docker push robotpy/raspbian-cross-ubuntu:$(VERSION)-py310-$(ARCH64)

	docker push robotpy/raspbian-cross-ubuntu:$(VERSION)-py311-$(ARCH32)
	docker push robotpy/raspbian-cross-ubuntu:$(VERSION)-py311-$(ARCH64)
