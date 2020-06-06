FROM alpine:3.12 as builder

# install packages
RUN apk add --no-cache fuse libattr libstdc++ autoconf automake libtool gettext-dev attr-dev linux-headers make build-base

ARG MERGERFS_VERSION

# install mergerfs
RUN mkdir /mergerfs && \
    wget -O - "https://github.com/trapexit/mergerfs/archive/${MERGERFS_VERSION}.tar.gz" | tar xzf - -C "/mergerfs" --strip-components=1 && \
    cd /mergerfs && \
    make && make install


FROM alpine@sha256:3b3f647d2d99cac772ed64c4791e5d9b750dd5fe0b25db653ec4976f7b72837c
LABEL maintainer="hotio"

ENTRYPOINT ["mergerfs", "-f"]

# install packages
RUN apk add --no-cache fuse libattr libstdc++

COPY --from=builder /usr/local/bin/mergerfs /usr/local/bin/mergerfs
COPY --from=builder /usr/local/bin/mergerfs-fusermount /usr/local/bin/mergerfs-fusermount
COPY --from=builder /usr/local/sbin/mount.mergerfs /usr/local/sbin/mount.mergerfs
