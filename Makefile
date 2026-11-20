SHELL := /bin/bash

.PHONY: build shell chroot run clean help

build: ## Build the rootfs, initramfs and disk image
	docker compose run --rm --build core-build \
		bash -c "./corefs/build.sh && ./scripts/mkdisk output/rootfs output/disk.img"

shell: ## Open a shell in the build container
	docker compose run --rm core-build

chroot: ## Chroot into the rootfs (sudo)
	sudo ./scripts/chroot

run: ## Boot Core in QEMU
	qemu-system-x86_64 -enable-kvm -m 512M -nographic \
		-nic user,model=virtio-net-pci \
		-drive file=output/disk.img,format=raw,if=virtio \
		-kernel output/boot/vmlinuz-virt \
		-initrd output/initramfs.cpio.gz \
		-append console=ttyS0

clean: ## Remove build output (sudo)
	sudo rm -rf output

help: ## Show this help
	@if [[ -t 1 && -z "$${NO_COLOR:-}" ]]; then \
		B=$$'\033[38;2;122;162;247m' H=$$'\033[1m' R=$$'\033[0m'; \
	else B= H= R=; fi; \
	printf '%score%s - A minimal Linux distribution\n\n' "$$H" "$$R"; \
	printf 'Usage: make %s<target>%s\n\n' "$$B" "$$R"; \
	printf '%sTargets%s\n' "$$H" "$$R"; \
	grep -hE '^[a-zA-Z0-9_.-]+:.*## ' $(MAKEFILE_LIST) | while IFS= read -r l; do \
		printf '  %s%-12s%s %s\n' "$$B" "$${l%%:*}" "$$R" "$${l#*## }"; done
