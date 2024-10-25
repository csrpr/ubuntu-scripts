#!/bin/bash
# Author:
#       
#      Calixto System Pvt Ltd - 2024-25
#      create-sdcard-boot.sh v0.1
#
# This distribution contains contributions or derivatives under copyright
# as follows:
#
# Copyright (c) 2024, Calixto Systems Pvt Ltd.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# - Redistributions of source code must retain the above copyright notice,
#   this list of conditions and the following disclaimer.
# - Redistributions in binary form must reproduce the above copyright
#   notice, this list of conditions and the following disclaimer in the
#   documentation and/or other materials provided with the distribution.
# - Neither the name of Calixto Systems nor the names of its
#   contributors may be used to endorse or promote products derived
#   from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
# TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
# PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
# OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# Force locale language to be set to English. This avoids issues when doing
# text and string processing.
export LANG=C

# Determine the absolute path to the executable
# EXE will have the PWD removed so we can concatenate with the PWD safely

PWD=`pwd`
EXE=`echo $0 | sed s=$PWD==`
EXEPATH="$PWD"/"$EXE"
clear

cat << EOM
################################################################################

This script will create a bootable SD card from Calixto System Pvt Ltd boards 
IMX6ULL-VERSA-SOM_EVB & IMX6ULL-TINY-SOM_EVB.

The script must be run with root permissions 

Syntax :
 $ sudo <script file name>
 
Example:
 $ sudo create-sdcard-boot.sh

################################################################################
EOM

AMIROOT=`whoami | awk {'print $1'}`
if [ "$AMIROOT" != "root" ] ; then

	echo "	**** Error *** must run script with sudo"
	echo ""
	exit
fi

check_for_sdcards()
{
	# find the avaible SD cards
	ROOTDRIVE=`mount | grep 'on / ' | awk {'print $1'} |  cut -c6-8`
	PARTITION_TEST=`cat /proc/partitions | grep -v $ROOTDRIVE | grep '\<sd.\>\|\<mmcblk.\>' | grep -n ''`
	if [ "$PARTITION" = "" ]; then
		echo -e "Please insert a SD Card continue\n"
		sleep 1
		while [ "$PARTITION_TEST" = "" ]; do
			read -p "Type 'y' to re-detect the SD card or 'n' to exit the script: " REPLY
			if [ "$REPLY" = 'n' ]; then
				exit 1
	                fi
	                ROOTDRIVE=`mount | grep 'on / ' | awk {'print $1'} | cut -c6-8`
	                PARTITION_TEST=`cat /proc/partitions | grep -v $ROOTDRIVE | grep '\<sd.\>\|\<mmcblk.\>' | grep -n ''`
	         done
	fi
}

# find the avaible SD cards
ROOTDRIVE=`mount | grep 'on /media/' | awk {'print $1'} | cut -c6-9`
echo -e "\nline 94 ROOTDRIVE is: $ROOTDRIVE\n"
if [ "$ROOTDRIVE" = "root" ]; then
	ROOTDRIVE=`readlink /dev/root | cut -c1-3`
else
	ROOTDRIVE=`echo $ROOTDRIVE | cut -c1-3`
fi

PARTITION_TEST=`cat /proc/partitions | grep -v $ROOTDRIVE | grep '\<sd.\>|\<mmcblk.\>' | grep -n ''`

# Check for available mounts
check_for_sdcards

echo "#############################################"
echo -e "\nAvailible Drives to write images to: \n"
echo "#  major   minor    size   name "
cat /proc/partitions | grep -v $ROOTDRIVE | grep '\<sd.\>\|\<mmcblk.\>' | grep -n ''
echo "#############################################"

DEVIDEDRIVENUMBER=
while true;
do
	read -p 'Enter Device Number or 'n' to exit: ' DEVICEDRIVENUMBER
	echo " "
	if [ "$DEVICEDRIVENUMBER" = 'n' ]; then
		exit 1
	fi
	
	if [ "$DEVICEDRIVENUMBER" = "" ]; then
		# check to see if there are any changes
		check_for_sdcards
		echo -e "These are the Drives available to write images to:"
		echo "#  major   minor    size   name "
		cat /proc/partitions | grep -v $ROOTDRIVE | grep '\<sd.\>\|\<mmcblk.\>' | grep -n ''
		echo " " grep 
	       continue
	 fi
	 DEVICEDRIVENAME=`cat /proc/partitions | grep -v $ROOTDRIVE | grep '\<sd.\>\|\<mmcblk.\>' | grep -n '' | grep "${DEVICEDRIVENUMBER}:" | awk '{print $5}'`
	 if [ -n "$DEVICEDRIVENAME" ]
	 then
	 	DRIVE=/dev/$DEVICEDRIVENAME
	 	DEVICESIZE=`cat /proc/partitions | grep -v $ROOTDRIVE | grep '\<sd.\>\|\<mmcblk.\>' | grep -n '' | grep "${DEVICEDRIVENUMBER}:" | awk '{print $4}'`
	 	break
	 else3
	 	echo -e "Invalid selection!"
	 	# Check to see if there are any changes 
	 	check_for_sdcards
	 	echo -e "These are the only Drives available to write images to: \n"
	 	echo "#  major   minor    size   name "
	 	cat /proc/partitions | grep -v $ROOTDRIVE | grep '\<sd.\>\|\<mmcblk.\>' | grep -n ''
	 	echo " "
	 fi
