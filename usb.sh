#!/bin/bash

if [ $# -ne 1 ]; then
    echo -e "\nUsage: $0 <package_name>"
    echo -e "Example: $0 usbutils\n"
    exit 1
fi

cat << EOM
#########################################################################
usbutils: 
When operating on a Linux system, it's customary to utilize 
USB devices like external hard drives, flash drives, and other 
peripherals for tasks such as data transfer, software installation, 
or file backup. Nevertheless, prior to commencing usage of a USB device, 
it is imperative to confirm its seamless connection to our system
#########################################################################

EOM
  
package_name=$1

# Check if the package manager is apt & apt is used in the Debian-based distribution
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
####################################################################
lsusb: lsusb is a command-line utility that displays information 
about USB buses and connected devices on a Linux system."
####################################################################

EOM
# Display the USB info
lsusb

cat << EOM

#####################################################################
usb-devices: usb-devices is a Bash shell script that displays 
details about USB buses and connected devices on a Linux system. 
Its output is similar to the contents of the usb/devices file 
under /sys/kernel/debug, which we’ll analyze in the following 
sections, but it only lists active interfaces.
#####################################################################

EOM
# Display the active list of USB interfaces 
usb-devices

cat << EOM

######################################################################
Another way to see the connected USB devices is with the usbview 
tool. This tool provides a graphical overview of recognized devices 
in a tree display. It’s probably not pre-installed on our system by 
default, so we can use a package manager to initiate the installation:
######################################################################
EOM

echo -e "sudo apt install usbview -y\n"

echo -e "\nTo run commands like lsusb and usb-devices that require superuser privileges, this script may need to be run with sudo.\n"

echo -e "\nRunning usbview...\n"

# Display the USB information in graphical tool
sudo usbview

exit 0

