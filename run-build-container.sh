#!/bin/bash

set -o errexit
set -x

VERSION_SOURCE=$(python3 get-kernel-url-by-version.py 6.12)
KERNEL_VERSION=$(echo $VERSION_SOURCE | cut -d ',' -f 1)
KERNEL_SOURCE=$(echo $VERSION_SOURCE | cut -d ',' -f 2)

if [ ! -f linux-"${KERNEL_VERSION}".tar.xz ]; then
    wget --quiet $KERNEL_SOURCE
fi

if [ ! -d linux-"${KERNEL_VERSION}" ]; then
    tar xf linux-"${KERNEL_VERSION}".tar.xz
fi
podman build -t kernel-builder -f Containerfile.kernel .
podman run --volume "$PWD"/linux-"${KERNEL_VERSION}":/usr/local/src kernel-builder /usr/local/bin/build-kernel.sh

cp linux-"${KERNEL_VERSION}"/arch/x86/boot/bzImage bzImage

if [ ! -d toybox ]; then
    git clone --depth=1 https://github.com/landley/toybox
fi

podman build -t toybox-builder -f Containerfile.toybox .
podman run --volume "$PWD"/toybox:/usr/local/src toybox-builder /usr/local/bin/build-toybox.sh
mkdir -p rootfs
podman run --volume "$PWD"/rootfs:/usr/local/src --volume "$PWD"/toybox:/usr/local/toybox toybox-builder /usr/local/bin/build-rootfs.sh
