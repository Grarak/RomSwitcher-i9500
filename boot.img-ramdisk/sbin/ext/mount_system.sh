#!/sbin/busybox sh

ROM=$1

if [ "$ROM" == "secondary" ]; then
    losetup /dev/block/loop0 /.firstrom/media/.secondrom/system.img
    mount -t ext4 -o ro /.firstrom/media/.secondrom/system.img /system
elif [ "$ROM" == "tertiary" ]; then
    losetup /dev/block/loop0 /.firstrom/media/.thirdrom/system.img
    mount -t ext4 -o ro /.firstrom/media/.thirdrom/system.img /system
fi
