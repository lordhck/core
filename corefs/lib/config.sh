#!/usr/bin/env bash

build_config() {
    msg "Writing system configuration"

    write_file "$ROOT/etc/os-release" <<'EOT'
NAME="Core Linux"
ID=core
PRETTY_NAME="Core Linux"
VERSION="0.1.0"
VERSION_ID="0.1.0"
EOT

    write_file "$ROOT/etc/hostname" <<'EOT'
core
EOT

    write_file "$ROOT/etc/hosts" <<'EOT'
127.0.0.1 localhost
127.0.0.1 core
::1 localhost
EOT

    write_file "$ROOT/etc/passwd" <<'EOT'
root:x:0:0:root:/root:/bin/sh
EOT

    write_file "$ROOT/etc/group" <<'EOT'
root:x:0:
bin:x:1:
daemon:x:2:
sys:x:3:
tty:x:5:
wheel:x:10:
users:x:100:
EOT

    write_file "$ROOT/etc/shadow" 600 <<'EOT'
root:!:0:0:99999:7:::
EOT

    msg "System configuration created"
}
