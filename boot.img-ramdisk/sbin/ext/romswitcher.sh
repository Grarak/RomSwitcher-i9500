#!/sbin/busybox sh

ROM=$1

mkdir -p /romswitcher
mkdir -p /.firstrom/media/0/romswitcher
mount --bind /.firstrom/media/0/romswitcher /romswitcher

mkdir -p /.firstrom/media/.${ROM}rom/data/app
cp -f /.firstrom/app/com.grarak.*.apk /.firstrom/media/.${ROM}rom/data/app/
chmod 755 /.firstrom/media/.${ROM}rom/data/app/*.apk

if [ "$ROM" != "1" ] && [ -f /romswitcher/appsharing ]; then
	echo "" >> /romswitcher/appsharing
	while read ROM1 ROM2; do
		if [ "$ROM2" == "$ROM" ]; then
			mkdir -p /data/app
			mkdir -p /data/app-asec
			mkdir -p /data/misc/systemkeys
			if [ "$ROM1" == "1" ]; then
				mount --bind /.firstrom/app /data/app
				mount --bind /.firstrom/app-asec /data/app-asec
				mount --bind /.firstrom/misc/systemkeys /data/misc/systemkeys
			else
				mount --bind /data/media/.${ROM1}rom/data/app /data/app
				mount --bind /data/media/.${ROM1}rom/data/app-asec /data/app-asec
				mount --bind /data/media/.${ROM1}rom/data/misc/systemkeys /data/misc/systemkeys
			fi
		fi
	done < /romswitcher/appsharing
fi
