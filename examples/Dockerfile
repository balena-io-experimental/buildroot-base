ARG TARGET_ARCH=aarch64

FROM buildroot-base:$TARGET_ARCH-rootfs as buildroot

ARG CONFIG=mjpeg-streamer

COPY config.$CONFIG ./

RUN cat config.$CONFIG >> .config

RUN make olddefconfig && make

# hadolint ignore=DL3002
USER root

RUN mkdir rootfs && \
    tar xpf output/images/rootfs.tar -C rootfs

FROM scratch

COPY --from=buildroot /home/br-user/rootfs/ /
