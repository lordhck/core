#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

ROOT="${ROOT:-$PROJECT_DIR/output/rootfs}"

source "$SCRIPT_DIR/lib/common.sh"
source "$SCRIPT_DIR/lib/filesystem.sh"
source "$SCRIPT_DIR/lib/symlinks.sh"
source "$SCRIPT_DIR/lib/config.sh"
source "$SCRIPT_DIR/lib/packages.sh"
source "$SCRIPT_DIR/lib/kernel.sh"
source "$SCRIPT_DIR/lib/verify.sh"
source "$SCRIPT_DIR/lib/initramfs.sh"

main() {
    [[ -n "$ROOT" && "$ROOT" != "/" ]] || die "invalid rootfs path"

    mkdir -p "$ROOT" || die "failed to create rootfs"
    ROOT="$(cd "$ROOT" && pwd -P)"
    [[ "$ROOT" != "/" ]] || die "invalid rootfs path"

    # An open chroot leaves host dirs mounted here; chmod would hit the host.
    local dir
    for dir in dev proc sys run; do
        mountpoint -q "$ROOT/$dir" && die "/$dir is mounted, exit the chroot first"
    done

    msg "Building Core rootfs in $ROOT"

    build_filesystem
    build_symlinks
    build_packages
    build_kernel
    build_config
    verify_elf
    build_initramfs

    msg "Core rootfs built in ${SECONDS}s"
}

main "$@"
