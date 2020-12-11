FROM alpine:3.12 as builder

# install packages
RUN apk add --no-cache fuse libattr libstdc++ autoconf automake libtool gettext-dev attr-dev linux-headers make build-base git

ARG VERSION

# install mergerfs
RUN git clone -n https://github.com/trapexit/mergerfs.git /mergerfs && cd /mergerfs && \
    git checkout ${VERSION} -b hotio && \
    make STATIC=1 LTO=1 && make install


FROM alpine@sha256:31f1a8999b1f0c0fcea456e9045befee41572ed6c24ae04fec36e6795bd28ee4
LABEL maintainer="hotio"

ENTRYPOINT ["mergerfs", "-f"]

# install packages
RUN apk add --no-cache fuse libattr libstdc++

COPY --from=builder /usr/local/bin/mergerfs /usr/local/bin/mergerfs
COPY --from=builder /usr/local/bin/mergerfs-fusermount /usr/local/bin/mergerfs-fusermount
COPY --from=builder /sbin/mount.mergerfs /sbin/mount.mergerfs
