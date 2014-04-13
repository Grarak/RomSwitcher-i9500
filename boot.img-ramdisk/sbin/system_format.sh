#!/sbin/sh

BB="busybox"
ROM=$1

if $BB grep -q /data /proc/mounts; then
	system=/data/media/.${ROM}rom/system
else
	system=/.firstrom/media/.${ROM}rom/system
fi

$BB umount -l /system
$BB mkdir -p /system

$BB mount --bind $system /system || exit 1
$BB rm -rf /system/*
$BB rm -rf /system/.*

exit 0
