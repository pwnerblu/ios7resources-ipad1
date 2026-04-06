# ios7-ipad1

A script that makes a restore bundle and installs iOS 7.0 on iPad 1 and iPod touch 4

## NOTE, IT IS RECOMMENDED TO USE [THE FORK BY AMY-AND-NICOLE](https://github.com/amy-and-nicole/ipad-1-ios-7) instead, this FORK has a ton of fixes

This is still not a full finished project.

For support, join LegacyJailbreak's discord server.

# Support

Currently, this project only supports macOS 10.13 High Sierra and up in Intel processors (you can also run this on Apple Silicon if you install Rosetta 2) and does not support Linux yet. 

# Known issues

Bluetooth, audio, and keyboard does not work and SpringBoard may crash sometimes. Keyboard works fine though on iPod touch 4.

Control Center also does not work on iPad 1, works fine on iPod touch 4.

Baseband querying may fail on cellular iPad 1 during restore. (Just patched, uncertain if it may happen)

Activation will not work on Cellular iPad 1, though activation may work fine on iPad 1 Wi-Fi models. (there is a hacktivation option for cellular iPad 1 though), iPod touch 4 cannot activate either.

# Is this untethered?

For the iPad 1, yes! This uses the 5.1.1 iBoot exploit to untether it.

For the iPod touch 4, no, you need to tether boot it afterwards with `./boot2.sh`

# iPad 1 uses iPad2,1 firmware

[iPad 1, 5.1.1 (9B206)](https://secure-appldnld.apple.com/iOS5.1.1/041-4292.02120427.Tkk0d/iPad1,1_5.1.1_9B206_Restore.ipsw)

[iPad 2, 7.0 (11A465)](https://secure-appldnld.apple.com/iOS7/091-9464.20130918.jozAF/iPad2,1_7.0_11A465_Restore.ipsw)

# iPod touch 4 uses iPhone3,1 firmware

[iPod touch 4, 6.1.6 (10B500)](https://secure-appldnld.apple.com/iOS6.1/031-3211.20140221.Placef/iPod4,1_6.1.6_10B500_Restore.ipsw)

[iPhone 4, 7.0 (11A465)](https://secure-appldnld.apple.com/iOS7/091-9485.20130918.Xa98u/iPhone3,1_7.0_11A465_Restore.ipsw)

# Usage

Set permissions first: `chmod +x *.sh`

~~Also make sure to compile Snowfinch: `python3 compile.py`~~ Automatic compiling of Snowfinch was added as of now.

Set permissions for the other tools: `chmod +x restore/tools/*` and `xattr -cr restore/tools/*`

For iPad 1, run:

`./ipad1-ios7.sh iPad1,1_5.1.1_9B206_Restore.ipsw iPad2,1_7.0_11A465_Restore.ipsw iPad1,1_7.0_11A465_Restore`

For iPod touch 4, run:

`./ipad1-ios7.sh iPod4,1_6.1.6_10B500_Restore.ipsw iPhone3,1_7.0_11A465_Restore.ipsw iPod4,1_7.0_11A465_Restore`

If activation fails, or if your iPad 1 is a cellular model, run this instead:

`./ipad1-ios7.sh iPad1,1_5.1.1_9B206_Restore.ipsw iPad2,1_7.0_11A465_Restore.ipsw iPad1,1_7.0_11A465_Restore --hacktivate`

After the creation of the bundle, the program will automatically restore with the bundle to the iPad 1. For the iPod touch 4, you need to pwn the device with ipwnder32, then restore the device with idevicerestore: `./bins/idevicerestore -e iPod4,1_7.0_11A465_Restore`

After completion of restore, it should boot untethered (iPad 1, iPod touch 4 needs tether boot with `./boot2.sh`. Though if iPad 1 does not boot, please use:

`./boot.sh`

# Some of the tools used

ipwnder32 - dora2ios

idevicerestore, libirecovery - libimobiledevice

# Thanks to

NyanSatan - DT diffing tool, and some of the diff itself. Also for rc.boot and exploit.dmg, which is used for untethering it.

Tuanem - Fixing some issues on iOS 7 iPad 1

Ralph0045 - The one that originally ported iOS 7 to the iPod touch 4

turlum25 - Snowfinch




