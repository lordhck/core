.PHONY: build shell chroot clean

build:
	docker compose run --rm core-build ./corefs/build.sh

shell:
	docker compose run --rm core-build

chroot:
	sudo ./scripts/chroot

clean:
	sudo rm -rf output
