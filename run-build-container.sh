#!/bin/bash

set -o errexit
set -x

mkdir -p {rootfs,output}

KERNEL_VERSION=$(python3 get-kernel-url-by-version.py 6.12 version)
KERNEL_SOURCE=$(python3 get-kernel-url-by-version.py 6.12 source)

if [ ! -f linux-"${KERNEL_VERSION}".tar.xz ]; then
    wget --quiet $KERNEL_SOURCE
fi

if [ ! -d linux-"${KERNEL_VERSION}" ]; then
    tar xf linux-"${KERNEL_VERSION}".tar.xz
fi
podman build -t kernel-builder -f Containerfile.kernel .
podman run --volume "$PWD"/linux-"${KERNEL_VERSION}":/usr/local/src kernel-builder /usr/local/bin/build-kernel.sh

arch=$(uname -i)
if [[ $arch == x86_64* ]]; then
    cp linux-"${KERNEL_VERSION}"/arch/x86/boot/bzImage output/bzImage
elif  [[ $arch == arm* ]]; then
    cp linux-"${KERNEL_VERSION}"/arch/arm64/boot/Image.gz output/Image.gz
fi

if [ ! -d toybox ]; then
    git clone --depth=1 https://github.com/landley/toybox
fi

podman build -t toybox-builder -f Containerfile.toybox .
podman run --volume "$PWD"/toybox:/usr/local/src toybox-builder /usr/local/bin/build-toybox.sh
podman run --volume "$PWD"/rootfs:/usr/local/src --volume "$PWD"/output:/usr/local/output --volume "$PWD"/toybox:/usr/local/toybox toybox-builder /usr/local/bin/build-rootfs.sh
