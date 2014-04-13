#!/sbin/sh

BB="busybox"
MOUNT="busybox mount"
UMOUNT="busybox umount -l"
ROM=$1

while read par path emmc; do
	case $path in
	*system) system=$par ;;
	*data) data=$par ;;
	*cache) cache=$par ;;
	esac
done < /etc/recovery.fstab

echo $SYSTEM

if [ $ROM == "0" ]; then

	$UMOUNT /system
	$UMOUNT /data/media
	$UMOUNT /data
	$UMOUNT /.firstrom
	$UMOUNT /.firstcache

	$BB mkdir -p /data
	$BB mkdir -p /cache
	$MOUNT -t ext4 -o rw $data /data
	$MOUNT -t ext4 -o rw $cache /cache
else

	$UMOUNT /system
	$UMOUNT /data
	$UMOUNT /cache

	$BB mkdir -p /.firstrom
	$BB mkdir -p /.firstcache
	$MOUNT -t ext4 -o rw $data /.firstrom
	$MOUNT -t ext4 -o rw $cache /.firstcache

	$BB mkdir -p /data
	$BB mkdir -p /.firstrom/media/.${ROM}rom/data
	$MOUNT --bind /.firstrom/media/.${ROM}rom/data /data

	$BB mkdir -p /cache
	$BB mkdir -p /.firstrom/media/.${ROM}rom/cache
	$MOUNT --bind /.firstrom/media/.${ROM}rom/cache /cache

	$BB mkdir -p /data/media
	$MOUNT --bind /.firstrom/media /data/media

	$BB mkdir -p /system
	$BB mkdir -p /.firstrom/media/.${ROM}rom/system
	$MOUNT --bind /.firstrom/media/.${ROM}rom/system /system
fi

exit 0
