#!/bin/bash

make defconfig
make kvm_guest.config
echo 'CONFIG_EFI_STUB=y' >> .config
make -j$(nproc)

# User Mode Linux
make mrproper
make mrproper ARCH=um
make defconfig ARCH=um
make -j$(nproc) ARCH=um