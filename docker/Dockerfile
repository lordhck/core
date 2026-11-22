ARG ALPINE_VER=3.22
FROM alpine:${ALPINE_VER}

ARG REPO=https://pkgs.lordhck.com/x86_64
ARG IN_VER=0.2.2 	# install-scripts   version
ARG SE_VER=0.1.0	# setup-scripts     version

RUN apk add --no-cache \
        bash \
        e2fsprogs \
        openssl \
        pax-utils \
        tar \
        wget \
        xz

ADD ${REPO}/install-scripts-${IN_VER}.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/install-scripts-${IN_VER}.tar.xz
ADD ${REPO}/setup-scripts-${SE_VER}.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/setup-scripts-${SE_VER}.tar.xz

WORKDIR /core-build

CMD ["bash"]
