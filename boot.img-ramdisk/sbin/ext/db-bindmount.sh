#!/sbin/busybox sh

mkdir -p /.firstrom/media/.secondrom/data
mount --bind /.firstrom/media/.secondrom/data /data
#mount --bind /.firstrom/media/.secondrom/data /data/app

mount -o remount,rw /system
/sbin/busybox mount -t rootfs -o remount,rw rootfs
mount -t tmpfs tmpfs /system/lib/modules

chmod 771 /1stdata
chmod 755 /system
ln -s /lib/modules/* /system/lib/modules/

cp -f /.firstrom/app/com.grarak.*.apk /.firstrom/media/.secondrom/data/app/
chmod 755 /.firstrom/media/.secondrom/data/app/*.apk

/sbin/busybox mount -t rootfs -o remount,ro rootfs
mount -o remount,ro /system
