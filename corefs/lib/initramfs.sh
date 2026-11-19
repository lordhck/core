#!/usr/bin/env bash

INITRAMFS="$PROJECT_DIR/output/initramfs.cpio.gz"

build_initramfs() {
    local out

    status "Packing initramfs"

    # The kernel opens /dev/console before init can mount devtmpfs.
    if [[ ! -c "$ROOT/dev/console" ]]; then
        mknod -m 600 "$ROOT/dev/console" c 5 1 || die "failed to create /dev/console"
    fi

    # Older builds made /init a symlink to busybox; writing through it
    # would overwrite busybox.
    rm -f "$ROOT/init" || die "failed to remove old /init"

    # virtio_blk and ext4 are modules, so the disk can only be mounted
    # from here. Without a disk, Core keeps running from the initramfs.
    # ext4 needs crc32c, which is not in modules.dep.
    write_file "$ROOT/init" 755 <<'EOT'
#!/bin/sh
mount -t devtmpfs devtmpfs /dev
mount -t proc proc /proc
modprobe -a virtio_blk crc32c_generic ext4
mount -t ext4 /dev/vda /mnt && root=/mnt
umount /proc /dev
[ -n "$root" ] && exec switch_root "$root" /sbin/init
exec /sbin/init
EOT

    out="$( { cd "$ROOT" && find . | cpio -o -H newc | gzip > "$INITRAMFS"; } 2>&1 )" \
        || die "failed to pack initramfs" "$out"

    ok "$(du -h "$INITRAMFS" | cut -f1)"
}
