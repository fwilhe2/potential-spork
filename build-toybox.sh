#!/bin/bash

export LDFLAGS=--static
make defconfig
echo CONFIG_SH=y >> .config
make toybox
