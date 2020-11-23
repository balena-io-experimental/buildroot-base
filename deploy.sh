#!/bin/sh

set -eu

IMAGE_REPO=${IMAGE_REPO:-"docker.io/klutchell"}
BR_VERSION=${BR_VERSION:-"2020.08.2"}
HOST_ARCH=${HOST_ARCH:-"linux/amd64,linux/arm64"}
TARGET_ARCH=${TARGET_ARCH:-"amd64 aarch64 armv7hf armv6hf rpi"}

for arch in ${TARGET_ARCH}
do
    docker buildx build . \
        --platform "${HOST_ARCH}" \
        --build-arg "BR_VERSION=${BR_VERSION}" \
        --build-arg "TARGET_ARCH=${arch}" \
        -t ${IMAGE_REPO}/buildroot-rootfs-${arch}:${BR_VERSION} \
        -t ${IMAGE_REPO}/buildroot-rootfs-${arch}:latest \
        --push 
done
