# ios7-ipad1

A project to restore and boot iOS 7.0 (11A465) on the iPad 1st Generation, this also includes resources for it as well.

**This script will automatically hacktivate the restore, as proper activation does not work yet.**

This is a proof of concept, not a finished project.

All binaries/additional tools used are fetched remotely and are not included in this repository.

This does NOT support Linux yet.

Please read current known issues before proceeding.

On Apple Silicon, install Rosetta 2 before proceeding.

# Known issues:

Bluetooth and Audio does not work. SpringBoard may crash sometimes though. Keyboard does not work.

Baseband querying will fail on cellular iPad 1 during restore.

# Is this untethered?

Yes! This uses the 5.1.1 iBoot exploit to untether it.

# IPSWs to download?

[iPad 1, 5.1.1 (9B206)](https://secure-appldnld.apple.com/iOS5.1.1/041-4292.02120427.Tkk0d/iPad1,1_5.1.1_9B206_Restore.ipsw)

[iPad 2, 7.0 (11A465)](https://secure-appldnld.apple.com/iOS7/091-9464.20130918.jozAF/iPad2,1_7.0_11A465_Restore.ipsw)

# Usage:

Set permissions first: `chmod +x *.sh`

`./ipad1-ios7.sh iPad1,1_5.1.1_9B206_Restore.ipsw iPad2,1_7.0_11A465_Restore.ipsw iPad1,1_7.0_11A465_Restore`

Note that this restore bundle is not compressed, though modern `idevicerestore` can handle extracted IPSW's just fine.

After the custom restore bundle is created, you can use `ipwnder32` by dora2ios to enter pwned DFU mode, then restore the device with `idevicerestore`

`./bins/ipwnder32 -p`

`./bins/idevicerestore -e iPad1,1_7.0_11A465_Restore`

~~After the restore completes, the device should be stuck in recovery mode. You can now boot it with this command.~~

`./boot.sh`

# Some of the tools used

ipwnder32 - dora2ios

idevicerestore, libirecovery - libimobiledevice

# Thanks to

NyanSatan - DT diffing tool, and some of the diff itself. Also for rc.boot and exploit.dmg, which is used for untethering it.

Tuanem - Fixing some issues 






