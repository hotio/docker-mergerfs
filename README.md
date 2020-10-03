# mergerfs

[<img src="https://hotio.dev/img/mergerfs.png" alt="logo" height="130" width="130">](https://github.com/trapexit/mergerfs)

![Base](https://img.shields.io/badge/base-alpine-blue)
[![GitHub](https://img.shields.io/badge/source-github-lightgrey)](https://github.com/hotio/docker-mergerfs)
[![Docker Pulls](https://img.shields.io/docker/pulls/hotio/mergerfs)](https://hub.docker.com/r/hotio/mergerfs)
[![GitHub Registry](https://img.shields.io/badge/registry-ghcr.io-blue)](https://github.com/users/hotio/packages/container/package/mergerfs)
[![Discord](https://img.shields.io/discord/610068305893523457?color=738ad6&label=discord&logo=discord&logoColor=white)](https://discord.gg/3SnkuKp)
[![Upstream](https://img.shields.io/badge/upstream-project-yellow)](https://github.com/trapexit/mergerfs)

## Starting the container

Just the basics to get the container running:

```shell
docker run --rm hotio/mergerfs ...
```

The default `ENTRYPOINT` is `mergerfs -f`.

## Tags

| Tag                | Upstream                      |
| -------------------|-------------------------------|
| `release` (latest) | GitHub releases               |
| `nightly`          | Every commit to master branch |

You can also find tags that reference a commit or version number.

## Using the mergerfs mount on the host

By setting the `bind-propagation` to `shared` on the volume `mountpoint`, like this `-v /data/mountpoint:/mountpoint:shared`, you are able to access the mount from the host. If you want to use this mount in another container, the best solution is to create a volume on the parent folder of that mount with `bind-propagation` set to `slave`. For example, `-v /data:/data:slave` (`/data` on the host, would contain the previously created volume `mountpoint`). Doing it like this will ensure that when the container creating the mount restarts, the other containers using that mount will recover and keep working.

## Extra docker privileges

In most cases you will need some or all of the following flags added to your command to get the required docker privileges when using a mergerfs mount.

```shell
--security-opt apparmor:unconfined --cap-add SYS_ADMIN --device /dev/fuse
```
