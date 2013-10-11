#!/sbin/sh

BB="busybox"

$BB umount -f /storage/sdcard1
$BB mkdir /storage/sdcard1
$BB mount -t auto -o rw /dev/block/mmcblk1p1 /storage/sdcard1 || exit 1

exit 0
