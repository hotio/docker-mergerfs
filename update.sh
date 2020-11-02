#!/bin/bash

if [[ ${1} == "checkdigests" ]]; then
    export DOCKER_CLI_EXPERIMENTAL=enabled
    image="alpine"
    tag="3.12"
    manifest=$(docker manifest inspect ${image}:${tag})
    [[ -z ${manifest} ]] && exit 1
    digest=$(echo "${manifest}" | jq -r '.manifests[] | select (.platform.architecture == "amd64" and .platform.os == "linux").digest') && sed -i "s#FROM ${image}@.*\$#FROM ${image}@${digest}#g" ./linux-amd64.Dockerfile  && echo "${digest}"
    digest=$(echo "${manifest}" | jq -r '.manifests[] | select (.platform.architecture == "arm" and .platform.os == "linux" and .platform.variant == "v7").digest') && sed -i "s#FROM ${image}@.*\$#FROM ${image}@${digest}#g" ./linux-arm-v7.Dockerfile && echo "${digest}"
    digest=$(echo "${manifest}" | jq -r '.manifests[] | select (.platform.architecture == "arm64" and .platform.os == "linux").digest') && sed -i "s#FROM ${image}@.*\$#FROM ${image}@${digest}#g" ./linux-arm64.Dockerfile  && echo "${digest}"
elif [[ ${1} == "tests" ]]; then
    echo "List installed packages..."
    docker run --rm --entrypoint="" "${2}" apk -vv info | sort
    echo "Show version info..."
    echo "mergerfs --version | grep 'mergerfs version:' && exit 0" > "${GITHUB_WORKSPACE}/mergerfstest.sh"
    docker run --rm --entrypoint="" -v "${GITHUB_WORKSPACE}":"${GITHUB_WORKSPACE}" "${2}" sh "${GITHUB_WORKSPACE}/mergerfstest.sh"
else
    version=$(curl -u "${GITHUB_ACTOR}:${GITHUB_TOKEN}" -fsSL "https://api.github.com/repos/trapexit/mergerfs/commits/master" | jq -r .sha)
    [[ -z ${version} ]] && exit 1
    echo '{"version":"'"${version}"'"}' | jq . > VERSION.json
    echo "##[set-output name=version;]${version}"
fi
