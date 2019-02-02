FROM ubuntu:18.04 as kernel

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    linux-image-virtual

RUN cp /boot/vmlinuz* /boot/vmlinuz
RUN cp /boot/initrd.img* /boot/initrd.img


FROM alpine:3.8

RUN apk add --no-cache \
	bash \
	e2fsprogs \
	qemu-img \
	qemu-system-x86_64

ENV CHROOT /rootfs

ENV MEM 2G
ENV HDA_RAW /hda.img
ENV HDA_QCOW2 /hda.qcow2
ENV HDA_SIZE +500m

COPY bin/* /usr/bin/

COPY --from=kernel /boot/vmlinuz /vmlinuz
COPY --from=kernel /boot/initrd.img /initrd.img

ENTRYPOINT [ "/usr/bin/entrypoint.sh" ]
