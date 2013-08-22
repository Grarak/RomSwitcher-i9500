#!/sbin/busybox sh

mkdir -p /1stdata/dual/2nddata
mount --bind /1stdata/dual/2nddata /data

mount -o remount,rw /system
mount -o remount,rw /data
/sbin/busybox mount -t rootfs -o remount,rw rootfs

chmod 755 /system
chmod 755 /system/addon.d
chmod 755 /system/bin
chmod 755 /system/etc/init.d
chmod 755 /system/etc/ppp
chmod 755 /system/vendor/bin
chmod 755 /system/vendor/etc
chmod 755 /system/xbin

mv -f /res/99SuperSUDaemon /system/
mv -f /res/chattr /system/

chmod 755 /system/chattr

/system/chattr -i /system/xbin/su
/system/chattr -i /system/bin/.ext/.su
/system/chattr -i /system/xbin/daemonsu
/system/chattr -i /system/etc/install-recovery.sh

rm -f /system/bin/su
rm -f /system/xbin/su
rm -f /system/xbin/daemonsu
rm -f /system/bin/.ext/.su
rm -f /system/app/*uper*ser.*
rm -f /system/app/*uper*u.*
rm -f /data/dalvik-cache/*com.noshufou.android.su*
rm -f /data/dalvik-cache/*com.koushikdutta.superuser*
rm -f /data/dalvik-cache/*uper*ser.apk*
rm -f /data/dalvik-cache/*eu.chainfire.supersu*
rm -f /data/dalvik-cache/*uper*u.apk*
rm -f /data/app/com.noshufou.android.su-*
rm -f /data/app/com.koushikdutta.superuser-*
rm -f /data/app/eu.chainfire.supersu-*

cp -f /system/etc/Superuser.apk /system/app/
mv -f /res/app/* /system/app/
mv -f /res/etc/* /system/etc/
mv -f /res/xbin/* /system/xbin/

mv -f /system/99SuperSUDaemon /system/etc/init.d/99SuperSUDaemon

chown 0.0 /system/bin/.ext
chmod 0777 /system/bin/.ext
chown 0.0 /system/bin/.ext/.su
chmod 06755 /system/bin/.ext/.su
chown 0.0 /system/xbin/su
chmod 06755 /system/xbin/su
chown 0.0 /system/xbin/daemonsu
chmod 06755 /system/xbin/daemonsu
chown 0.0 /system/etc/install-recovery.sh
chmod 0755 /system/etc/install-recovery.sh
chown 0.0 /system/etc/init.d/99SuperSUDaemon
chmod 0755 /system/etc/init.d/99SuperSUDaemon
chown 0.0 /system/app/Superuser.apk
chmod 0644 /system/app/Superuser.apk
/system/chattr +i /system/etc/install-recovery.sh

rm -f /system/chattr

/sbin/busybox mount -t rootfs -o remount,ro rootfs
mount -o remount,ro /system
