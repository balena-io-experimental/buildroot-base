FROM buildroot-rootfs-aarch64:2020.08.2 as buildroot

COPY config.pkg ./

RUN support/kconfig/merge_config.sh -m .config config.pkg

RUN make olddefconfig && make

# hadolint ignore=DL3002
USER root

RUN mkdir rootfs && \
    tar xpf output/images/rootfs.tar -C rootfs

FROM scratch

COPY --from=buildroot /home/br-user/rootfs/ /
