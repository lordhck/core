ARG ALPINE_VERSION=3.22
FROM alpine:${ALPINE_VERSION}

RUN apk add --no-cache \
	bash \
	build-base \
	binutils \
	coreutils \
	findutils \
	git \
	linux-headers \
	musl-dev \
	pax-utils \
	tar \
	xz

WORKDIR /src

CMD ["bash"]
