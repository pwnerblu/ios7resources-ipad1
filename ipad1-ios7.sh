#!/bin/bash

# ---- Resolve script directory ----
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

URL="https://github.com/pwnerblu/extra-resources-ipad1/releases/download/1.0/dyld.tar"
RESOURCE_DIR="$SCRIPT_DIR/resources"
DYLD_FILE="$RESOURCE_DIR/dyld.tar"
mkdir -p "$RESOURCE_DIR"

if [[ ! -f "$DYLD_FILE" ]]; then
    echo "dyld.tar not found, downloading..."

    MAX_RETRIES=20
    RETRY_DELAY=3
    ATTEMPT=1

    while [[ $ATTEMPT -le $MAX_RETRIES ]]; do
        echo "Download attempt $ATTEMPT..."

        if curl -L --fail --output "$DYLD_FILE" "$URL"; then
            echo "Download successful."
            break
        else
            echo "Download failed."
            rm -f "$DYLD_FILE"
        fi

        ((ATTEMPT++))
        if [[ $ATTEMPT -le $MAX_RETRIES ]]; then
            echo "Retrying in $RETRY_DELAY seconds..."
            sleep "$RETRY_DELAY"
        else
            echo "Failed to download dyld.tar after $MAX_RETRIES attempts."
            exit 1
        fi
    done
else
    echo "dyld.tar already exists, skipping download."
fi

