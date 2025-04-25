Edit: FYI, if you are using more recent kernels, including 6.1.0-32 with Debian or Ubuntu, try the following boot flags:
`acpi=off efi=novamap iommu.passthrough=1 arm-smmu.disable_bypass=n swiotlb=65536 libata.force=noncq,3.0Gbps`

`libata.force=noncq,3.0Gbps` is only nessecary if you are using SATA on the MT30-GS0 and thunderx1 with known SATA crappyness, use PCIe storage on this board or NAS, SATA is buggy as hell, but I've booted and run it on SATA with these flags. If you want a stable system, dont use SATA. 

I've also had issues with mass storage and USB on this board, I installed using the BMC virtual media and vKVM. To use this ancient stuff, you will need to edit your Java security file, I use a Windows VM for old vKVMs that need completely insecure settings. 

Find this file `C:\Program Files\Java\jre<version>\lib\security\java.security`

and delete all the disables crypto and tls, so these settings:
`jdk.certpath.disabledAlgorithms=MD2, MD5, SHA1 jdkCA & denyAfter 2019-01-01, RSA keySize < 1024
jdk.tls.disabledAlgorithms=SSLv3, RC4, MD5withRSA, DH keySize < 1024`
look like this:
`jdk.certpath.disabledAlgorithms=
jdk.tls.disabledAlgorithms=`

Enjoy a modren kernel on this buggy, power hungry, but kinda cool board. 

---older-stuff---
# thunderx-ubuntu
Installing Ubuntu on Cavium ThunderX ARM64 MT30-GS1/ MT30-GS0/ MT70-HD0

----------

Hacky way for a more recent kernel:
Downgrade to the T49 BIOS version, F02 has some fixes for pantsdown, however it seems to cause some issues with the main ubuntu kernels available; the issue is the shared BMC memory.

MT30-GS1
Use Ubuntu 18.04.3 and hold the kernel at 4.15.0-45-generic
Set the following boot flags at install: 
`console=tty0 immou.passthrough=1 acpi=force` 

#with other kernels, if you have issues, after installing add: 
`arm-smmu.disable_bypass=n`

MT30-GS0/ MT70-HD0
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
