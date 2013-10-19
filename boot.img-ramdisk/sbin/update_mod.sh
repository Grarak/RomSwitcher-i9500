#!/sbin/sh
#
#
#

ROM=$1
MOUNTPOINT=$2
FILE=$3

updater_script_path="META-INF/com/google/android/updater-script"
updater_script_path_original="META-INF/com/google/android/updater-script-original"
echo "mountpoint: $MOUNTPOINT"
echo "file: $FILE"
rm -rf $MOUNTPOINT/rs/*
mkdir -p $MOUNTPOINT/rs || exit 1

if [ ! -s $FILE ] ; then
   echo "could not find the file! Are there spaces in the name or path?"
   exit 2
fi

unzip_binary -o $FILE $updater_script_path -d "$MOUNTPOINT"/rs || exit 1
cp -f "$MOUNTPOINT"/rs/$updater_script_path /"$MOUNTPOINT"/rs/$updater_script_path_original || exit 1

if [ "$ROM" == "secondary" ]; then

   #### use mount script ####
   sed 's|mount("ext4", "EMMC", "/dev/block/mmcblk0p20", "/system");|run_program("/sbin/mount_recovery.sh", "secondary");|g' -i "$MOUNTPOINT"/rs/$updater_script_path || exit 1

   ### also use script for formating ###
   sed 's|format("ext4", "EMMC", "/dev/block/mmcblk0p20", "0", "/system");|run_program("/sbin/system_format.sh", "secondary");|g' -i "$MOUNTPOINT"/rs/$updater_script_path || exit 1

   sed 's|format("ext4", "EMMC", "/dev/block/mmcblk0p20");|run_program("/sbin/system_format.sh", "secondary");|g' -i "$MOUNTPOINT"/rs/$updater_script_path || exit 1

   # get the kernel
   sed 's|package_extract_file("boot.img", "/dev/block/mmcblk0p9");|#|g' -i "$MOUNTPOINT"/rs/$updater_script_path || exit 1

   # busybox mount
   sed 's|run_program("/sbin/busybox", "mount", "/system");|run_program("/sbin/mount_recovery.sh", "secondary");|g' -i "$MOUNTPOINT"/rs/$updater_script_path || exit 1

   sed 's|run_program("/sbin/busybox", "mount", "/data");|run_program("/sbin/mount_recovery.sh", "secondary");|g' -i "$MOUNTPOINT"/rs/$updater_script_path || exit 1

elif [ "$ROM" == "tertiary" ]; then
   #### use mount script ####
   sed 's|mount("ext4", "EMMC", "/dev/block/mmcblk0p20", "/system");|run_program("/sbin/mount_recovery.sh", "tertiary");|g' -i "$MOUNTPOINT"/rs/$updater_script_path || exit 1

   ### also use script for formating ###
   sed 's|format("ext4", "EMMC", "/dev/block/mmcblk0p20", "0", "/system");|run_program("/sbin/system_format.sh", "tertiary");|g' -i "$MOUNTPOINT"/rs/$updater_script_path || exit 1

   sed 's|format("ext4", "EMMC", "/dev/block/mmcblk0p20");|run_program("/sbin/system_format.sh", "tertiary");|g' -i "$MOUNTPOINT"/rs/$updater_script_path || exit 1

   # get the kernel
   sed 's|package_extract_file("boot.img", "/dev/block/mmcblk0p9");|#|g' -i "$MOUNTPOINT"/rs/$updater_script_path || exit 1

   # busybox mount
   sed 's|run_program("/sbin/busybox", "mount", "/system");|run_program("/sbin/mount_recovery.sh", "tertiary");|g' -i "$MOUNTPOINT"/rs/$updater_script_path || exit 1

   sed 's|run_program("/sbin/busybox", "mount", "/data");|run_program("/sbin/mount_recovery.sh", "tertiary");|g' -i "$MOUNTPOINT"/rs/$updater_script_path || exit 1

elif [ "$ROM" == "quaternary" ]; then
   #### use mount script ####
   sed 's|mount("ext4", "EMMC", "/dev/block/mmcblk0p20", "/system");|run_program("/sbin/mount_recovery.sh", "quaternary");|g' -i "$MOUNTPOINT"/rs/$updater_script_path || exit 1

   sed 's|mount("ext4", "EMMC", "/dev/block/mmcblk0p21", "/data");|run_program("/sbin/mount_recovery.sh", "quaternary");|g' -i "$MOUNTPOINT"/rs/$updater_script_path || exit 1

   ### also use script for formating ###
   sed 's|format("ext4", "EMMC", "/dev/block/mmcblk0p20", "0", "/system");|run_program("/sbin/system_format.sh", "quaternary");|g' -i "$MOUNTPOINT"/rs/$updater_script_path || exit 1

   sed 's|format("ext4", "EMMC", "/dev/block/mmcblk0p20");|run_program("/sbin/system_format.sh", "quaternary");|g' -i "$MOUNTPOINT"/rs/$updater_script_path || exit 1

   sed 's|format("ext4", "EMMC", "/dev/block/mmcblk0p20", "0");|run_program("/sbin/system_format.sh", "quaternary");|g' -i "$MOUNTPOINT"/rs/$updater_script_path || exit 1

   # get the kernel
   sed 's|package_extract_file("boot.img", "/dev/block/mmcblk0p9");|#|g' -i "$MOUNTPOINT"/rs/$updater_script_path || exit 1

   sed 's|write_raw_image("/tmp/boot.img", "/dev/block/mmcblk0p9")|#|g' -i "$MOUNTPOINT"/rs/$updater_script_path || exit 1

   # busybox mount
   sed 's|run_program("/sbin/busybox", "mount", "/system");|run_program("/sbin/mount_recovery.sh", "quaternary");|g' -i "$MOUNTPOINT"/rs/$updater_script_path || exit 1

   sed 's|run_program("/sbin/busybox", "mount", "/data");|run_program("/sbin/mount_recovery.sh", "quaternary");|g' -i "$MOUNTPOINT"/rs/$updater_script_path || exit 1

else
   exit 1
   echo "error update_mod.sh"
fi

sed 's|run_program("/sbin/busybox", "mount", "/cache");|#|g' -i "$MOUNTPOINT"/rs/$updater_script_path || exit 1

cd $MOUNTPOINT/rs || exit 1
zip $FILE $updater_script_path || exit 1
mv -f $updater_script_path_original $updater_script_path || exit 1
cd /

umount -f /system
exit 0
