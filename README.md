# ios7-ipad1

A script that makes a restore bundle and installs iOS 7.0 on iPad 1

This is still not a full finished project.

# Support

Currently, this project only supports macOS 10.13 High Sierra and up in Intel processors (you can also run this on Apple Silicon if you install Rosetta 2) and does not support Linux yet. 

# Known issues

Bluetooth, audio, and keyboard does not work and SpringBoard may crash sometimes. 

Control Center also does not work.

Baseband querying may fail on cellular iPad 1 during restore. (Just patched, uncertain if it may happen)

# Is this untethered?

Yes! This uses the 5.1.1 iBoot exploit to untether it.

# IPSWs to download

[iPad 1, 5.1.1 (9B206)](https://secure-appldnld.apple.com/iOS5.1.1/041-4292.02120427.Tkk0d/iPad1,1_5.1.1_9B206_Restore.ipsw)

[iPad 2, 7.0 (11A465)](https://secure-appldnld.apple.com/iOS7/091-9464.20130918.jozAF/iPad2,1_7.0_11A465_Restore.ipsw)

# Usage

Set permissions first: `chmod +x *.sh`

~~Also make sure to compile Snowfinch: `python3 compile.py`~~ Automatic compiling of Snowfinch was added as of now.

Set permissions for the other tools: `chmod +x restore/tools/*` and `xattr -cr restore/tools/*`

`./ipad1-ios7.sh iPad1,1_5.1.1_9B206_Restore.ipsw iPad2,1_7.0_11A465_Restore.ipsw iPad1,1_7.0_11A465_Restore`

After the creation of the bundle, the program will automatically restore with the bundle to the iPad 1.

After completion of restore, it should boot untethered. Though if it does not boot, please use:

`./boot.sh`

# Some of the tools used

ipwnder32 - dora2ios

idevicerestore, libirecovery - libimobiledevice

# Thanks to

NyanSatan - DT diffing tool, and some of the diff itself. Also for rc.boot and exploit.dmg, which is used for untethering it.

Tuanem - Fixing some issues 

turlum25 - Snowfinch




