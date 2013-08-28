#!/bin/sh

rm -rf kernel.zip
rm -rf ramdisk.gz
find -name "*~" -exec rm -rf {} \;
find -name ".DS_Store" -exec rm -rf {} \;

cd cm
./build.sh
cd ../perseus
./build.sh

cd ..
adb push aosp.img /sdcard/graswitcher/aosp.img
adb push touchwiz.img /sdcard/graswitcher/touchwiz.img
