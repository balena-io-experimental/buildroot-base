# buildroot-base

a collection of buildroot base images with the target arch rootfs preinstalled

## stages

This Dockerfile includes 2 stages:

1. `base` - just buildroot dependencies and sources
2. `rootfs` - base plus a pre-compiled rootfs for a specific arch

## build

### build the base image for your host

```bash
docker build . --target base -t buildroot-base
```

### build the rootfs images for your host

```bash
docker build . --build-arg TARGET_ARCH=amd64    -t buildroot-rootfs-amd64
docker build . --build-arg TARGET_ARCH=aarch64  -t buildroot-rootfs-aarch64
docker build . --build-arg TARGET_ARCH=armv6hf  -t buildroot-rootfs-armv6hf
docker build . --build-arg TARGET_ARCH=armv7hf  -t buildroot-rootfs-armv7hf
docker build . --build-arg TARGET_ARCH=rpi      -t buildroot-rootfs-rpi
```

## push

### setup qemu and buildx for emulated builds

```bash
export DOCKER_CLI_EXPERIMENTAL=enabled
docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
docker buildx create --use --driver docker-container
```

### build and push the multiarch base image

```bash
docker buildx build . \
    --platform linux/amd64,linux/arm64 \
    --build-arg BR_VERSION=2020.08.2 \
    --target base \
    -t klutchell/buildroot-base:2020.08.2 \
    -t klutchell/buildroot-base:latest \
    --push
```

### build and push multiarch rootfs images

Requires `docker login` to authenticate with your provided `IMAGE_REPO`.
Go do something else, this will take all day.

```bash
export IMAGE_REPO="docker.io/klutchell"
export BR_VERSION="2020.08.2"
./deploy.sh
```

## examples

See [examples/Dockerfile](./examples/Dockerfile) for a minimal rootfs with package(s)
from a config file.

Before building examples follow the instructions above to build rootfs images.

### mjpg-streamer

```bash
docker build ./examples \
    --build-arg CONFIG=mjpg-streamer \
    --build-arg TARGET_ARCH=aarch64 \
    --build-arg BR_VERSION=2020.08.2 \
    -t mjpg-streamer-example
```

### unbound-dnscrypt

```bash
docker build ./examples \
    --build-arg CONFIG=unbound-dnscrypt \
    --build-arg TARGET_ARCH=aarch64 \
    --build-arg BR_VERSION=2020.08.2 \
    -t unbound-dnscrypt-example
```