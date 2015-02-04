#!/sbin/busybox sh

cd /

# mount proc and sys
mount -t proc proc /proc
mount -t sysfs sys /sys

# create /dev/block
mkdir -p /dev/block

# cache
mknod /dev/block/mmcblk0p19 b 259 11
# system
mknod /dev/block/mmcblk0p20 b 259 12
# data
mknod /dev/block/mmcblk0p21 b 259 13
# external storage
mknod /dev/block/mmcblk1p1 b 179 9

# mount data
mount -t ext4 /dev/block/mmcblk0p21 /data

# exit
out() {
	# umount partitions
	umount -f /system
	umount -f /data

	# set permissions
	chmod 755 /init
	chmod 644 /*.universal5410
	chmod 644 /*.rc
	chmod 644 /*.prop
	chmod -R 755 /lib

	# load actaul RAM disk
	/init
}

# remove knox with this function
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

# check if the device is in recovery mode
# if yes then load RomSwitcher Recovery
if grep -q "bootmode=2" /proc/cmdline || [ -e /data/media/.reboot_recovery ]; then
	rm -f /data/media/.reboot_recovery
	mv -f /res/etc /
	mv -f /res/aosp44/* /
	mv -f /res/recovery/* /
	rm -rf /scripts
	rm -f /init.universal5410.rc
	out
fi

# check if Android system moved the RomSwitcher folder
[ -d /data/media/0/.romswitcher ] && mv -f /data/media/0/.romswitcher /data/media/

# make sure /data/media/.rom exists
# if not then boot primary/default rom
[ -e /data/media/.rom ] || echo default > /data/media/.rom
ROM=`cat /data/media/.rom`

if [ $ROM == "default" ]; then
	# mount default rom
	mount -t ext4 /dev/block/mmcblk0p20 /system
else
	# mount sub ROM
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

# move RAM disks
if [ -e /system/framework/twframework.jar ]; then
	# use TouchWiz RAM disk
	prepareKnox
	mv -f /res/cbd /sbin/
	mv -f /res/sec44/* /

	# check if device is trying to boot MIUI ROM
	[ -e /system/framework/framework-miui-res.apk ] || rm -f init.miui.rc
else
	# use AOSP RAM disk
	
	# remove cbd
	# AOSP has it already in system
	rm -f /res/cbd
	
	# AOSP has different camera paths
	# load TouchWiz's camera blob
	mv -f /res/libexynoscamera.so /system/lib/
	
	if grep -q "ro.build.version.release=5" /system/build.prop; then
		# use AOSP Lollipop
		mv -f /res/aosp50/sbin/* /sbin/
		rm -rf /res/aosp50/sbin
		mv -f /res/aosp50/* /
	else
		# use AOSP KitKat
		mv -f /res/aosp44/* /
	fi

fi

# insert kernel modules
mv -f /lib/modules/*.ko /system/lib/modules/

# exit
out
