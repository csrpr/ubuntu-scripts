#!/bin/sh

# Define the block device name and path 
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

# Get the size of the disk in bytes
SIZE=`fdisk -l $DRIVE | grep Disk | awk '{print $5}'`

echo DISK SIZE - $SIZE bytes

# Calculate the number of cylinders
CYLINDERS=`echo $SIZE/255/63/512 | bc`

echo CYLINDERS - $CYLINDERS

# Create a new partition table and a single partition that spans the entire disk
# 'o' creates a new empty DOS partition table
# 'n' creates a new partition
# 'p' specifies a primary partition
# The start sector is left empty, defaulting to the beginning of the disk
# '$SIZE' specifies the end sector, using the entire available space
# 'w' writes the partition table to disk and exits
echo "o
n
p
1

$SIZE
w
" | fdisk $DRIVE &> /dev/null

sleep 1 # Wait for the partition table to be updated 

echo "[Done Partitioning.]"
# List the partition table to verify the changes 
fdisk $DRIVE -l

sleep 1
echo "[Making filesystem...]"

# Umount any remaining partitons and suppress error messages
umount "/dev/$BLOCK"p* &> /dev/null
sleep 1
umount " /media/$BLOCK"p* &> /dev/null
sleep 2

# Format the single partition with ext4 filesystem
# 'mkfs.ext4' creates an ext4 filesystem
# '-L rootfs' labels the filesystem as 'rootfs'
mkfs.ext4 -L rootfs /dev/${BLOCK}p1

echo "[Mounting Root Partition..]"
# Mount the new partition to /mnt
mount "$DRIVE"p1 /mnt

echo "[Extracting Filesystem..]"
# Create a mount point for the source partition 
mkdir -p /media/mmcblk0p1
# Mount the source partition to /media/mmcblk0p1
mount /dev/mmcblk0p1 /meaid/mmcblk0p1 &> /dev/null
# Copy all files from the source partition to the new partition
cp -rf /media/mmcblk0p1/* /mnt

echo "[Syncing..]"
# Ensure all file system changes are written to disk
sync

echo "[Unmounting Root Partition]"
# Unmount the new partition from /mnt
umount "$DRIVE"p1

# Set the environment variable to specify boot targets
fw_setenv boot_targets emmc

echo " "
echo "eMMC Setup completed."