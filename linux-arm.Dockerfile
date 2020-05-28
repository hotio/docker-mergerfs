FROM alpine:3.11 as builder

# install packages
RUN apk add --no-cache fuse libattr libgcc libstdc++ autoconf automake libtool gettext-dev attr-dev linux-headers curl make

ARG MERGERFS_VERSION

# install mergerfs
RUN mkdir /mergerfs && \
    curl -fsSL "https://github.com/trapexit/mergerfs/archive/${MERGERFS_VERSION}.tar.gz" | tar xzf - -C "/mergerfs" --strip-components=1 && \
    cd /mergerfs && \
    make && make install


FROM alpine@sha256:19c4e520fa84832d6deab48cd911067e6d8b0a9fa73fc054c7b9031f1d89e4cf
LABEL maintainer="hotio"

ENTRYPOINT ["mergerfs", "-f"]

# install packages
RUN apk add --no-cache fuse libattr libgcc libstdc++

COPY --from=builder /usr/bin/mergerfs /usr/bin/mergerfs
COPY --from=builder /usr/bin/mergerfs-fusermount /usr/bin/mergerfs-fusermount
COPY --from=builder /usr/sbin/mount.mergerfs /usr/sbin/mount.mergerfs
