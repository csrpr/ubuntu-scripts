#!/bin/bash
if [ $# -ne 1 ]; then
    echo -e "\nUsage: $0 <package_name>"
    echo -e "Example: $0 uuu\n"
    exit 1
fi

package_name=$1

# Check if the package manager is apt & apt is used in the Debian, Ubuntu -based distribution
if command -v apt &>/dev/null; then
    # Package manager is apt
    if dpkg -s "$package_name" &>/dev/null; then
        echo -e "\n$package_name package is already installed"
        # Retrieve version information
        version=$(dpkg -s "$package_name" | grep Version | cut -d ' ' -f 2)
        echo -e "Version: $version\n"
    else
        echo "$package_name is not installed"
        echo "Installing the $package_name package..."
        sudo apt install "$package_name" -y
        echo "----->>Installed $package_name package successfully<<------"
    fi
fi

cat << EOM
########################## QSPI FLASHING ###########################
uuu [-d -m -v] -b[run] <emmc|emmc_all|qspi|sd|sd_all|spl> arg...

	emmc -	   burn boot loader to eMMC boot partition
		   arg0: _flash.bin
	emmc_all - burn whole image to eMMC
		   arg0: _flash.bin
		   arg1: _rootfs.sdcard
	qspi - 	   burn boot loader to qspi nor flash
		   arg0: _flexspi.bin bootloader
		   arg1: _image[Optional] image burn to flexspi, 
		   	 default is the same as bootloader
	sd - 	   burn boot loader to sd card
		   arg0: _flash.bin
	sd_all -   burn whole image to sd card
		   arg0: _flash.bin
		   arg1: _rootfs.sdcard
	spl -      boot spl and uboot
		   arg0: _flash.bin
####################################################################
EOM
 







