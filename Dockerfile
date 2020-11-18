# create our own buildroot image based on
# https://hub.docker.com/r/buildroot/base

FROM debian:buster as buildroot

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

ARG BR_VERSION=2020.08.2

ARG TARGET_ARCH=aarch64

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN wget -q -O- https://buildroot.org/downloads/buildroot-$BR_VERSION.tar.gz | tar xz --strip 1

COPY config.$TARGET_ARCH .config 

RUN make olddefconfig && make toolchain
