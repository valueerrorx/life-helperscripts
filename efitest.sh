#!/bin/bash
# this script is a workaround for a weird ubiquity bug where grub-install fails on legacy bios systems
# it must be run directly after ubiquity fails so /target is still mounted.. otherwise you may mount it manually

# sudo mount /dev/sda1 /mnt
# sudo mount --bind /dev /mnt/dev
# sudo mount --bind /dev/pts /mnt/dev/pts
# sudo mount --bind /sys /mnt/sys
# sudo mount --bind /proc /mnt/proc
# sudo mount --bind /run /mnt/run
#
# sudo chroot /mnt
# grub-install /dev/sda
# update-grub2


ISEFI=$(efibootmgr |grep UEFI  | wc -l)



if test $ISEFI = "1" 
then
    echo "EFI variables supported"
else
    echo "EFI variables not supported"
fi
