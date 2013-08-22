#!/bin/sh

find -name "*~" -exec rm -rf {} \;

cd boot.img-ramdisk
find . | cpio -o -H newc | gzip -9 > ../ramdisk.gz
cd ..
./mkbootimg --kernel zImage --ramdisk ramdisk.gz -o boot.img

cp -v boot.img out/
cd out
zip -r kernel.zip META-INF boot.img
mv -v kernel.zip ../
cd ..
adb push kernel.zip /sdcard/.
