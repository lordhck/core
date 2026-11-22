#!/usr/bin/env bash
set -euo pipefail

ROOTFS=output/rootfs
DISK=output/disk.img

# mke2fs -d fills the filesystem from a directory: no loop mount, no root on the host
rm -f "$DISK"
mke2fs -q -t ext4 -L core -d "$ROOTFS" "$DISK" 1G

# the container runs as root; QEMU on the host needs write access
chown "$(stat -c %u:%g .)" "$DISK"
echo "Created $DISK (1G ext4)"
