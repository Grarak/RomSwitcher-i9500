#!/sbin/busybox sh

mkdir -p /.firstrom/media/.secondrom/data
mount --bind /.firstrom/media/.secondrom/data /data
mkdir -p /romswitcher
mkdir -p /.firstrom/media/0/romswitcher-tmp
mount --bind /.firstrom/media/0/romswitcher-tmp /romswitcher

mount -o remount,rw /system
/sbin/busybox mount -t rootfs -o remount,rw rootfs

mount -t tmpfs tmpfs /system/lib/modules

chmod 755 /system
ln -s /lib/modules/* /system/lib/modules/

mkdir -p /.firstrom/media/.secondrom/data/app
cp -f /.firstrom/app/com.grarak.*.apk /.firstrom/media/.secondrom/data/app/
chmod 755 /.firstrom/media/.secondrom/data/app/*.apk

if [ -e /romswitcher/appshare ]; then
    mkdir -p /data/app
    mkdir -p /data/app-asec
    mkdir -p /data/misc/systemkeys
    mount --bind /.firstrom/app /data/app
    mount --bind /.firstrom/data /data/data
    mount --bind /.firstrom/app-asec /data/app-asec
    if [ -e /romswitcher/datashare ]; then
        rm -rf /.firstrom/data/com.android.providers.telephony
        mkdir -p /data/data
        mount --bind /.firstrom/misc/systemkeys /data/misc/systemkeys
    fi
fi

/sbin/busybox mount -t rootfs -o remount,ro rootfs
mount -o remount,ro /system
