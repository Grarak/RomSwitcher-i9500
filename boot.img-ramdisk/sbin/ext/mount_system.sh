#!/sbin/busybox sh

mkdir -p /system
losetup /dev/block/loop0 /.firstrom/media/.secondrom/system.img
mount -t ext4 -o ro /.firstrom/media/.secondrom/system.img /system
