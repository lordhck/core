#!/usr/bin/env bash

DISK="$PROJECT_DIR/output/disk.img"

# mke2fs -d fills the filesystem from a directory, so no loop mount
# or root on the host is needed.
build_disk() {
    local out

    status "Creating disk image"

    rm -f "$DISK" || die "failed to remove old disk image"
    out="$(mke2fs -q -t ext4 -L core -d "$ROOT" "$DISK" 1G 2>&1)" \
        || die "failed to create disk image" "$out"

    # The container runs as root; QEMU on the host needs write access.
    chown "$(stat -c %u:%g "$PROJECT_DIR")" "$DISK" || die "failed to chown disk image"

    ok "1G ext4"
}
