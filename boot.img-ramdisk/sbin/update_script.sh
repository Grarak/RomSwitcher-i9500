#!/sbin/sh

ROM=$1
MOUNTPOINT=$2
FILE=$3

updater_script_file="META-INF/com/google/android/updater-script"
update_binary_file="META-INF/com/google/android/update-binary"
rm -rf $MOUNTPOINT/rs
mkdir -p $MOUNTPOINT/rs || exit 1

unzip_binary -o $FILE $updater_script_file -d $MOUNTPOINT/rs || exit 1
unzip_binary -o $FILE $update_binary_file -d $MOUNTPOINT/rs || exit 1

cd $MOUNTPOINT/rs
cp -f $updater_script_file ${updater_script_file}_backup

sed -i s/\mount\(\"ext4\".*\)\;/'run_program\("\/sbin\/mount_recovery.sh\"\,\ \"'${ROM}'\"\)\;'/ $updater_script_file
sed -i s/format\(\"ext4\".*\)\;/'run_program\("\/sbin\/system_format.sh\"\,\ \"'${ROM}'\"\)\;'/ $updater_script_file
sed 's|run_program("/sbin/busybox", "mount", "/system");|run_program("/sbin/mount_recovery.sh", "'${ROM}'");|g' -i $updater_script_file
sed 's|run_program("/sbin/busybox", "mount", "/data");|run_program("/sbin/mount_recovery.sh", "'${ROM}'");|g' -i $updater_script_file
sed 's|run_program("/sbin/busybox", "mount", "/cache");|run_program("/sbin/mount_recovery.sh", "'${ROM}'");|g' -i $updater_script_file
sed -i s/.*\"boot.img\".*\)\;/#/ $updater_script_file
sed -i s/.*getprop.*/#/ $updater_script_file

zip $FILE $updater_script_file || exit 1
mv -f ${updater_script_file}_backup $updater_script_file

if grep -q SuperSU $update_binary_file ; then
	cp -f $update_binary_file ${update_binary_file}_backup
	sed 's|mount /system|mount_recovery.sh '${ROM}'|g' -i $updater_script_file
	sed 's|mount /data|ui_print "Installing SuperSU to ROM '${ROM}'"|g' -i $updater_script_file
	zip $FILE $update_binary_file || exit 1
	mv -f ${update_binary_file}_backup $update_binary_file
else
	rm -f $update_binary_file
fi

cd /


exit 0
