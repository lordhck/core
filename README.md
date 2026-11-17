# Core Linux

A minimal Linux distribution built from the ground up.

**Philosophy:** Keep it simple.

## Build

```bash
docker compose build
docker compose run --rm core-build ./corefs/build.sh
```

## Chroot

```bash
sudo ./scripts/chroot
```

## Status

Currently in the bootstrap phase. Alpine is temporarily used as a build environment and binary package source.

The long-term goal is a self-hosting Linux distribution.
