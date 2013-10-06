#!/sbin/busybox sh

mkdir -p /system
mkdir -p /.firstrom/media/.secondrom
losetup /dev/block/loop0 /.firstrom/media/.secondrom/system.img
mount -t ext4 -o ro /firstrom/media/.secondrom/system.img /system
