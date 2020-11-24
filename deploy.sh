#!/bin/sh

set -e

[ -n "${IMAGE_REPO}" ] || IMAGE_REPO="docker.io/klutchell"
[ -n "${BR_VERSION}" ] || BR_VERSION="2020.08.2"
[ -n "${IMAGE_TAG}" ] || IMAGE_TAG="${BR_VERSION}"
[ -n "${HOST_ARCH}" ] || HOST_ARCH="linux/amd64,linux/arm64"
[ -n "${TARGET_ARCH}" ] || TARGET_ARCH="amd64 aarch64 armv7hf armv6hf rpi"

docker buildx build . --platform "${HOST_ARCH}" --build-arg BR_VERSION \
    --target base \
    -t ${IMAGE_REPO}/buildroot-base:${IMAGE_TAG} \
    --push

for arch in ${TARGET_ARCH}
do
    docker buildx build . --platform "${HOST_ARCH}" --build-arg BR_VERSION \
        --build-arg "TARGET_ARCH=${arch}" \
        -t ${IMAGE_REPO}/buildroot-rootfs-${arch}:${IMAGE_TAG} \
        --push 
done
