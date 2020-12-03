# buildroot-base

a collection of buildroot base images with the target arch rootfs preinstalled

## stages

This Dockerfile includes 2 stages:

1. `base` - just buildroot dependencies and sources
2. `rootfs` - base plus a pre-compiled rootfs for a specific arch

## build

```bash
# select a buildroot release
export BR_VERSION=2020.08.2

# build the base image for your host
docker build . --build-arg BR_VERSION \
    --target base -t buildroot-base

# build the rootfs images for your host
docker build . --build-arg BR_VERSION \
    --build-arg TARGET_ARCH=amd64 \
    -t buildroot-rootfs-amd64:${BR_VERSION}

docker build . --build-arg BR_VERSION \
    --build-arg TARGET_ARCH=aarch64 \
    -t buildroot-rootfs-aarch64:${BR_VERSION}

docker build . --build-arg BR_VERSION \
    --build-arg TARGET_ARCH=armv7hf \
    -t buildroot-rootfs-armv7hf:${BR_VERSION}

docker build . --build-arg BR_VERSION \
    --build-arg TARGET_ARCH=armv6hf \
    -t buildroot-rootfs-armv6hf:${BR_VERSION}

docker build . --build-arg BR_VERSION \
    --build-arg TARGET_ARCH=rpi \
    -t buildroot-rootfs-rpi:${BR_VERSION}
```

## push

Requires `docker login` to authenticate with your provided `IMAGE_REPO`.

```bash
# enable qemu for multiarch builds
export DOCKER_CLI_EXPERIMENTAL=enabled
docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
docker buildx create --use --driver docker-container

# select an image repo, buildroot release, and tag
export IMAGE_REPO="docker.io/klutchell"
export BR_VERSION="2020.08.2"
export IMAGE_TAG="2020.08.2" # or 'latest'

# this part will take all day
./deploy.sh
```

## examples

Before building examples follow the instructions above to build rootfs images.

```bash
# mjpg-streamer
docker build ./app/mjpg-streamer -f app/Dockerfile -t mjpg-streamer

# unbound-dnscrypt
docker build ./app/unbound-dnscrypt -f app/Dockerfile -t unbound-dnscrypt
```
