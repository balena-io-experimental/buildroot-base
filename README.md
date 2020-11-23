# buildroot-base

a collection of buildroot base images with the target arch rootfs preinstalled

## stages

This Dockerfile includes 2 stages:

1. `base` - just buildroot dependencies and sources
2. `rootfs` - base plus a pre-compiled rootfs for a specific arch

## build

```bash
# build the base image for your host
docker build . --target base -t buildroot-base

# build the rootfs images for your host
docker build . \
    --build-arg TARGET_ARCH=amd64 \
    --build-arg BR_VERSION=2020.08.2 \
    -t buildroot-rootfs-amd64

docker build . \
    --build-arg TARGET_ARCH=aarch64 \
    --build-arg BR_VERSION=2020.08.2 \
    -t buildroot-rootfs-aarch64

docker build . \
    --build-arg TARGET_ARCH=armv7hf \
    --build-arg BR_VERSION=2020.08.2 \
    -t buildroot-rootfs-armv7hf

docker build . \
    --build-arg TARGET_ARCH=armv6hf \
    --build-arg BR_VERSION=2020.08.2 \
    -t buildroot-rootfs-armv6hf

docker build . \
    --build-arg TARGET_ARCH=rpi \
    --build-arg BR_VERSION=2020.08.2 \
    -t buildroot-rootfs-rpi
```

## push

Requires `docker login` to authenticate with your provided `IMAGE_REPO`.

```bash
# enable qemu for multiarch builds
export DOCKER_CLI_EXPERIMENTAL=enabled
docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
docker buildx create --use --driver docker-container

# this part will take all day
export IMAGE_REPO="docker.io/klutchell"
export BR_VERSION="2020.08.2"
./deploy.sh
```

## examples

Before building examples follow the instructions above to build rootfs images.

```bash
# mjpg-streamer
docker build ./examples/mjpg-streamer -t mjpg-streamer-example

# unbound-dnscrypt
docker build ./examples/unbound-dnscrypt -t unbound-dnscrypt-example
```
