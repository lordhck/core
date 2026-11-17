#!/usr/bin/env bash

msg()  { printf '[INFO] %s\n' "$*"; }
warn() { printf '[WARN] %s\n' "$*" >&2; }
die()  { printf '[FAIL] %s\n' "$*" >&2; exit 1; }

mkd() {
    local dir="$1" mode="${2:-755}"

    mkdir -p "$dir" || die "failed to create '$dir'"
    chmod "$mode" "$dir" || die "failed to chmod '$dir'"
}

lns() {
    local target="$1" link="$2"

    [[ -e "$link" && ! -L "$link" ]] && die "refusing to replace '$link'"
    ln -sfn "$target" "$link" || die "failed to link '$link'"
}

write_file() {
    local file="$1" mode="${2:-644}"

    mkdir -p "$(dirname "$file")" || die "failed to create parent directory"
    cat > "$file" || die "failed to write '$file'"
    chmod "$mode" "$file" || die "failed to chmod '$file'"
}
