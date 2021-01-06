# thunderx-ubuntu
Installing Ubuntu on Cavium ThunderX ARM64 MT30-GS1/ MT30-GS0

MT30-GS1
Use Ubuntu 18.04.3
Set the following boot flags: console=tty0 immou.passthrough=1 acpi=force 

MT30-GS0
Use Ubuntu 18.04.1
Set the following boot flags: console=tty0 immou.passthrough=1 arm-smmu.disable_bypass=n acpi=force

Use manual partitions, create a 512MB BIOS boot area, 2GB EFI, and the remainder btrfs /





