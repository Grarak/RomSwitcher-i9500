#!/bin/sh

build () {
    cd boot.img-ramdisk
    find . | cpio -o -H newc | gzip -9 > ../ramdisk.gz
    cd ..
    ./mkbootimg-$1 --kernel zImage --ramdisk ramdisk.gz -o ../aosp.img
}

if grep -q "export BUILD_MAC_SDK_EXPERIMENTAL=1" ~/.bash_profile; then
    build darwin
else
    build linux
fi
