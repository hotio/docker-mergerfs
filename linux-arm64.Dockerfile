FROM alpine:3.12 as builder

# install packages
RUN apk add --no-cache fuse libattr libstdc++ autoconf automake libtool gettext-dev attr-dev linux-headers make build-base git

ARG MERGERFS_VERSION

# install mergerfs
RUN git clone -n https://github.com/trapexit/mergerfs.git /mergerfs && cd /mergerfs && \
    git checkout ${MERGERFS_VERSION} -b hotio && \
    make STATIC=1 LTO=1 && make install


FROM alpine@sha256:3b3f647d2d99cac772ed64c4791e5d9b750dd5fe0b25db653ec4976f7b72837c
LABEL maintainer="hotio"

ENTRYPOINT ["mergerfs", "-f"]

# install packages
RUN apk add --no-cache fuse libattr libstdc++

COPY --from=builder /usr/local/bin/mergerfs /usr/local/bin/mergerfs
COPY --from=builder /usr/local/bin/mergerfs-fusermount /usr/local/bin/mergerfs-fusermount
COPY --from=builder /sbin/mount.mergerfs /sbin/mount.mergerfs

ARG LABEL_CREATED
LABEL org.opencontainers.image.created=$LABEL_CREATED
ARG LABEL_TITLE
LABEL org.opencontainers.image.title=$LABEL_TITLE
ARG LABEL_REVISION
LABEL org.opencontainers.image.revision=$LABEL_REVISION
ARG LABEL_SOURCE
LABEL org.opencontainers.image.source=$LABEL_SOURCE
ARG LABEL_VENDOR
LABEL org.opencontainers.image.vendor=$LABEL_VENDOR
ARG LABEL_URL
LABEL org.opencontainers.image.url=$LABEL_URL
ARG LABEL_VERSION
LABEL org.opencontainers.image.version=$LABEL_VERSION
