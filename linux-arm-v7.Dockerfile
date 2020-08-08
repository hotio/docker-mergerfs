FROM alpine:3.12 as builder

# install packages
RUN apk add --no-cache fuse libattr libstdc++ autoconf automake libtool gettext-dev attr-dev linux-headers make build-base

ARG MERGERFS_VERSION

# install mergerfs
RUN mkdir /mergerfs && \
    wget -O - "https://github.com/trapexit/mergerfs/archive/${MERGERFS_VERSION}.tar.gz" | tar xzf - -C "/mergerfs" --strip-components=1 && \
    cd /mergerfs && \
    make && make install


FROM alpine@sha256:19c4e520fa84832d6deab48cd911067e6d8b0a9fa73fc054c7b9031f1d89e4cf
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
