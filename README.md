# ios7-ipad1

A project to restore and boot iOS 7.0 (11A465) on the iPad 1st Generation, this also includes resources for it as well.

This is a proof of concept, not a finished project.

All binaries/additional tools used are fetched remotely and are not included in this repository.

This does NOT support Linux yet. Make sure to have python 3.11 installed too (standalone), get it from https://www.python.org/downloads/release/python-3110/.

Please read current known issues before proceeding.

On Apple Silicon, install Rosetta 2 before proceeding.

# Known issues:

SpringBoard crashes constantly

And potentially other things.

# Is this untethered?

Not yet, but since 5.1.1 iBoot has a bug in the HFS+ driver, it can technically be untethered (though SpringBoard, among other issues need to be fixed first before untethering it).

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

After the restore completes, the device should be stuck in recovery mode. You can now boot it with this command.

`./boot.sh`

# Some of the tools used

ipwnder32 - dora2ios

idevicerestore, libirecovery - libimobiledevice










