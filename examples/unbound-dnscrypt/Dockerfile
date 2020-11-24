FROM buildroot-rootfs-aarch64:2020.08.2 as buildroot

COPY config.pkg ./

RUN support/kconfig/merge_config.sh -m .config config.pkg

RUN make olddefconfig && make

# hadolint ignore=DL3002
USER root

WORKDIR /rootfs

RUN tar xpf /home/br-user/output/images/rootfs.tar -C /rootfs

FROM scratch

COPY --from=buildroot /rootfs/ /

COPY unbound.conf a-records.conf /etc/unbound/

WORKDIR /var/run

CMD ["unbound", "-d"]
