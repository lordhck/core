# Core Linux

A minimal Linux distribution built from the ground up.

**Philosophy:** Keep it simple.

## Build

```bash
make
```

## Run

```bash
make run
```

Log in as `root` without a password. Quit QEMU with `Ctrl-A X`.

## Chroot

```bash
make chroot
```

## Status

Currently in the bootstrap phase. Alpine is temporarily used as a build environment and binary package source.

The long-term goal is a self-hosting Linux distribution.

## Roadmap

- [ ] Rootfs builder
- [ ] Init and boot
- [ ] Base system and networking
- [ ] Package manager
- [ ] Self-hosting
- [ ] Installable distribution
