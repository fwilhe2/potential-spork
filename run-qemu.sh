DIR="$(dirname $0)"; qemu-system-x86_64 -m 256 "$@" -nographic -no-reboot -kernel "$DIR"/bzImage -initrd "$DIR"/rootfs.cpio -hda "$DIR"/rootfs.ext4 -append "HOST=x86_64 console=ttyS0 $KARGS root=/dev/sda"
echo -e '\e[?7h'
