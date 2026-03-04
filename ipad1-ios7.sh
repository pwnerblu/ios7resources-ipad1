#!/bin/bash

# ---- Resolve script directory ----
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p $SCRIPT_DIR/bins
curl -L -o $SCRIPT_DIR/bins/xpwntool https://github.com/LukeZGD/Legacy-iOS-Kit/raw/refs/heads/main/bin/macos/xpwntool
curl -L -o $SCRIPT_DIR/bins/iBoot32Patcher https://github.com/LukeZGD/Legacy-iOS-Kit/raw/refs/heads/main/bin/macos/iBoot32Patcher
curl -L -o $SCRIPT_DIR/bins/dmg https://github.com/LukeZGD/Legacy-iOS-Kit/raw/refs/heads/main/bin/macos/dmg
curl -L -o $SCRIPT_DIR/bins/ipwnder32 https://github.com/LukeZGD/Legacy-iOS-Kit/raw/refs/heads/main/bin/macos/ipwnder32
curl -L -o $SCRIPT_DIR/bins/img3maker https://github.com/LukeZGD/Legacy-iOS-Kit/raw/refs/heads/main/bin/macos/img3maker
curl -L -o $SCRIPT_DIR/bins/pzb https://github.com/LukeZGD/Legacy-iOS-Kit/raw/refs/heads/main/bin/macos/pzb
curl -L -o $SCRIPT_DIR/bins/irecovery https://github.com/NyanSatan/SundanceInH2A/raw/refs/heads/master/executables/irecovery
curl -L -o $SCRIPT_DIR/bins/idevicerestore https://github.com/NyanSatan/SundanceInH2A/raw/refs/heads/master/executables/idevicerestore
curl -L -o $SCRIPT_DIR/bins/hfsplus https://github.com/NyanSatan/SundanceInH2A/raw/refs/heads/master/executables/hfsplus
curl -L -o $SCRIPT_DIR/dtre/ddt.py https://github.com/NyanSatan/SundanceInH2A/raw/refs/heads/master/dt/ddt.py
chmod +x $SCRIPT_DIR/bins/*
xattr -cr $SCRIPT_DIR/bins/*

echo "iPad 1 haxx"

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 [base ipsw] [target ipsw] [output name]"
    echo ""
    echo "Example:"
    echo "$0 iPad1,1_5.1.1_9B206_Restore.ipsw iPad2,1_7.0_11A465_Restore.ipsw iPad1,1_7.0_11A465_Restore"
    exit 1
fi

BASE_IPSW="$1"
TARGET_IPSW="$2"
OUTPUT_NAME="$3"

echo "Extracting iOS 5 IPSW"
unzip $BASE_IPSW -d $OUTPUT_NAME
echo "Extracting iOS 7 IPSW"
unzip $TARGET_IPSW -d tmp
echo "Processing iBSS and iBEC"
$SCRIPT_DIR/bins/xpwntool $OUTPUT_NAME/Firmware/dfu/iBSS.k48ap.RELEASE.dfu iBSS.dec -iv 9c69f81db931108e8efc268de3f5d94d -k 92f1cc2ca8362740734d69386fa6dde5582e18786777e1f9772d5dd364d873fb
$SCRIPT_DIR/bins/xpwntool $OUTPUT_NAME/Firmware/dfu/iBEC.k48ap.RELEASE.dfu iBEC.dec -iv bde7b0d5cf7861479d81eb23f99d2e9e -k 1ba1f38e6a5b4841c1716c11acae9ee0fb471e50362a3b0dd8d98019f174a2f2
$SCRIPT_DIR/bins/iBoot32Patcher iBSS.dec iBSS.patched --rsa
$SCRIPT_DIR/bins/iBoot32Patcher iBEC.dec iBEC.patched --rsa --debug -b "rd=md0 -v amfi=0xff amfi_get_out_of_my_way=1 cs_enforcement_disable=1 pio-error=0"
$SCRIPT_DIR/bins/img3maker -f iBSS.patched -o $OUTPUT_NAME/Firmware/dfu/iBSS.k48ap.RELEASE.dfu -t ibss
$SCRIPT_DIR/bins/img3maker -f iBEC.patched -o $OUTPUT_NAME/Firmware/dfu/iBEC.k48ap.RELEASE.dfu -t ibec
rm -rf iBSS.dec iBSS.patched iBEC.dec iBEC.patched
echo "Extracting iOS 7 root filesystem"
$SCRIPT_DIR/bins/dmg extract tmp/038-3423-394.dmg rootfs.raw -k 22c8a5554401cf466a2fdcf4f1156bd0b15bcf38d6b04356c3628f5405415debcb1f5061
# todo, potential modifications?
echo "Building root filesystem"
$SCRIPT_DIR/bins/dmg build rootfs.raw $OUTPUT_NAME/038-4291-006.dmg 
rm -rf "rootfs.raw"
echo "Processing DeviceTree"
$SCRIPT_DIR/bins/xpwntool $OUTPUT_NAME/Firmware/all_flash/all_flash.k48ap.production/DeviceTree.k48ap.img3 DeviceTree.raw -iv e0a3aa63dae431e573c9827dd3636dd1 -k 50208af7c2de617854635fb4fc4eaa8cddab0e9035ea25abf81b0fa8b0b5654f
python3.11 $SCRIPT_DIR/dtre/ddt.py apply DeviceTree.raw DeviceTree.patch $SCRIPT_DIR/dtre/hoodoo_innsbruck.diff
$SCRIPT_DIR/bins/img3maker -f DeviceTree.patch -o $OUTPUT_NAME/Firmware/all_flash/all_flash.k48ap.production/DeviceTree.k48ap.img3 -t dtre
rm -rf DeviceTree.raw DeviceTree.patch
echo "Processing restore ramdisk"
$SCRIPT_DIR/bins/xpwntool tmp/038-3465-251.dmg ramdisk.raw -iv 9589205905735ab88c7e129083bb0e3d -k f2acfe16974b1839d06148f1d3d165ce41c26f9accdd2cea90a4d3e4c5a2a02b
$SCRIPT_DIR/bins/hfsplus ramdisk.raw grow 20000000
$SCRIPT_DIR/bins/hfsplus ramdisk.raw rm usr/sbin/asr
$SCRIPT_DIR/bins/hfsplus ramdisk.raw add $SCRIPT_DIR/Ramdisk-stuff/asr usr/sbin/asr
$SCRIPT_DIR/bins/hfsplus ramdisk.raw chmod 100755 usr/sbin/asr
$SCRIPT_DIR/bins/hfsplus ramdisk.raw mv usr/local/share/restore/options.k93.plist usr/local/share/restore/options.k48.plist
$SCRIPT_DIR/bins/img3maker -f ramdisk.raw -o $OUTPUT_NAME/038-4361-021.dmg -t rdsk
rm -rf ramdisk.raw
echo "Downloading iPhone3,1 7.0 kernelcache"
$SCRIPT_DIR/bins/pzb -g kernelcache.release.n90 https://secure-appldnld.apple.com/iOS7/091-9485.20130918.Xa98u/iPhone3,1_7.0_11A465_Restore.ipsw
echo "Replacing kernelcache with iPhone3,1 7.0 kernelcache"
mv kernelcache.release.n90 $OUTPUT_NAME/kernelcache.release.k48
rm -rf "tmp"
echo "Finished"





