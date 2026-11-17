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

main() {
    [[ -n "$ROOT" && "$ROOT" != "/" ]] || die "invalid rootfs path"

    mkdir -p "$ROOT" || die "failed to create rootfs"
    ROOT="$(cd "$ROOT" && pwd -P)"
    [[ "$ROOT" != "/" ]] || die "invalid rootfs path"

    msg "Building Core rootfs"
    msg "Target: $ROOT"

    build_filesystem
    build_symlinks
    build_packages
    build_config

    msg "Core rootfs build complete"
}

main "$@"
