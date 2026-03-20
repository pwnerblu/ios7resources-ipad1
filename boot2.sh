#!/bin/bash

# ---- Resolve script directory ----
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

$SCRIPT_DIR/bins/pzb -g Firmware/dfu/iBSS.n81ap.RELEASE.dfu https://secure-appldnld.apple.com/iOS6.1/031-3211.20140221.Placef/iPod4,1_6.1.6_10B500_Restore.ipsw
$SCRIPT_DIR/bins/pzb -g Firmware/dfu/iBEC.n81ap.RELEASE.dfu https://secure-appldnld.apple.com/iOS6.1/031-3211.20140221.Placef/iPod4,1_6.1.6_10B500_Restore.ipsw
$SCRIPT_DIR/bins/pzb -g kernelcache.release.n90 https://secure-appldnld.apple.com/iOS7/091-9485.20130918.Xa98u/iPhone3,1_7.0_11A465_Restore.ipsw
$SCRIPT_DIR/bins/xpwntool iBSS.n81ap.RELEASE.dfu iBSS.dec -iv daafc6ddd42c8f807000b9c1dd453236 -k 1e68d69064ca17c6717be4fa4ff09a71eba1ad0af2a96df4b99a69f6e7258058
$SCRIPT_DIR/bins/xpwntool iBEC.n81ap.RELEASE.dfu iBEC.dec -iv fb44e5dbd3eb75d20f83c0f14d452346 -k 12a5192b4a2e860a76e9368e18e182e5f9f4809dcba62098fcbbaa63ef998a3c
$SCRIPT_DIR/bins/iBoot32Patcher iBSS.dec iBSS.patched --rsa
$SCRIPT_DIR/bins/iBoot32Patcher iBEC.dec iBEC.patched --rsa --ticket --debug -b "-v pio-error=0"
$SCRIPT_DIR/bins/img3maker -f iBSS.patched -o iBSS -t ibss
$SCRIPT_DIR/bins/img3maker -f iBEC.patched -o iBEC -t ibec
rm -rf iBSS.dec iBSS.patched iBEC.dec iBEC.patched
$SCRIPT_DIR/bins/ipwnder32 -p
$SCRIPT_DIR/bins/irecovery -f iBSS
sleep 4
$SCRIPT_DIR/bins/irecovery -f iBEC 
sleep 4
$SCRIPT_DIR/bins/irecovery -f $SCRIPT_DIR/dtre/DeviceTree.n81ap.img3
$SCRIPT_DIR/bins/irecovery -c devicetree
$SCRIPT_DIR/bins/irecovery -f kernelcache.release.n90
$SCRIPT_DIR/bins/irecovery -c bootx
