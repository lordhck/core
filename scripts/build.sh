#!/usr/bin/env bash
set -euo pipefail

ROOTFS=output/rootfs

# install core base system
corefs install base "$ROOTFS"
