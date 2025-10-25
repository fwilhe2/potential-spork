#!/bin/bash

export LDFLAGS=--static
make defconfig
echo CONFIG_SH=y >> .config
echo CONFIG_INIT=y >> .config
make toybox
