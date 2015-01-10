#!/sbin/busybox sh

cd /

mount -t proc proc /proc
mount -t sysfs sys /sys

mkdir -p /dev/block

for i in 0 1 2; do
	block=$((19+$i))
	minor=$((11+$i))
	mknod /dev/block/mmcblk0p$block b 259 $minor
done
mknod /dev/block/mmcblk1p1 b 179 9

mount -t ext4 /dev/block/mmcblk0p21 /data

out() {
	umount -f /external_sd
	rm -rf /external_sd
	umount -f /system
	umount -f /data

	chmod 755 /init
	chmod 644 /*.universal5410
	chmod 644 /*.rc
	chmod 644 /*.prop
	chmod -R 755 /lib

	/init
}

prepareKnox() {
	sed 's|ro.securestorage.knox=true|ro.securestorage.knox=false|g' -i /system/build.prop
	sed 's|ro.build.selinux=1|ro.build.selinux=0|g' -i /system/build.prop
	sed 's|ro.config.knox=1|ro.config.knox=0|g' -i /system/build.prop
	sed 's|ro.config.tima=1|ro.config.tima=0|g' -i /system/build.prop

	APKS="KNOXAgent.apk KNOXAgent.odex KnoxAttestationAgent.apk KnoxAttestationAgent.odex KNOXStore.apk KNOXStore.odex KNOXStub.apk ContainerAgent.apk ContainerAgent.odex KLMSAgent.apk KLMSAgent.odex ContainerEventsRelayManager.apk ContainerEventsRelayManager.odex"

	for APK in $APKS; do
		if [ -f /system/app/$APK ]; then
			rm -f /system/app/$APK
		fi
	done
}

if grep -q "bootmode=2" /proc/cmdline || [ -e /data/media/.reboot_recovery ]; then
	rm -f /data/media/.reboot_recovery
	mv -f /res/etc /
	mv -f /res/aosp44/* /
	mv -f /res/recovery/* /
	rm -rf /scripts
	rm -f /init.universal5410.rc
	out
fi

[ -d /data/media/0/.romswitcher ] && mv -f /data/media/0/.romswitcher /data/media/
[ -e /data/media/.rom ] || echo default > /data/media/.rom
ROM=`cat /data/media/.rom`

if [ $ROM == "default" ]; then
	mount -t ext4 /dev/block/mmcblk0p20 /system
else
	case $ROM in
		/external_sd/*)
			mkdir -p /external_sd
			mount /dev/block/mmcblk1p1 /external_sd
			mount -t ext4 -o rw $ROM/system.img /system
			;;
		*)
			mount --bind /data/media/.romswitcher/${ROM}/system /system
			;;
	esac
fi

if [ -e /system/framework/twframework.jar ]; then
	prepareKnox
	mv -f /res/cbd /sbin/
	mv -f /res/sec44/* /

	[ -e /system/framework/framework-miui-res.apk ] || rm -f init.miui.rc
else
	rm -f /res/cbd
	mv -f /res/libexynoscamera.so /system/lib/
	if grep -q "ro.build.version.release=5" /system/build.prop; then
		mv -f /res/aosp50/sbin/* /sbin/
		rm -rf /res/aosp50/sbin
		mv -f /res/aosp50/* /
	else
		mv -f /res/aosp44/* /
	fi

fi

mv -f /lib/modules/*.ko /system/lib/modules/

out
