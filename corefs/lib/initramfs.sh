#!/usr/bin/env bash

INITRAMFS="$PROJECT_DIR/output/initramfs.cpio.gz"

build_initramfs() {
    local out

    status "Packing initramfs"

    # The kernel opens /dev/console before init can mount devtmpfs.
    if [[ ! -c "$ROOT/dev/console" ]]; then
        mknod -m 600 "$ROOT/dev/console" c 5 1 || die "failed to create /dev/console"
    fi

    out="$( { cd "$ROOT" && find . | cpio -o -H newc | gzip > "$INITRAMFS"; } 2>&1 )" \
        || die "failed to pack initramfs" "$out"

    ok "$(du -h "$INITRAMFS" | cut -f1)"
}
