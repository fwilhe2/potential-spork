DIR="$(dirname "$0")"; qemu-system-aarch64 -M virt -cpu cortex-a57 -m 256 "$@" -nographic -no-reboot -kernel "$DIR"/Image.gz -initrd "$DIR"/output/rootfs.cpio -hda "$DIR"/output/rootfs.ext4 -append "HOST=aarch64 console=ttyAMA0 root=/dev/vda $KARGS"
echo -e '\e[?7h'
