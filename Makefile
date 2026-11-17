.PHONY: build shell chroot run clean

build:
	docker compose run --rm core-build ./corefs/build.sh

shell:
	docker compose run --rm core-build

chroot:
	sudo ./scripts/chroot

run:
	qemu-system-x86_64 -enable-kvm -m 512M -nographic \
		-kernel output/boot/vmlinuz-virt \
		-initrd output/initramfs.cpio.gz \
		-append console=ttyS0

clean:
	sudo rm -rf output
