# Core Linux

A minimal Linux distribution built from the ground up.

**Philosophy:** Keep it simple.

## Requirements

- Docker with Compose
- make and m4
- QEMU (`qemu-system-x86_64`) with KVM access, for `make run`

## Build

```bash
git clone --recursive https://github.com/lordhck/core
cd core
make
```

In an existing clone, run `git submodule update --init` first.

This builds [install-scripts](https://github.com/lordhck/install-scripts)
and runs its tools in the build container:

- `corefs install base` builds the rootfs
- `mkinitfs` builds a minimal initramfs that mounts the disk
- `scripts/mkdisk` packs the rootfs into an ext4 disk image

## Run

```bash
make run
```

Log in as `root` without a password. Quit QEMU with `Ctrl-A X`.

Changes are saved to `output/disk.img` and survive reboots. `make build`
recreates the disk.

The VM gets network through QEMU user-mode networking. `ping` only works
if the host allows unprivileged ICMP:

```bash
sudo sysctl -w net.ipv4.ping_group_range="0 2147483647"
```

Run `make help` for all targets.

## Chroot

```bash
make chroot
```

## Status

Currently in the bootstrap phase. Alpine is temporarily used as a build environment and as the source of binary packages and the kernel.

Core boots in QEMU from a persistent ext4 disk, with networking (DHCP)
and system logging (`/var/log/messages`).

The long-term goal is a self-hosting Linux distribution.

## Roadmap

- [x] Rootfs builder
- [x] Init and boot
- [x] Base system and networking
- [ ] `core` dispatcher (`add` / `del`)
- [ ] Self-hosting
- [ ] Installable distribution

## License

MIT. See [LICENSE](LICENSE).
