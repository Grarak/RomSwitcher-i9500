#!/sbin/busybox sh

ROM=`cat /data/media/.rom`
[ -e /data/media/.rom ] || ROM=1

if [ $ROM != "1" ]; then

	while read par path emmc; do
		case $path in
		*data) data=$par ;;
		esac
	done < /res/etc/recovery.fstab

	umount -l /data
	umount -l /cache
	umount -l /system

	mkdir -p /.firstrom
	chmod 0771 /.firstrom
	chown system /.firstrom
	chgrp system /.firstrom

	mount -t ext4 -o rw $data /.firstrom

	mkdir -p /.firstrom/media/.${ROM}rom/system
	mkdir -p /.firstrom/media/.${ROM}rom/data
	mkdir -p /.firstrom/media/.${ROM}rom/cache

	chmod 0755 /.firstrom/media/.${ROM}rom/system
	chmod 0771 /.firstrom/media/.${ROM}rom/data
	chmod 0771 /.firstrom/media/.${ROM}rom/cache

	chown root /.firstrom/media/.${ROM}rom/system
	chown system /.firstrom/media/.${ROM}rom/data
	chown system /.firstrom/media/.${ROM}rom/cache

	chgrp root /.firstrom/media/.${ROM}rom/system
	chgrp system /.firstrom/media/.${ROM}rom/data
	chgrp cache /.firstrom/media/.${ROM}rom/cache

	mount --bind /.firstrom/media/.${ROM}rom/system /system
	mount --bind /.firstrom/media/.${ROM}rom/data /data
	mount --bind /.firstrom/media/.${ROM}rom/cache /cache

	mkdir -p /data/media
	mount --bind /.firstrom/media /data/media

	echo 2 > /data/.layout_version

	chown media_rw.media_rw /data/media
	chown -R media_rw.media_rw /data/media/*

	/scripts/romswitcher.sh $ROM

fi
