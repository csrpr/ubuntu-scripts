#!/bin/bash

#*******************************************************************************************************************************************
#package=$1

#if apt-mark showmanual | grep -q "^$package"; then
#	echo " The packages exists!"
#	echo " Installed package is: $package"
#else
#	echo " The package isn't installed"
#fi

#***************************************************************************************************************************************************

# Check if package name is provided as command-line argument
if [ $# -ne 1 ]; then
    echo "Usage: $0 <package_name>"
    exit 1
fi

package_name=$1

# Check if the package manager is apt or yum
if command -v apt &>/dev/null; then
    # Package manager is apt
    if dpkg -s $package_name &>/dev/null; then
        echo "$package_name is installed"
        # Retrieve version information
        version=$(dpkg -s $package_name | grep Version | cut -d ' ' -f 2)
        echo "Version: $version"
    else
        echo "$package_name is not installed"
    fi
elif command -v yum &>/dev/null; then
    # Package manager is yum
    if yum list installed $package_name &>/dev/null; then
        echo "$package_name is installed"
        # Retrieve version information
        version=$(yum list installed $package_name | awk '{print $2}')
        echo "Version: $version"
    else
        echo "$package_name is not installed"
    fi
else
    echo "Error: Unsupported package manager"
    exit 1
fi


