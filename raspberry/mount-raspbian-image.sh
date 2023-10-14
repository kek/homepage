#!/bin/sh

if [ "$1" = "" ]; then
  echo "usage: $0 <image>"
  exit
fi
kpartx -a -s $1
sleep 5
mkdir -p /mnt/boot
mkdir -p /mnt/os
mount -o rw /dev/mapper/loop0p1 /mnt/boot
mount -o rw -t ext4 /dev/mapper/loop0p2 /mnt/os
