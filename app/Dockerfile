#syntax=docker/dockerfile:1.2
ARG IMAGE=buildroot-rootfs-amd64
# hadolint ignore=DL3006
FROM $IMAGE as buildroot

COPY . .
RUN support/kconfig/merge_config.sh -m .config config.pkg

RUN --mount=type=cache,target=/cache/,uid=1000,gid=1000 \
    make olddefconfig \
    && make

# hadolint ignore=DL3002
USER root

RUN mkdir rootfs && \
    tar xpf output/images/rootfs.tar -C rootfs

FROM scratch

COPY --from=buildroot /home/br-user/rootfs/ /
