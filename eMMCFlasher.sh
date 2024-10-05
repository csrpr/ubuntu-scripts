#!/bin/sh

# Define the block device name & path 
BLOCK=mmcblk1
DRIVE="/dev/$BLOCK"

# Function to check fdisk version
check_fdisk_version() {
    # Get the version of fdisk
    CUR_VERSION=$(sfdisk -v | awk {'print $NF'})
    
    echo "Current version of sfdisk : ${CUR_VERSION}"

    # Minimum required version
    REQUIRED_VERSION="2.26.3"
    
    # Compare versions
    if [ "$(printf '%s\n' "$REQUIRED_VERSION" "$CUR_VERSION" | sort -V | head -n1)" != "$REQUIRED_VERSION" ]; then
        echo "Error: fdisk version must be >= $REQUIRED_VERSION. Current version is $CUR_VERSION."
        exit 1
    fi
}

# Check fdisk version
check_fdisk_version

echo "[Umounting all existing partition on $DRIVE...]"

# Umount any partions on the device & supress error messages
umount "/dev/$BLOCK"p* &> /dev/null
umount "/media/$BLOCK"p* &> /dev/null

echo "[Creating Partition on $DRIVE...]"

sudo sfdisk ${DRIVE} <<-__EOF__   
1M,,L,*
__EOF__

sleep 2 
echo "[syncing....]"
sync
sync


echo "[Done Partitioning.]"
# List the partition table to verify the changes 
fdisk $DRIVE -l

sleep 2
sync


echo "[Making filesystem...]"
umount "/dev/$BLOCK"p* &> /dev/null
sleep 2
echo "[syncing....]"
sync
sync

# Format the single partition 
mkfs.ext4 -L rootfs /dev/${BLOCK}p1

sleep 2
sync
sync


echo "[Mounting Root Partition..]"
# Mount the new partition to /mnt
mount "$DRIVE"p1 /mnt

sleep 2
sync
sync

echo "[Extracting the file systems..]"
tar -xvf rootfs.tar -C /mnt

echo "[Syncing..]"
sync
sync

echo "[Umounting root partition]"
umount "$DRIVE"p1

echo "[Syncing..]"
sync
sync

echo " "
echo "eMMC Setup completed."
