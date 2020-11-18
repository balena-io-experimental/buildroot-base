# buildroot-base examples

before building examples follow the instructions to build base images

[README.md](../README.md)

# build mjpeg-streamer example

```bash
docker build . \
    --build-arg CONFIG=mjpeg-streamer \
    --build-arg TARGET_ARCH=aarch64 \
    -t mjpeg-streamer-example
```

# build unbound-dnscrypt example

```bash
docker build . \
    --build-arg CONFIG=unbound-dnscrypt \
    --build-arg TARGET_ARCH=aarch64 \
    -t unbound-dnscrypt-example
```
