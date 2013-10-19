#!/sbin/sh
#
#
#

MOUNTPOINT=$1
FILE=$2

updater_script_path="META-INF/com/google/android/updater-script"

cd $MOUNTPOINT/rs || exit 1
zip $FILE $updater_script_path || exit 1
cd /

exit 0
