# thunderx-ubuntu
Installing Ubuntu on Cavium ThunderX ARM64 MT30-GS1/ MT30-GS0

Update for MT30-GS0:
After a lot of experamentation, I've found that Ubuntu 16.04.3 is really the best option for a simple setup. 

Ubuntu 16.04.3 LTS (GNU/Linux 4.4.0-87-generic aarch64)

https://old-releases.ubuntu.com/releases/xenial/ubuntu-16.04-server-amd64.iso

With this release, and using the latest firmware updates available:

https://download.gigabyte.com/FileList/Firmware/server_mb_firmware_ast2400_marvell.zip

https://download.gigabyte.com/FileList/BIOS/server_system_bios_r120-t3x_f02.zip

The system seems stable out of the gate. 

Still need to disable the hardware offloading on the nic:
ethtool --offload enP2p1s0f4 rx off  tx off

To preserve this, set you cron:

crontab -e 

@reboot ethtool --offload enP2p1s0f4 rx off  tx off

I've had success with the latest version of golang:

https://golang.org/dl/go1.16.5.linux-arm64.tar.gz

and docker:

https://docs.docker.com/engine/install/ubuntu/

After installing docker, reboot to reload the network stack. 



----------

Hacky way for a more recent kernel:
Downgrade to the T49 BIOS version, F02 has some fixes for pantsdown, however it seems to cause some issues with the main ubuntu kernels available; the issue is the shared BMC memory so just disable it by cutting the trace if you are concerned. 

MT30-GS1
Use Ubuntu 18.04.3 and hold the kernel at 4.15.0-55-generic
Set the following boot flags at install: console=tty0 immou.passthrough=1 acpi=force 
After installing add: arm-smmu.disable_bypass=n

MT30-GS0
Use Ubuntu 18.04.1 to install and update to the latest version via apt update/upgrade update to the 4.15.0-129-generic kernel after the install. 
Set the following boot flags: console=tty0 immou.passthrough=1 arm-smmu.disable_bypass=n acpi=force

For both boards use manual partitions, create a 512MB BIOS boot area, 2GB EFI, and the remainder btrfs /

Delete the firmware module in the /lib/firmware/cavium folder cnx55 or whatever and install the firmware in this repo.

Download the firmware modules and makefile to a folder and do:
make && make install

Without these modules to offload crypto, there were race conditions that manifest in apps like Docker, or any app that uses streaming hash functions in Go, it would result in an "Unexpected EOF" error message. By offloading the crypto to silicon it unfucks the issue. 




