FROM alpine:3.12 as builder

# install packages
RUN apk add --no-cache fuse libattr libstdc++ autoconf automake libtool gettext-dev attr-dev linux-headers make build-base

ARG MERGERFS_VERSION

# install mergerfs
RUN mkdir /mergerfs && \
    wget -O - "https://github.com/trapexit/mergerfs/archive/${MERGERFS_VERSION}.tar.gz" | tar xzf - -C "/mergerfs" --strip-components=1 && \
    cd /mergerfs && \
    make && make install


FROM alpine@sha256:a15790640a6690aa1730c38cf0a440e2aa44aaca9b0e8931a9f2b0d7cc90fd65
LABEL maintainer="hotio"

ENTRYPOINT ["mergerfs", "-f"]

# install packages
RUN apk add --no-cache fuse libattr libstdc++

COPY --from=builder /usr/local/bin/mergerfs /usr/local/bin/mergerfs
COPY --from=builder /usr/local/bin/mergerfs-fusermount /usr/local/bin/mergerfs-fusermount
COPY --from=builder /usr/local/sbin/mount.mergerfs /usr/local/sbin/mount.mergerfs
