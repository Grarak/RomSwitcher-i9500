#!/sbin/busybox sh

mkdir -p /system
mkdir -p /.firstrom
mount -t ext4 -o rw /dev/block/mmcblk0p21 /.firstrom
mkdir -p /.firstrom/media/.secondrom
losetup /dev/block/loop0 /.firstrom/media/.secondrom/system.img
mount -t ext4 -o ro /.firstrom/media/.secondrom/system.img /system
umount -f /.firstrom
