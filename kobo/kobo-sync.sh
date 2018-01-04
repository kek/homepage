#!/bin/sh

mount /mnt/kobo
touch /sync.txt
mv /home/ke/Kobo/* /mnt/kobo
umount /mnt/kobo
