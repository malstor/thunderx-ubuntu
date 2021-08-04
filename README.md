# thunderx-ubuntu
Installing Ubuntu on Cavium ThunderX ARM64 MT30-GS1/ MT30-GS0

----------

Hacky way for a more recent kernel:
Downgrade to the T49 BIOS version, F02 has some fixes for pantsdown, however it seems to cause some issues with the main ubuntu kernels available; the issue is the shared BMC memory.

MT30-GS1
Use Ubuntu 18.04.3 and hold the kernel at 4.15.0-45-generic
Set the following boot flags at install: 
`console=tty0 immou.passthrough=1 acpi=force` 

#with other kernels, if you have issues, after installing add: 
`arm-smmu.disable_bypass=n`

MT30-GS0
Use Ubuntu 18.04.1 to install and update to the latest version via apt update/upgrade update to the 4.15.0-129-generic kernel after the install. 
Set the following boot flags: 
`console=tty0 immou.passthrough=1 arm-smmu.disable_bypass=n acpi=force`

For both boards use manual partitions, create a 512MB BIOS boot area, 2GB EFI, and the remainder btrfs /

Delete the firmware module in the /lib/firmware/cavium folder cnx55 or whatever and install the firmware in this repo.

Download the firmware modules and makefile to a folder and do:
make && make install

Without these modules to offload crypto, there were race conditions that manifest in apps like Docker, or any app that uses streaming hash functions in Go, it would result in an "Unexpected EOF" error message. By offloading the crypto to silicon it fixes the issue. 

----------
Tips:

Disable hw offloading if you have network errors, in praticular, so some reason checksums errors with applications like elasticsearch are common without disabling this. 

`ethtool --offload enP2p1s0f4 rx off  tx off`

`ethtool --offload docker0 rx off tx off`

----------
Useful Links:

https://old-releases.ubuntu.com/releases/xenial/ubuntu-16.04-server-amd64.iso

https://download.gigabyte.com/FileList/Firmware/server_mb_firmware_ast2400_marvell.zip

https://download.gigabyte.com/FileList/BIOS/server_system_bios_r120-t3x_f02.zip

https://patchwork.kernel.org/project/linux-arm-msm/patch/20190301192017.39770-1-dianders@chromium.org/
