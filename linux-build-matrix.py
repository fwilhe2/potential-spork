#!/usr/bin/env python3

# SPDX-FileCopyrightText: Florian Wilhelm
# SPDX-License-Identifier: Apache-2.0

from urllib.request import urlopen
import json

pre = '''name: Kernel Matrix
on:
  push:
  workflow_dispatch:

jobs:
  kernel:
    runs-on: ubuntu-24.04
    strategy:
      fail-fast: false
      matrix:
        version:
'''

post = '''    steps:
    - uses: actions/checkout@v4
      with:
        repository: gregkh/linux
        fetch-depth: 1
        ref: v${{ matrix.version }}
    - run: sudo apt-get update && sudo apt-get -y install apt-utils bc lz4 binutils bison build-essential ca-certificates cscope debhelper dwarves flex gcc git libelf-dev libncurses-dev libssl-dev linux-source make openssl pahole perl-base pkg-config python3-debian python-is-python3 rsync vim
    - name: Configure
      run: |
        make defconfig
        make kvm_guest.config
    - name: Build
      run: |
        make -j`nproc`
    - name: Upload a Build Artifact
      uses: actions/upload-artifact@v4.3.4
      with:
        name: bzImage-${{ matrix.version }}
        path: arch/x86_64/boot/bzImage
'''

kernel_versions = ''
with urlopen('https://www.kernel.org/releases.json') as response:
    releases = json.loads(response.read().decode())['releases']
    for r in releases:
        if 'next' not in r['version']:
            print(f'          - "{r['version']}"')
            kernel_versions = kernel_versions + f'          - "{r['version']}"\n'

workflow = pre + kernel_versions + post

with open('.github/workflows/matrix.yml', 'w+') as file:
    file.write(workflow)