chmod +x $SCRIPT_DIR/restore/tools/*
xattr -cr $SCRIPT_DIR/restore/tools/*

mkdir -p $SCRIPT_DIR/bins
curl -L -o $SCRIPT_DIR/bins/xpwntool https://github.com/LukeZGD/Legacy-iOS-Kit/raw/refs/heads/main/bin/macos/xpwntool
curl -L -o $SCRIPT_DIR/bins/iBoot32Patcher https://github.com/LukeZGD/Legacy-iOS-Kit/raw/refs/heads/main/bin/macos/iBoot32Patcher
curl -L -o $SCRIPT_DIR/bins/dmg https://github.com/LukeZGD/Legacy-iOS-Kit/raw/refs/heads/main/bin/macos/dmg
curl -L -o $SCRIPT_DIR/bins/ipwnder32 https://github.com/LukeZGD/Legacy-iOS-Kit/raw/refs/heads/main/bin/macos/ipwnder32
curl -L -o $SCRIPT_DIR/bins/img3maker https://github.com/LukeZGD/Legacy-iOS-Kit/raw/refs/heads/main/bin/macos/img3maker
curl -L -o $SCRIPT_DIR/bins/pzb https://github.com/LukeZGD/Legacy-iOS-Kit/raw/refs/heads/main/bin/macos/pzb
curl -L -o $SCRIPT_DIR/bins/irecovery https://github.com/NyanSatan/SundanceInH2A/raw/refs/heads/master/executables/Darwin/irecovery
curl -L -o $SCRIPT_DIR/bins/idevicerestore https://github.com/NyanSatan/SundanceInH2A/raw/refs/heads/master/executables/Darwin/idevicerestore
curl -L -o $SCRIPT_DIR/bins/hfsplus https://github.com/NyanSatan/SundanceInH2A/raw/refs/heads/master/executables/Darwin/hfsplus
# These are for untethering it, thanks to NyanSatan
curl -L -o $SCRIPT_DIR/bins/rc.boot https://github.com/NyanSatan/SundanceInH2A/raw/refs/heads/master/rc_boot/rc.boot
curl -L -o $SCRIPT_DIR/bins/exploit.dmg https://github.com/NyanSatan/SundanceInH2A/raw/refs/heads/master/exploit/exploit-k48.dmg
chmod +x $SCRIPT_DIR/bins/*
xattr -cr $SCRIPT_DIR/bins/*

echo "iPad 1 haxx"
echo "Codenamed Snowfinch by Turlum25 - Version 0.3.1-fork"
echo "--------------------------------------------------" 

if [[ "$#" -lt 3 || "$#" -gt 4 ]]; then
    echo "Usage: $0 [base ipsw] [target ipsw] [output name]"
    echo ""
    echo "Example:"
    echo "$0 iPad1,1_5.1.1_9B206_Restore.ipsw iPad2,1_7.0_11A465_Restore.ipsw iPad1,1_7.0_11A465_Restore [--hacktivate]"
    echo "$0 iPod4,1_6.1.6_10B500_Restore.ipsw iPhone3,1_7.0_11A465_Restore.ipsw iPod4,1_7.0_11A465_Restore"
    exit 1
fi

BASE_IPSW="$1"
TARGET_IPSW="$2"
OUTPUT_NAME="$3"

HACKTIVATE=0

if [[ $# -eq 4 ]]; then
    if [[ "$4" == "--hacktivate" ]]; then
        echo "This will automatically hacktivate the restore"
        echo "It is only recommended for cellular models or if normal activation fails on Wi-Fi models."
        echo "Hacktivation will NOT be enabled if you're making a custom 7.x IPSW for iPod touch 4"
        read -p "Press enter to continue with hacktivating the restore"
        HACKTIVATE=1
    else
        echo "Error: Unknown option '$4'"
        exit 1
    fi
fi

touch4_ios7_ipsw(){

echo "Processing iBSS and iBEC"
$SCRIPT_DIR/bins/xpwntool $OUTPUT_NAME/Firmware/dfu/iBSS.n81ap.RELEASE.dfu iBSS.dec -iv daafc6ddd42c8f807000b9c1dd453236 -k 1e68d69064ca17c6717be4fa4ff09a71eba1ad0af2a96df4b99a69f6e7258058
$SCRIPT_DIR/bins/xpwntool $OUTPUT_NAME/Firmware/dfu/iBEC.n81ap.RELEASE.dfu iBEC.dec -iv fb44e5dbd3eb75d20f83c0f14d452346 -k 12a5192b4a2e860a76e9368e18e182e5f9f4809dcba62098fcbbaa63ef998a3c
$SCRIPT_DIR/bins/iBoot32Patcher iBSS.dec iBSS.patched --rsa
$SCRIPT_DIR/bins/iBoot32Patcher iBEC.dec iBEC.patched --rsa --debug -b "rd=md0 -v amfi=0xff amfi_get_out_of_my_way=1 cs_enforcement_disable=1 pio-error=0"
$SCRIPT_DIR/bins/img3maker -f iBSS.patched -o $OUTPUT_NAME/Firmware/dfu/iBSS.n81ap.RELEASE.dfu -t ibss
$SCRIPT_DIR/bins/img3maker -f iBEC.patched -o $OUTPUT_NAME/Firmware/dfu/iBEC.n81ap.RELEASE.dfu -t ibec
rm -rf iBSS.dec iBSS.patched iBEC.dec iBEC.patched
echo "Extracting iOS 7 root filesystem"
$SCRIPT_DIR/bins/dmg extract tmp/038-3447-395.dmg rootfs.raw -k 89d4dadced94577508999a1ce2a08b346328d9b25ad4e63b4220ce441cce35cf9e0a108b
echo "Modifying iOS 7 root filesystem"
$SCRIPT_DIR/bins/hfsplus rootfs.raw grow 2500000000
echo "Adding touch and multitouch drivers"
$SCRIPT_DIR/bins/hfsplus rootfs.raw add $SCRIPT_DIR/resources/N81.mtprops usr/share/firmware/multitouch/N81.mtprops
echo "Adding Wi-Fi drivers"
$SCRIPT_DIR/bins/hfsplus rootfs.raw mkdir usr/share/firmware/wifi/4329c0
$SCRIPT_DIR/bins/hfsplus rootfs.raw add $SCRIPT_DIR/resources/loco.bin usr/share/firmware/wifi/4329c0/uno.bin
$SCRIPT_DIR/bins/hfsplus rootfs.raw add $SCRIPT_DIR/resources/loco.txt usr/share/firmware/wifi/4329c0/uno.txt
echo "Building root filesystem"
$SCRIPT_DIR/bins/dmg build rootfs.raw $OUTPUT_NAME/058-2543-001.dmg
rm -rf "rootfs.raw"
echo "Replacing DeviceTree"
cp $SCRIPT_DIR/dtre/DeviceTree.n81ap.img3 $OUTPUT_NAME/Firmware/all_flash/all_flash.n81ap.production/DeviceTree.n81ap.img3 
echo "Processing restore ramdisk"
$SCRIPT_DIR/bins/xpwntool tmp/038-3373-256.dmg ramdisk.raw -iv 076220ac2c46cd54f1eff12d78f044b2 -k b2101ec5cdd1919c5b0e6dd7116f576ec38b62d9d2880418486fa9f2237e94cc
$SCRIPT_DIR/bins/hfsplus ramdisk.raw grow 20000000
$SCRIPT_DIR/bins/hfsplus ramdisk.raw rm usr/sbin/asr
$SCRIPT_DIR/bins/hfsplus ramdisk.raw add $SCRIPT_DIR/Ramdisk-stuff/asr usr/sbin/asr
$SCRIPT_DIR/bins/hfsplus ramdisk.raw chmod 100755 usr/sbin/asr
$SCRIPT_DIR/bins/hfsplus ramdisk.raw extract usr/local/share/restore/options.n90.plist 
plutil -replace SystemPartitionSize -integer 3000 options.n90.plist
$SCRIPT_DIR/bins/hfsplus ramdisk.raw rm usr/local/share/restore/options.n90.plist 
$SCRIPT_DIR/bins/hfsplus ramdisk.raw add options.n90.plist usr/local/share/restore/options.n81.plist
$SCRIPT_DIR/bins/img3maker -f ramdisk.raw -o $OUTPUT_NAME/058-2540-001.dmg -t rdsk
rm -rf ramdisk.raw options.n90.plist
mv tmp/kernelcache.release.n90 $OUTPUT_NAME/kernelcache.release.n81
rm -rf "tmp"
echo "Finished making bundle"
echo "You can now put the device into pwned DFU with ipwnder32, then restore the device with idevicerestore. Example: ./bins/idevicerestore -e $OUTPUT_NAME"
echo "Assuming the restore succeeded, you can boot with ./boot2.sh"
echo "Note that the device will not activate, so you will need to find a way to skip Setup. I won't be linking to any of these, so figure it out yourself."
exit 0

}


echo "Extracting iOS 5 IPSW"
unzip $BASE_IPSW -d $OUTPUT_NAME
echo "Extracting iOS 7 IPSW"
unzip $TARGET_IPSW -d tmp
SHA_BUILDMANIFEST_BASE=$(shasum -a 256 "$OUTPUT_NAME/BuildManifest.plist" | awk '{print $1}')

if [[ "$SHA_BUILDMANIFEST_BASE" == "cb63d1bc9df84eb756f9fdb3f8654a21d40b14e4c97265e65611b5c160db7cb7" ]]; then
    DEVICE="iPad1,1"
    echo "Continuing with iPad1,1 cfw making"
    echo "Detected device: $DEVICE"
else
    DEVICE="iPod4,1"
    echo "Detected device: $DEVICE"
    touch4_ios7_ipsw
    exit
fi

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
echo "Modifying iOS 7 root filesystem"
$SCRIPT_DIR/bins/hfsplus rootfs.raw grow 2500000000
echo "Removing FaceTime.app"
$SCRIPT_DIR/bins/hfsplus rootfs.raw rmall "Applications/FaceTime.app"
echo "Untarring iPhone3,1 7.0 dyld shared cache"
$SCRIPT_DIR/bins/hfsplus rootfs.raw untar $SCRIPT_DIR/resources/dyld.tar
echo "Removing System/Library/HIDPlugins/CompassPlugIn.plugin"
$SCRIPT_DIR/bins/hfsplus rootfs.raw rmall System/Library/HIDPlugins/CompassPlugIn.plugin
echo "Adding touch and multitouch drivers"
$SCRIPT_DIR/bins/hfsplus rootfs.raw add $SCRIPT_DIR/resources/Common.mtprops usr/share/firmware/multitouch/Common.mtprops
$SCRIPT_DIR/bins/hfsplus rootfs.raw add $SCRIPT_DIR/resources/iPad.mtprops usr/share/firmware/multitouch/iPad.mtprops
echo "Adding Wi-Fi drivers"
$SCRIPT_DIR/bins/hfsplus rootfs.raw mkdir usr/share/firmware/wifi/4329c0
$SCRIPT_DIR/bins/hfsplus rootfs.raw add $SCRIPT_DIR/resources/duo.bin usr/share/firmware/wifi/4329c0/uno.bin
$SCRIPT_DIR/bins/hfsplus rootfs.raw add $SCRIPT_DIR/resources/duo.txt usr/share/firmware/wifi/4329c0/uno.txt
if [[ $HACKTIVATE == 1 ]]; then
    echo "Adding hacktivation"
    $SCRIPT_DIR/bins/hfsplus rootfs.raw add $SCRIPT_DIR/resources/MobileGestalt.plist private/var/mobile/Library/Caches/com.apple.MobileGestalt.plist
else
    echo "Hacktivation disabled, skipping hacktivation"
fi
echo "Building root filesystem"
$SCRIPT_DIR/bins/dmg build rootfs.raw $OUTPUT_NAME/038-4291-006.dmg 
rm -rf "rootfs.raw"
echo "Replacing DeviceTree"
cp $SCRIPT_DIR/dtre/DeviceTree.k48ap.img3 $OUTPUT_NAME/Firmware/all_flash/all_flash.k48ap.production/DeviceTree.k48ap.img3 
echo "Processing restore ramdisk"
$SCRIPT_DIR/bins/xpwntool tmp/038-3465-251.dmg ramdisk.raw -iv 9589205905735ab88c7e129083bb0e3d -k f2acfe16974b1839d06148f1d3d165ce41c26f9accdd2cea90a4d3e4c5a2a02b
$SCRIPT_DIR/bins/hfsplus ramdisk.raw grow 20000000
$SCRIPT_DIR/bins/hfsplus ramdisk.raw rm usr/sbin/asr
$SCRIPT_DIR/bins/hfsplus ramdisk.raw add $SCRIPT_DIR/Ramdisk-stuff/asr usr/sbin/asr
$SCRIPT_DIR/bins/hfsplus ramdisk.raw chmod 100755 usr/sbin/asr
$SCRIPT_DIR/bins/hfsplus ramdisk.raw extract usr/local/share/restore/options.k93.plist 
# Add baseband update skip
plutil -replace SystemPartitionSize -integer 3000 options.k93.plist
/usr/libexec/PlistBuddy -c "Add :UpdateBaseband bool false" options.k93.plist
$SCRIPT_DIR/bins/hfsplus ramdisk.raw rm usr/local/share/restore/options.k93.plist 
$SCRIPT_DIR/bins/hfsplus ramdisk.raw add options.k93.plist usr/local/share/restore/options.k48.plist
echo "Adding untether stuff"
$SCRIPT_DIR/bins/hfsplus ramdisk.raw rm etc/rc.boot
$SCRIPT_DIR/bins/hfsplus ramdisk.raw add $SCRIPT_DIR/bins/rc.boot etc/rc.boot
$SCRIPT_DIR/bins/hfsplus ramdisk.raw chmod 100755 etc/rc.boot
$SCRIPT_DIR/bins/hfsplus ramdisk.raw add $SCRIPT_DIR/bins/exploit.dmg exploit.dmg
$SCRIPT_DIR/bins/img3maker -f ramdisk.raw -o $OUTPUT_NAME/038-4361-021.dmg -t rdsk
rm -rf ramdisk.raw options.k93.plist
echo "Downloading iPhone3,1 7.0 kernelcache"
$SCRIPT_DIR/bins/pzb -g kernelcache.release.n90 https://secure-appldnld.apple.com/iOS7/091-9485.20130918.Xa98u/iPhone3,1_7.0_11A465_Restore.ipsw
mv kernelcache.release.n90 $OUTPUT_NAME/kernelcache.release.k48
rm -rf "tmp"

# BY TURLUM25 - edited this line 
echo "Finished making bundle"

# BY TURLUM25 - this moves bundle and starts 
mv $OUTPUT_NAME $SCRIPT_DIR/restore/iPad1,1_7.0_11A465_Restore
echo "Bundle can be found in $SCRIPT_DIR/restore."
echo "Waiting for 3 seconds before starting restore..."
sleep 3
# BY TURLUM25 - COMPILE SNOWFINCH RESTORE
cd $SCRIPT_DIR/restore && clang Snowfinch.c -o snowfinch
./snowfinch
sudo rm -rf "iPad1,1_7.0_11A465_Restore"
