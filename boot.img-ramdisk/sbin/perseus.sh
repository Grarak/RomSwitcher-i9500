#!/sbin/busybox sh

mount -o remount,rw /system
/sbin/busybox mount -t rootfs -o remount,rw rootfs

if [ ! -f /system/xbin/su ]; then
	mv /res/su /system/xbin/su
fi

chown 0.0 /system/xbin/su
chmod 06755 /system/xbin/su
ln -s /system/xbin/su /system/bin/su

if [ ! -f /system/app/Superuser.apk ]; then
	mv /res/Superuser.apk /system/app/Superuser.apk
fi

chown 0.0 /system/app/Superuser.apk
chmod 0644 /system/app/Superuser.apk

echo 2 > /sys/devices/system/cpu/sched_mc_power_savings

for i in /sys/block/*/queue/add_random;do echo 0 > $i;done

echo 0 > /proc/sys/kernel/randomize_va_space

echo "0x0FA4 0x0404 0x0170 0x1DB9 0xF233 0x040B 0x08B6 0x1977 0xF45E 0x040A 0x114C 0x0B43 0xF7FA 0x040A 0x1F97 0xF41A 0x0400 0x1068" > /sys/class/misc/wolfson_control/eq_sp_freqs

echo 11 > /sys/class/misc/wolfson_control/eq_sp_gain_1
echo -7 > /sys/class/misc/wolfson_control/eq_sp_gain_2
echo 4 > /sys/class/misc/wolfson_control/eq_sp_gain_3
echo -10 > /sys/class/misc/wolfson_control/eq_sp_gain_4
echo -0 > /sys/class/misc/wolfson_control/eq_sp_gain_5

echo 1 > /sys/class/misc/wolfson_control/switch_eq_speaker

echo 480 > /sys/devices/platform/pvrsrvkm.0/sgx_dvfs_max_lock
echo 50 > /sys/class/devfreq/exynos5-busfreq-mif/polling_interval
echo 70 > /sys/class/devfreq/exynos5-busfreq-mif/time_in_state/upthreshold

copySynapse() {
	cat /res/synapse/Synapse.apk > /system/app/Synapse.apk
	chown 0.0 /system/app/Synapse.apk
	chmod 644 /system/app/Synapse.apk
}

if [ ! -f /data/nosynapse ]; then
	if [  ! -f /system/app/Synapse.apk ]; then
		copySynapse
	else
		R5=$(md5sum < /res/synapse/Synapse.apk | tr -d ' -')
		S5=$(md5sum < /system/app/Synapse.apk | tr -d ' -')
		if [ $R5 != $S5 ]; then
			copySynapse
		fi
	fi
fi

mkdir -p /mnt/ntfs
chmod 777 /mnt/ntfs
mount -o mode=0777,gid=1000 -t tmpfs tmpfs /mnt/ntfs

ln -s /res/synapse/uci /sbin/uci
/sbin/uci

if [ -d /system/etc/init.d ]; then
	/sbin/busybox run-parts /system/etc/init.d
fi;

/sbin/busybox mount -t rootfs -o remount,ro rootfs
mount -o remount,ro /system
