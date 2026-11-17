#!/usr/bin/env bash

KERNEL_PACKAGE=linux-virt
BOOT_DIR="$PROJECT_DIR/output/boot"

# Only the kernel image is needed; QEMU's serial console works without
# modules, so the package stays out of the rootfs.
build_kernel() {
    local -a packages=()
    local out

    status "Fetching kernel"

    rm -rf "$BOOT_DIR" || die "failed to clean '$BOOT_DIR'"
    mkdir -p "$BOOT_DIR" || die "failed to create '$BOOT_DIR'"

    out="$(apk fetch --output "$BOOT_DIR" "$KERNEL_PACKAGE" 2>&1)" \
        || die "failed to fetch $KERNEL_PACKAGE" "$out"

    packages=("$BOOT_DIR/$KERNEL_PACKAGE"-*.apk)

    tar -xzf "${packages[0]}" -C "$BOOT_DIR" \
        --warning=no-unknown-keyword \
        --strip-components=1 \
        boot/vmlinuz-virt \
        || die "failed to extract kernel"

    rm -f "${packages[0]}"

    ok "$(basename "${packages[0]}" .apk)"
}
