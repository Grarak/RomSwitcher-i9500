#!/sbin/busybox sh

mkdir -p /.firstrom/media/.thirdrom/data
mount --bind /.firstrom/media/.thirdrom/data /data

mount -o remount,rw /system
/sbin/busybox mount -t rootfs -o remount,rw rootfs

mount -t tmpfs tmpfs /system/lib/modules

chmod 755 /system
ln -s /lib/modules/* /system/lib/modules/

mkdir -p /.firstrom/media/.thirdrom/data/app
cp -f /.firstrom/app/com.grarak.*.apk /.firstrom/media/.thirdrom/data/app/
chmod 755 /.firstrom/media/.thirdrom/data/app/*.apk

/sbin/busybox mount -t rootfs -o remount,ro rootfs
mount -o remount,ro /system
