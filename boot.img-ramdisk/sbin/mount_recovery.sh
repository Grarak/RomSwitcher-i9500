#!/sbin/sh

#
#
# mount filesystem

BB="busybox"
MOUNT="busybox mount"
UMOUNT="busybox umount -f"

BLOCKDEVICE=mmcblk0p21 #data
CACHEPARTITION=mmcblk0p19 #cache
SYSTEMPARTITION=mmcblk0p20 #system

########## if called with umount parameter, just umount everything and exit ######################
if [ "$1" == "primary" ] ; then
   $UMOUNT /system
   $UMOUNT /.firstrom
   $UMOUNT /.firstcache

   $BB mkdir -p /data
   $BB mkdir -p /cache
   $MOUNT -t ext4 -o rw /dev/block/$BLOCKDEVICE /data
   $MOUNT -t ext4 -o rw /dev/block/$CACHEPARTITION /cache
   $MOUNT -t ext4 -o rw /dev/block/$SYSTEMPARTITION /system
	
elif [ "$1" == "secondary" ] ; then
   $UMOUNT /system
   $UMOUNT /data
   $UMOUNT /cache

   $BB mkdir -p /.firstrom
   $BB mkdir -p /.firstcache
   $MOUNT -t ext4 -o rw /dev/block/$BLOCKDEVICE /.firstrom
   $MOUNT -t ext4 -o rw /dev/block/$CACHEPARTITION /.firstcache

   $BB mkdir -p /data
   $BB mkdir -p /.firstrom/media/.secondrom/data
   $MOUNT --bind /.firstrom/media/.secondrom/data /data

   $BB mkdir -p /cache
   $BB mkdir -p /.firstrom/media/.secondrom/cache
   $MOUNT --bind /.firstrom/media/.secondrom/cache /cache

   $BB mkdir -p /data/media
   $MOUNT --bind /.firstrom/media /data/media

   $BB mkdir -p /system
   $MOUNT -t ext4 -o rw /.firstrom/media/.secondrom/system.img /system

elif [ "$1" == "tertiary" ] ; then
   $UMOUNT /system
   $UMOUNT /data
   $UMOUNT /cache

   $BB mkdir -p /.firstrom
   $BB mkdir -p /.firstcache
   $MOUNT -t ext4 -o rw /dev/block/$BLOCKDEVICE /.firstrom
   $MOUNT -t ext4 -o rw /dev/block/$CACHEPARTITION /.firstcache

   $BB mkdir -p /data
   $BB mkdir -p /.firstrom/media/.thirdrom/data
   $MOUNT --bind /.firstrom/media/.thirdrom/data /data

   $BB mkdir -p /cache
   $BB mkdir -p /.firstrom/media/.thirdrom/cache
   $MOUNT --bind /.firstrom/media/.thirdrom/cache /cache

   $BB mkdir -p /data/media
   $MOUNT --bind /.firstrom/media /data/media

   $BB mkdir -p /system
   $MOUNT -t ext4 -o rw /.firstrom/media/.thirdrom/system.img /system

else
   echo "missing paramter"
   exit 1
fi

exit 0
