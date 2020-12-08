# buildroot-base

a collection of buildroot base images with the target arch rootfs preinstalled

## stages

This Dockerfile includes 2 stages:

1. `base` - just buildroot dependencies and sources
2. `rootfs` - base plus a pre-compiled rootfs for a specific arch

## build

```bash
# build the base image for your host
docker build . --build-arg BR_VERSION="2020.11" \
    --target base -t buildroot-base

# build an amd64 rootfs image for your host
docker build . --build-arg BR_VERSION="2020.11" \
    --build-arg ROOTFS_ARCH=amd64 -t buildroot-rootfs-amd64
```

## deploy

Requires `docker login` to authenticate with your provided `IMAGE_REPO`.

```bash
# enable qemu for multiarch builds
export DOCKER_CLI_EXPERIMENTAL=enabled
docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
docker buildx create --use --driver docker-container

# select an image repo, buildroot release, and tag
export IMAGE_REPO="docker.io/klutchell"
export BR_VERSION="2020.11"
export IMAGE_TAGS="2020.11 latest"

# this part will take all day to build & cache multiarch images
./deploy.sh

# then push to docker repo
./deploy.sh --push
```

## examples

Before building examples follow the instructions above to build rootfs images.

```bash
# mjpg-streamer
docker build ./app/mjpg-streamer -f app/Dockerfile -t mjpg-streamer

# unbound-dnscrypt
docker build ./app/unbound-dnscrypt -f app/Dockerfile -t unbound-dnscrypt
```
