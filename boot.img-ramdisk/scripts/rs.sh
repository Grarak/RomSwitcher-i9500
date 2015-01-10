#!/sbin/busybox sh

ROM=$1

case $ROM in
	/external_sd/*) TYPE=EXTERNAL ;;
	*) TYPE=INTERNAL ;;
esac

mkdir -p /data/app
cp -rf /.firstdata/app/com.grarak.*.apk /data/app/
chmod 755 /data/app/*.apk
