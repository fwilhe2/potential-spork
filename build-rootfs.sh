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

cp -r /root/etc .
chmod +x etc/init.d/rcS

/sbin/mkfs.ext4 -L root -d /usr/local/src /usr/local/output/rootfs.ext4 1G
tar cf /usr/local/output/rootfs.tar /usr/local/src
find /usr/local/src | cpio --create --verbose -H newc > /usr/local/output/rootfs.cpio
