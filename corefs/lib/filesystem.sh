#!/usr/bin/env bash

build_filesystem() {
    local dir

    status "Creating filesystem"

    for dir in boot dev etc home mnt opt proc run srv sys \
               usr/{bin,include,lib,libexec,sbin,share} \
               var/{cache,lib,log,spool}; do
        mkd "$ROOT/$dir"
    done

    mkd "$ROOT/root"     700
    mkd "$ROOT/tmp"      1777
    mkd "$ROOT/var/tmp"  1777
    mkd "$ROOT/run/lock"

    # init needs a console before devtmpfs is mounted.
    if [[ ! -c "$ROOT/dev/console" ]]; then
        mknod -m 600 "$ROOT/dev/console" c 5 1 || die "failed to create /dev/console"
    fi

    ok
}
