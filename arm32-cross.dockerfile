
ARG VERSION=invalid-version
FROM robotpy/raspbian-cross-ubuntu:${VERSION}-base-arm32 AS pycompile

ENV TARGET_HOST="armv6-bullseye-linux-gnueabihf"
ENV AC_TARGET_HOST="armv7l-bullseye-linux-gnueabihf"
ENV BUILD_HOST="x86_64"
ENV WORKING_DIRECTORY="/build"
ENV INSTALL_DIRECTORY="/build/crosspy"
ENV PYTHON_VERSION="3.9.16"
ENV SOURCE_DIRECTORY="Python-$PYTHON_VERSION"
ENV PYTHON_ARCHIVE="Python-$PYTHON_VERSION.tar.xz"
ENV PREFIX="$INSTALL_DIRECTORY"

#
# Python compilation prereqs
#

RUN set -xe; \
    apt-get update; \
    apt-get install -y build-essential checkinstall g++ libreadline-dev libncursesw5-dev libssl-dev \
        libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev liblzma-dev lzma-dev libffi-dev zlib1g-dev; \
    # cleanup
    rm -rf /var/lib/apt/lists/*

#
# Python cross-compilation
#

COPY 0001-bpo-41916-allow-cross-compiled-python-to-have-pthrea.patch /
COPY 0001-Use-specified-host_cpu-when-cross-compiling-for-Linu.patch /

RUN set -xe; \
    mkdir -p "$PREFIX"; \
    # Download
    cd $WORKING_DIRECTORY; \
    wget -c https://www.python.org/ftp/python/$PYTHON_VERSION/$PYTHON_ARCHIVE; \
    rm -rf $SOURCE_DIRECTORY; \
    tar -xf $PYTHON_ARCHIVE; \
    cd $SOURCE_DIRECTORY; \
    # patch -pthread CXX issue
    patch -p1 < /0001-bpo-41916-allow-cross-compiled-python-to-have-pthrea.patch; \
    # patch arm cpu hardcoding
    patch -p1 < /0001-Use-specified-host_cpu-when-cross-compiling-for-Linu.patch; \
    # Build python for host
    cd $WORKING_DIRECTORY;cd $SOURCE_DIRECTORY; \
    ./configure --enable-optimizations --with-ensurepip=install; \
    make -j8 altinstall; \
    # cross-compile for raspbian
    cd $WORKING_DIRECTORY;cd $SOURCE_DIRECTORY; make distclean; \
    ./configure --host=$TARGET_HOST --build=$BUILD_HOST --prefix=$PREFIX \
        --disable-ipv6 --enable-unicode=ucs4 \
        ac_cv_host=$AC_TARGET_HOST \
        ac_cv_buggy_getaddrinfo=no \
        ac_cv_file__dev_ptmx=no ac_cv_file__dev_ptc=no \
        ac_cv_have_long_long_format=yes \
        ac_cv_pthread_is_default=no ac_cv_pthread=yes ac_cv_cxx_thread=yes; \
    make -j8; \
    # make install here is fine because we include --prefix in the configure statement
    make install
    

#
# Minimal cross-compilation environment
#

FROM robotpy/raspbian-cross-ubuntu:${VERSION}-base-arm32 AS crossenv

RUN set -xe; \
    apt-get update; \
    apt-get install -y \
        binutils libreadline8 libncursesw5 libssl3 \
        libsqlite3-0 libgdbm6 libbz2-1.0 liblzma5 libffi7 zlib1g; \
    rm -rf /var/lib/apt/lists/*

COPY --from=pycompile /usr/local /usr/local
COPY --from=pycompile /build/crosspy /build/crosspy

RUN set -xe; \
    ldconfig; \
    python3.9 -m pip install crossenv; \
    python3.9 -m crossenv /build/crosspy/bin/python3.9 /build/venv --sysroot=$(armv6-bullseye-linux-gnueabihf-gcc -print-sysroot) --env UNIXCONFDIR=/build/venv/cross/etc; \
    /build/venv/bin/build-pip install 'setuptools==63.4.3'; \
    /build/venv/bin/cross-pip install wheel 'setuptools==63.4.3';

COPY pip.conf /build/venv/cross/pip.conf
COPY os-release /build/venv/cross/etc/os-release

ENV RPYBUILD_PARALLEL=1

