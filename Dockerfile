#syntax=docker/dockerfile:1.2

# create a multiarch buildroot image based on
# https://hub.docker.com/r/buildroot/base

FROM debian:bullseye as base

# hadolint ignore=DL3008
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        bc \
        build-essential \
        ca-certificates \
        cmake \
        cpio \
        file \
        locales \
        python3 \
        rsync \
        unzip \
        wget && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN sed -i 's/# \(en_US.UTF-8\)/\1/' /etc/locale.gen && \
    /usr/sbin/locale-gen

RUN useradd -ms /bin/bash br-user && \
    chown -R br-user:br-user /home/br-user

USER br-user

WORKDIR /home/br-user

ENV LC_ALL=en_US.UTF-8

ARG BR_VERSION=2020.11

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN wget -q -O- https://buildroot.org/downloads/buildroot-$BR_VERSION.tar.gz | tar xz --strip 1

FROM base as rootfs

ARG ROOTFS_ARCH=aarch64
ARG LIBC=musl

COPY config/common.cfg \
     config/arch/$ROOTFS_ARCH.cfg \
     config/libc/$LIBC.cfg ./

RUN support/kconfig/merge_config.sh -m common.cfg $ROOTFS_ARCH.cfg $LIBC.cfg

RUN --mount=type=cache,target=/cache,uid=1000,gid=1000,sharing=private \
    make olddefconfig \
    && make
