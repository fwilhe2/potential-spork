#!/bin/bash

# User Mode Linux
make mrproper
make mrproper ARCH=um
make defconfig ARCH=um
make -j$(nproc) ARCH=um