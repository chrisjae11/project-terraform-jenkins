#!/bin/bash

# volume setup
vgchange -ay
DEVICE=/dev/xvdf

DEVICE_FS=`blkid -o value -s TYPE ${DEVICE}`
if [ "`echo -n $DEVICE_FS`" = "" ] ; then
  # wait for the device to be attached
  DEVICENAME=`echo "${DEVICE}" | awk -F '/' '{print $3}'`
  DEVICEEXISTS=''
  while [[ -z $DEVICEEXISTS ]]; do
    echo "checking $DEVICENAME"
    DEVICEEXISTS=`lsblk |grep "$DEVICENAME" |wc -l`
    if [[ $DEVICEEXISTS != "1" ]]; then
      sleep 15
    fi
  done
  pvcreate ${DEVICE}
  vgcreate data ${DEVICE}
  lvcreate --name volume1 -l 100%FREE data
  mkfs.ext4 /dev/data/volume1
fi
mkdir -p /var/lib/jenkins
echo '/dev/data/volume1 /var/lib/jenkins ext4 defaults 0 0' >> /etc/fstab
mount /var/lib/jenkins
apt -y update
apt -y install software-properties-common
apt-add-repository ppa:ansible/ansible
apt -y update
apt -y install ansible
