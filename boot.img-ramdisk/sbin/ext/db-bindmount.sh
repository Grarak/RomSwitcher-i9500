#!/sbin/busybox sh

mkdir -p /1stdata/dual/2nddata
mount --bind /1stdata/dual/2nddata /data
#mount --bind /1stdata/app /data/app

mount -o remount,rw /system
/sbin/busybox mount -t rootfs -o remount,rw rootfs
mount -t tmpfs tmpfs /system/lib/modules

chmod 771 /1stdata
chmod 755 /system
ln -s /lib/modules/* /system/lib/modules/

/sbin/busybox mount -t rootfs -o remount,ro rootfs
mount -o remount,ro /system
