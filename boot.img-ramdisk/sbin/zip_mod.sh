#!/sbin/sh

MOUNTPOINT=$1
FILE=$2

updater_script_file="META-INF/com/google/android/updater-script"
update_binary_file="META-INF/com/google/android/update-binary"

cd $MOUNTPOINT/rs || exit 1
zip $FILE $updater_script_file || exit 1
if [ -f $update_binary_file ]; then
	zip $FILE $update_binary_file || exit 1
fi
cd /

exit 0
