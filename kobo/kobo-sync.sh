#!/bin/sh

mount /mnt/kobo
touch /syncing.txt
mv /home/ke/Kobo/* /mnt/kobo
umount /mnt/kobo
rm /syncing.txt
