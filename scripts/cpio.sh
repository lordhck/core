#!/usr/bin/env bash
set -euo pipefail

ROOTFS=output/rootfs

# initramfs with busybox-static and the disk modules of the rootfs kernel
mkinitfs "$ROOTFS" "$(ls "$ROOTFS/lib/modules")" output/initramfs.cpio.gz
