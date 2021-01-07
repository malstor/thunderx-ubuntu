# thunderx-ubuntu
Installing Ubuntu on Cavium ThunderX ARM64 MT30-GS1/ MT30-GS0

Downgrade to the T49 BIOS version, F02 has some fixes for pantsdown, however it seems to cause some issues with the main ubuntu kernels available; the issue is the shared BMC memory so just disable it by cutting the trace if you are concerned. 

MT30-GS1
Use Ubuntu 18.04.3 and hold the kernel at 4.15.0-55-generic
Set the following boot flags at install: console=tty0 immou.passthrough=1 acpi=force 
After installing add: arm-smmu.disable_bypass=n

MT30-GS0
Use Ubuntu 18.04.1 to install and update to the latest version via apt update/upgrade update to the 4.15.0-129-generic kernel after the install. 
Set the following boot flags: console=tty0 immou.passthrough=1 arm-smmu.disable_bypass=n acpi=force

For both boards use manual partitions, create a 512MB BIOS boot area, 2GB EFI, and the remainder btrfs /

Delete the firmware module in the /lib/firmware/cavium folder cnx55 or whatever and install the firmware in this repo under the firmware folder. 

Download them to a folder and do:
make && make install

Without these modules to offload crypto, there were race conditions that manifested in Docker, when extracting images that were realted to the streaming hash functions in Go, it would result in an "Unexpected EOF" error message. By offloading the crypto to silicon it unfucks the issue. 



