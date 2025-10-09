#!/bin/bash

make tinyconfig
make kvm_guest.config
make -j$(nproc)
