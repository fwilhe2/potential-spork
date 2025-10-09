#!/bin/bash

make tinyconfig
make kvm_guest.config
echo 'CONFIG_EFI_STUB=y' >> .config
make -j$(nproc)
