# buildroot-base

a collection of buildroot base images with the target arch toolchain preinstalled

# build images for your host

```bash
docker build . --build-arg TARGET_ARCH=amd64 -t buildroot-base:amd64
docker build . --build-arg TARGET_ARCH=aarch64 -t buildroot-base:aarch64
docker build . --build-arg TARGET_ARCH=armv6hf -t buildroot-base:armv6hf
docker build . --build-arg TARGET_ARCH=armv7hf -t buildroot-base:armv7hf
docker build . --build-arg TARGET_ARCH=rpi buildroot-base:rpi
```

# build and push multiarch images

```bash
export DOCKER_CLI_EXPERIMENTAL=enabled
docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
docker buildx create --use --driver docker-container

docker buildx build . \
    --platform linux/amd64,linux/arm64 \
    --target buildroot \
    --push -t klutchell/buildroot-base:latest

docker buildx build . \
    --platform linux/amd64,linux/arm64 \
    --build-arg TARGET_ARCH=amd64 \
    --push -t klutchell/buildroot-base:amd64

docker buildx build . \
    --platform linux/amd64,linux/arm64 \
    --build-arg TARGET_ARCH=aarch64 \
    --push -t klutchell/buildroot-base:aarch64

docker buildx build . \
    --platform linux/amd64,linux/arm64 \
    --build-arg TARGET_ARCH=armv6hf \
    --push -t klutchell/buildroot-base:armv6hf

docker buildx build . \
    --platform linux/amd64,linux/arm64 \
    --build-arg TARGET_ARCH=armv7hf \
    --push -t klutchell/buildroot-base:armv7hf

docker buildx build . \
    --platform linux/amd64,linux/arm64 \
    --build-arg TARGET_ARCH=rpi \
    --push -t klutchell/buildroot-base:rpi
```
