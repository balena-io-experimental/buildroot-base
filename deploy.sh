#!/bin/sh

set -e

[ -n "${IMAGE_REPO}" ] || IMAGE_REPO="docker.io/klutchell"
[ -n "${BR_VERSION}" ] || BR_VERSION="2020.11"
[ -n "${IMAGE_TAGS}" ] || IMAGE_TAGS="${BR_VERSION}"

image_tags() {
    for tag in ${IMAGE_TAGS}
    do
        echo " -t $1:$tag"
    done
}

# shellcheck disable=SC2046
docker buildx build . --platform "linux/amd64,linux/arm64,linux/arm/v7,linux/arm/v6" \
    --build-arg BR_VERSION --target base \
    $(image_tags ${IMAGE_REPO}/buildroot-base) "$@"

# shellcheck disable=SC2046
docker buildx build . --platform "linux/amd64" \
    --build-arg BR_VERSION --build-arg "TARGET_ARCH=amd64" \
    $(image_tags ${IMAGE_REPO}/buildroot-rootfs-amd64) "$@"

# shellcheck disable=SC2046
docker buildx build . --platform "linux/amd64,linux/arm64" \
    --build-arg BR_VERSION --build-arg "TARGET_ARCH=aarch64" \
    $(image_tags ${IMAGE_REPO}/buildroot-rootfs-aarch64) "$@"

# shellcheck disable=SC2046
docker buildx build . --platform "linux/amd64,linux/arm64" \
    --build-arg BR_VERSION --build-arg "TARGET_ARCH=armv7hf" \
    $(image_tags ${IMAGE_REPO}/buildroot-rootfs-armv7hf) "$@"

# shellcheck disable=SC2046
docker buildx build . --platform "linux/amd64,linux/arm64" \
    --build-arg BR_VERSION --build-arg "TARGET_ARCH=armv6hf" \
    $(image_tags ${IMAGE_REPO}/buildroot-rootfs-rpi) \
    $(image_tags ${IMAGE_REPO}/buildroot-rootfs-armv6hf) "$@"

# docker buildx build . --platform "linux/amd64,linux/arm64" \
#     --build-arg BR_VERSION --build-arg "TARGET_ARCH=rpi" \
#     -t ${IMAGE_REPO}/buildroot-rootfs-rpi:${IMAGE_TAG} "$@"
