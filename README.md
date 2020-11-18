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
docker build . --build-arg TARGET_ARCH=amd64    -t buildroot-base:amd64-rootfs
docker build . --build-arg TARGET_ARCH=aarch64  -t buildroot-base:aarch64-rootfs
docker build . --build-arg TARGET_ARCH=armv6hf  -t buildroot-base:armv6hf-rootfs
docker build . --build-arg TARGET_ARCH=armv7hf  -t buildroot-base:armv7hf-rootfs
docker build . --build-arg TARGET_ARCH=rpi      -t buildroot-base:rpi-rootfs
```

## push

```bash
# setup qemu and buildx for emulated builds
export DOCKER_CLI_EXPERIMENTAL=enabled
docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
docker buildx create --use --driver docker-container

# build and push multiarch base image
docker buildx build . \
    --platform linux/amd64,linux/arm64 \
    --target base \
    --push -t klutchell/buildroot-base:latest

# build and push multiarch rootfs images
# go get a coffee, these could take hours
docker buildx build . \
    --platform linux/amd64,linux/arm64 \
    --build-arg TARGET_ARCH=amd64 \
    --push -t klutchell/buildroot-base:amd64-rootfs

docker buildx build . \
    --platform linux/amd64,linux/arm64 \
    --build-arg TARGET_ARCH=aarch64 \
    --push -t klutchell/buildroot-base:aarch64-rootfs

docker buildx build . \
    --platform linux/amd64,linux/arm64 \
    --build-arg TARGET_ARCH=armv6hf \
    --push -t klutchell/buildroot-base:armv6hf-rootfs

docker buildx build . \
    --platform linux/amd64,linux/arm64 \
    --build-arg TARGET_ARCH=armv7hf \
    --push -t klutchell/buildroot-base:armv7hf-rootfs

docker buildx build . \
    --platform linux/amd64,linux/arm64 \
    --build-arg TARGET_ARCH=rpi \
    --push -t klutchell/buildroot-base:rpi-rootfs
```

## examples

See [examples/Dockerfile](./examples/Dockerfile) for a minimal rootfs with package(s)
from a config file.

Before building examples follow the instructions above to build rootfs images.

### mjpeg-streamer

```bash
docker build ./examples \
    --build-arg CONFIG=mjpeg-streamer \
    --build-arg TARGET_ARCH=aarch64 \
    -t mjpeg-streamer-example
```

### unbound-dnscrypt

```bash
docker build ./examples \
    --build-arg CONFIG=unbound-dnscrypt \
    --build-arg TARGET_ARCH=aarch64 \
    -t unbound-dnscrypt-example
```