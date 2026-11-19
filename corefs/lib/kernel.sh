#!/usr/bin/env bash

KERNEL_PACKAGE=linux-virt
KERNEL_MODULES=(virtio_net af_packet virtio_blk crc32c_generic ext4)
BOOT_DIR="$PROJECT_DIR/output/boot"

# The full module tree is ~28M, so only the modules listed above and
# their dependencies go into the rootfs.
build_kernel() {
    local -a packages=() files=()
    local -a tarflags=(--warning=no-unknown-keyword)
    local apk moddir out

    status "Fetching kernel"

    rm -rf "$BOOT_DIR" "$ROOT/usr/lib/modules" || die "failed to clean kernel files"
    mkdir -p "$BOOT_DIR" || die "failed to create '$BOOT_DIR'"

    out="$(apk fetch --output "$BOOT_DIR" "$KERNEL_PACKAGE" 2>&1)" \
        || die "failed to fetch $KERNEL_PACKAGE" "$out"

    packages=("$BOOT_DIR/$KERNEL_PACKAGE"-*.apk)
    apk="${packages[0]}"

    tar -xzf "$apk" -C "$BOOT_DIR" "${tarflags[@]}" \
        --strip-components=1 boot/vmlinuz-virt \
        || die "failed to extract kernel"

    moddir="$(tar -tzf "$apk" "${tarflags[@]}" \
        | awk -F/ '!d && $1 == "lib" && $2 == "modules" && $3 {print "lib/modules/" $3; d=1}')"
    [[ -n "$moddir" ]] || die "no modules in $KERNEL_PACKAGE"

    # modules.dep lists each module's full dependency chain.
    mapfile -t files < <(
        tar -xzOf "$apk" "${tarflags[@]}" "$moddir/modules.dep" \
        | awk -v want=" ${KERNEL_MODULES[*]} " '{
            sub(":", "", $1)
            name = $1; sub(/.*\//, "", name); sub(/\.ko.*/, "", name)
            if (index(want, " " name " ")) for (i = 1; i <= NF; i++) print $i
        }' | sort -u
    )
    ((${#files[@]} >= ${#KERNEL_MODULES[@]})) || die "kernel modules not found"

    tar -xzf "$apk" -C "$ROOT" "${tarflags[@]}" --keep-directory-symlink \
        "$moddir"/modules.{dep,alias,builtin,order} \
        "${files[@]/#/$moddir/}" \
        || die "failed to extract kernel modules"

    printf '%s\n' "${KERNEL_MODULES[@]}" > "$ROOT/etc/modules" \
        || die "failed to write /etc/modules"

    rm -f "$apk"

    ok "$(basename "$apk" .apk), ${#files[@]} modules"
}