done

echo "$DEVICEDRIVENAME was selected"
# Check the size of disk to make sure its under 16GB
echo -e "\nline 149 DEVICESIZE : $DEVICESIZE\n"
if [ $DEVICESIZE -gt 17000000 ] ; then
                       
cat << EOM
################################################################################

		**********WARNING**********

	Selected Device is greater then 16GB Continuing 
	past this point will erase data from device
	Double check that this is the correct SD Card

################################################################################
EOM
	ENTERCORRECTLY=0
	while [ $ENTERCORRECTLY -ne 1 ]
	do 
		read -p 'Would you like to continue [y/n] : ' SIZECHECK
		echo ""
		echo " "
		ENTERCORRECTLY=1
		case $SIZECHECK in 
		"y") ;;
		"n") exit;;
		*) echo "Please enter y or n";ENTERCORRECTLY=0;;
		esac
		echo ""
	done
fi
echo ""

DRIVE=/dev/$DEVICEDRIVENAME
# echo "drive name : $DRIVE"
NUM_OF_DRIVES=`df | grep -c $DEVICEDRIVENAME`
# This if statement will determine if we have a mounted sdX or mmcblkX device.
# If it is mmcblkX, then we need to set an extra char in the partition names, 'p',
# to account for /dev/mmcblkXpY labled partitions.
if [[ $DEVICEDRIVENAME} =~ ^sd. ]]; then
	echo "$DRIVE is an sdx device"
	P=''
else
	echo "$DRIVE is an mmcblk device"
	P='p'
fi

if [ "$NUM_OF_DRIVES" != "0" ]; then
	echo "Unmounting the $DEVICEDRIVENAME drives"
	for ((c=1; c<="$NUM_OF_DRIVES"; c++))
	do
		unmounted=`df | grep '\<'$DEVICEDRIVENAME$P$c'\>' | awk '{print $1}'`
		if [ -n "$unmounted" ]
		then
			echo " unmounted ${DRIVE}$P$c"
			sudo umount -f ${DRIVE}$P$c
		fi
	done
fi
echo ""
cat << EOM
################################################################################

		Erase partition table/labels on microSD card

################################################################################
EOM
dd if=/dev/zero of=${DRIVE} bs=1M count=10
echo ""

cat << EOM
################################################################################

			Copying the bootloader image

################################################################################
EOM
echo -e "\ncopying the bootloader image : u-boot-dtb.imx into the SD Card\n"
dd if=./u-boot-dtb.imx of=${DRIVE} seek=2 bs=512
echo -e "\nu-boot-dtb.imx copied\n"

cat <<EOM
################################################################################

			Now making 1 partitions

################################################################################
EOM
#-------------------------------------------------------------------------------
# Check the version of sfdisk installed on your pc is atleast 2.26.x or newer.
# & As per the ubuntu v20.04 the sfdisk version is 2.37.2
#-------------------------------------------------------------------------------
#!/bin/bash

currentver_str="$(sfdisk -v)"
currentver=$(sfdisk -v | awk {'print $NF'})
echo "Current version of sfdisk : ${currentver}"
requiredver="2.26.3"

if [ "$(printf '%s\n' "$requiredver" "$currentver" | sort -V | head -n1)" = "$requiredver" ]; 
then 
echo "Greater than or equal to ${requiredver}"
sfdisk ${DRIVE} << EOF
1M,,L,*
EOF
else
echo "Less than ${requiredver}"
fi

cat << EOM
################################################################################

			Partitioning rootfs system

################################################################################
EOM

if [[ ${DEVICEDRIVENAME} =~ ^sd. ]]; then
	echo "$DRIVE is an sdx device"
	P=''
	mkfs.ext4 -L "rootfs" ${DRIVE}1
	sync
	sync
	INSTALLSTARTHERE=n
else
	echo "$DRIVE is an mmcblkx device"
	P='p'
	mkfs.ext4 -L "rootfs" ${DISK}${P}1
	sync
	sync
	INSTALLSTARTHERE=n
fi

# Add directories for images 
export PATH_TO_SDROOTFS=rootfs

echo -e "\n\tMount the partitions\n"
mkdir $PATH_TO_SDROOTFS

sudo mount -t ext4 ${DRIVE}${P}1 rootfs/

echo -e "\n\tEmptying partitions\n"
sudo rm -rf $PATH_TO_SDROOTFS/*

echo -e "\n\tSyncing....\n"
sync
sync
sync

cat << EOM
################################################################################

		Copying files now... will take minutes

################################################################################
EOM

echo -e "\n\tCopying rootfs system partition\n"
sudo tar -xf rootfs.tar -C $PATH_TO_SDROOTFS

echo -e "\n\tSyncing...\n"
sync
sync
sync

# un-mount sd card
echo -e "\n\tUn-mount the partitions\n"
sudo umount -f $PATH_TO_SDROOTFS

echo -e "\n\tRemove created temp directories\n"
sudo rm -rf $PATH_TO_TMP_DIR
sudo rm -rf $PATH_TO_SDROOTFS

echo -e "\n\tOperation finished\n"
