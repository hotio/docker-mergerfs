FROM alpine:3.12 as builder

# install packages
RUN apk add --no-cache fuse libattr libstdc++ autoconf automake libtool gettext-dev attr-dev linux-headers make build-base git

ARG VERSION

# install mergerfs
RUN git clone -n https://github.com/trapexit/mergerfs.git /mergerfs && cd /mergerfs && \
    git checkout ${VERSION} -b hotio && \
    make STATIC=1 LTO=1 && make install


FROM alpine@sha256:db5f021b29ec8fcf605f00d2aac06345756b0ffbdea0e7994044fe9172619a0a
LABEL maintainer="hotio"

ENTRYPOINT ["mergerfs", "-f"]

# install packages
RUN apk add --no-cache fuse libattr libstdc++

COPY --from=builder /usr/local/bin/mergerfs /usr/local/bin/mergerfs
COPY --from=builder /usr/local/bin/mergerfs-fusermount /usr/local/bin/mergerfs-fusermount
COPY --from=builder /sbin/mount.mergerfs /sbin/mount.mergerfs
