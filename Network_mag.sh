#!/bin/bash
# Author:
#       
#      Calixto System Pvt Ltd - 2024-25
#      Network_manager.sh V0.1
#
# This distribution contains contributions or derivatives under copyright
# as follows:
#
# Copyright (c) 2024, Calixto Systems Pvt Ltd.
# All rights reserved.
#===================================================================================

# Check if NetworkManager is running
echo " Checking if NetworkManager is running..."
if systemctl is-active --quiet NetworkManager; then
    echo "NetworkManager is running."
else
    echo " NetworkManager is not running. Attempting to start it..."
    sudo systemctl start NetworkManager
    if systemctl is-active --quiet NetworkManager; then
        echo " NetworkManager started successfully."
    else
        echo " Failed to start NetworkManager. Exiting."
        exit 1
    fi
fi

# Display the status of all network devices
echo -e "\n Network Device Status:"
nmcli device status

# List all saved network connections
echo -e "\n Available Network Connections:"
nmcli connection show

# Show active network connections with details
echo -e "\n Active Network Connections:"
nmcli connection show --active

#===================================================================================
# Show detailed information for each active device
# Ref Output : 
# wlo1
# p2p-dev-wlo1
#===================================================================================
echo -e "\n Detailed Information for Active Devices:"
for DEVICE in $(nmcli -t -f DEVICE,STATE device | grep "connected" | cut -d':' -f1); do
    echo -e "\nDevice: $DEVICE"
    nmcli -p device show "$DEVICE"
done

sleep 1
echo -e "\n Network Manager check completed."



