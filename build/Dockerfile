ARG ALPINE_VERSION=3.22
FROM alpine:${ALPINE_VERSION}

RUN apk add --no-cache \
	bash \
	e2fsprogs \
	pax-utils \
	tar

WORKDIR /src

CMD ["bash"]
