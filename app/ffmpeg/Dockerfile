ARG IMAGE=buildroot-rootfs-amd64
# hadolint ignore=DL3006
FROM $IMAGE as buildroot

COPY . .
RUN support/kconfig/merge_config.sh -m .config config.pkg

RUN make olddefconfig && make

# hadolint ignore=DL3002
USER root

RUN mkdir rootfs && \
    tar xpf output/images/rootfs.tar -C rootfs

FROM scratch

ENV VIDEO_SIZE="1280x720"
ENV VIDEO_INPUT="/dev/video0"
ENV INPUT_FORMAT="h264"
ENV INPUT_OPTIONS="-re"
ENV OUTPUT_FORMAT="flv"
ENV OUTPUT_CODEC="copy"
ENV OUTPUT_OPTIONS=""
ENV VIDEO_OUTPUT="-f null -"

COPY --from=buildroot /home/br-user/rootfs/ /
CMD ffmpeg \
        $INPUT_OPTIONS -f v4l2 -input_format $INPUT_FORMAT -video_size $VIDEO_SIZE -i $VIDEO_INPUT \
        -f lavfi -i anullsrc \
        -c:v $OUTPUT_CODEC $OUTPUT_OPTIONS -f $OUTPUT_FORMAT $VIDEO_OUTPUT

