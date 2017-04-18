#!/bin/sh

kpartx -a -s raspbian.img
sleep 5
mkdir -p /mnt/boot
mkdir -p /mnt/os
mount -o rw /dev/mapper/loop0p1 /mnt/boot
mount -o rw -t ext4 /dev/mapper/loop0p2 /mnt/os

touch /mnt/boot/ssh
cp wpa_supplicant.conf /mnt/os/etc/wpa_supplicant
sync
sync
sync
umount /mnt/os
umount /mnt/boot
