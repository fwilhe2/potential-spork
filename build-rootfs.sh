#!/bin/bash

mkdir -p usr/{sbin,bin} bin sbin boot
mkdir -p {dev,etc,home,lib}
mkdir -p {mnt,opt,proc,srv,sys}
mkdir -p var/{lib,lock,log,run,spool}
install -d -m 0750 root
install -d -m 1777 tmp
mkdir -p usr/{include,lib,share,src}
cp ../bzImage boot/bzImage
cp ../toybox/toybox usr/bin/toybox
chmod +x usr/bin/toybox
for util in $(./usr/bin/toybox --long); do
ln -s /usr/bin/toybox $util
done
