#!/sbin/busybox sh

# define data partition
DATA="/dev/block/mmcblk0p21"

# read what ROM we should boot
ROM=`cat /data/media/.rom`

if [ $ROM != "default" ]; then
	# not default ROM
	# unmount all partitions
	umount -l /data
	umount -l /cache
	umount -l /system

	# mount data as .firstdata
	mkdir -p /.firstdata
	chmod 0771 /.firstdata
	chown system /.firstdata
	chgrp system /.firstdata

	mount -t ext4 $DATA /.firstdata

	case $ROM in
		/external_sd/*) TYPE=EXTERNAL ;;
		*) TYPE=INTERNAL ;;
	esac

	if [ $TYPE == "INTERNAL" ]; then
		# if ROM is in internal storage bind it as folder
		mkdir -p /.firstdata/media/.romswitcher/${ROM}/system
		mkdir -p /.firstdata/media/.romswitcher/${ROM}/data
		mkdir -p /.firstdata/media/.romswitcher/${ROM}/cache

		chmod 0755 /.firstdata/media/.romswitcher/${ROM}/system
		chmod 0771 /.firstdata/media/.romswitcher/${ROM}/data
		chmod 0771 /.firstdata/media/.romswitcher/${ROM}/cache

		chown root /.firstdata/media/.romswitcher/${ROM}/system
		chown system /.firstdata/media/.romswitcher/${ROM}/data
		chown system /.firstdata/media/.romswitcher/${ROM}/cache

		chgrp root /.firstdata/media/.romswitcher/${ROM}/system
		chgrp system /.firstdata/media/.romswitcher/${ROM}/data
		chgrp cache /.firstdata/media/.romswitcher/${ROM}/cache

		mount --bind /.firstdata/media/.romswitcher/${ROM}/system /system
		mount --bind /.firstdata/media/.romswitcher/${ROM}/data /data
		mount --bind /.firstdata/media/.romswitcher/${ROM}/cache /cache
	elif [ $TYPE == "EXTERNAL" ]; then
		# if ROM is in external storage mount it as image
		mount -t ext4 ${ROM}/system.img /system
		mount -t ext4 ${ROM}/data.img /data
		mount -t ext4 ${ROM}/cache.img /cache
	fi

	# setup internal storage for sub ROM
	mkdir -p /data/media
	mount --bind /.firstdata/media /data/media

	echo 2 > /data/.layout_version

	chown media_rw.media_rw /data/media
	chown -R media_rw.media_rw /data/media/*

	# copy RomSwitcher Application
	mkdir -p /data/app
	cp -rf /.firstdata/app/com.grarak.rom.switcher*.apk /data/app/
fi
