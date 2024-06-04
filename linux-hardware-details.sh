#!/bin/bash

echo -e "\n===========================[ System Information ]=======================================================\n"
echo "Home: $HOME"
echo "Hostname: $(hostname)"
echo "Kernel Version: $(uname -r)"
echo "Distribution: $(lsb_release -ds)"
echo "Compiler Version: ${gcc --version}"
echo "System Config Information:" 
echo "---------------------------------------------------"
echo "$(hostnamectl)"
echo -e "------------------------------------------------\n"



echo -e "\n===========================[ CPU Information ]==========================================================\n"
lscpu | grep "Model name"

echo -e "\n===========================[ Memory Information ]=======================================================\n"
free -h

echo -e "\n===========================[ Disk Information ]=========================================================\n"
df -h

if [ -e /sys/class/power_supply/BAT1 ]; then
    echo -e "\n=======================[ Battery Information ]======================================================\n"
    cat /sys/class/power_supply/BAT1/uevent | grep "POWER_SUPPLY_"
fi

echo -e "\n===========================[ GPU Information ]==========================================================\n"
lspci | grep -i vga

echo -e "\n===========================[ Wireless Interface Information ]===========================================\n"
iwconfig

echo -e "\n===========================[ Network Interface Information ]============================================\n"
ifconfig

echo -e "\n===========================[ Memory details ]===========================================================\n"

echo -e "\n===========================[ Total number of slots available for RAM ]==================================\n"
sudo dmidecode -t memory | grep -c '^Memory Device$'

echo -e "\n===========================[ Number of slots used ]=====================================================\n"
sudo dmidecode -t memory | grep -c -P '^\tPart Number:\s+(?!Unknown)'

echo -e "\n===========================[ Maximum capacity ]=========================================================\n"
sudo dmidecode -t memory | grep -P '^\tMaximum Capacity:\s+\K.*'

echo -e "\n===========================[ All Memory Device Details ]================================================\n"
sudo dmidecode -t 17 # Memory Device.

#------------------------------------------------------------------------------------------------------------------------------------------
#
#       dmidecode is a tool for dumping a computer's DMI (some say SMBIOS) table contents in a human-readable format. This table contains a
#       description of the system's hardware components, as well as other useful pieces of information such as serial numbers and BIOS  re‐
#       vision.  Thanks  to this table, you can retrieve this information without having to probe for the actual hardware.  While this is a
#       good point in terms of report speed and safeness, this also makes the presented information possibly unreliable.
#
#       The DMI table doesn't only describe what the system is currently made of, it also can report the possible evolutions (such  as  the
#       fastest supported CPU or the maximal amount of memory supported).
#
#       SMBIOS stands for System Management BIOS, while DMI stands for Desktop Management Interface. Both standards are tightly related and
#       developed by the DMTF (Desktop Management Task Force).
#
#       As you run it, dmidecode will try to locate the DMI table. It will first try to read the DMI table from sysfs, and next try reading
#       directly  from  memory  if sysfs access failed.  If dmidecode succeeds in locating a valid DMI table, it will then parse this table
#       and display a list of records like this one:
#
#       Handle 0x0002, DMI type 2, 8 bytes.  Base Board Information
#               Manufacturer: Intel
#               Product Name: C440GX+
#               Version: 727281-001
#               Serial Number: INCY92700942
#------------------------------------------------------------------------------------------------------------------------------------------

echo -e "\n==========================================[ BIOS ]============================================================\n"
sudo dmidecode -t 0   # BIOS
echo -e "\n==========================================[ System ]==========================================================\n"
sudo dmidecode -t 1   # System
echo -e "\n==========================================[ Base Board ]======================================================\n"
sudo dmidecode -t 2   # Base Board
echo -e "\n==========================================[ Chassis ]=========================================================\n"
sudo dmidecode -t 3   # Chassis
echo -e "\n==========================================[ Processor ]=======================================================\n"
sudo dmidecode -t 4   # Processor
echo -e "\n==========================================[ Memory Controller ]===============================================\n"
sudo dmidecode -t 5   # Memory Controller
echo -e "\n==========================================[ Memory Module ]===================================================\n"          
sudo dmidecode -t 6   # Memory Module
echo -e "\n==========================================[ Cache ] ==========================================================\n"          
sudo dmidecode -t 7   # Cache
echo -e "\n==========================================[ Port Connector ]==================================================\n"          
sudo dmidecode -t 8   # Port Connector
echo -e "\n==========================================[ System Slots ]====================================================\n"          
sudo dmidecode -t 9   # System Slots
echo -e "\n==========================================[ On Board Devices ]================================================\n"          
sudo dmidecode -t 10   # On Board Devices
echo -e "\n==========================================[ OEM Strings ]=====================================================\n"         
sudo dmidecode -t 11   # OEM Strings
echo -e "\n==========================================[ System Configuration Options ]====================================\n"         
sudo dmidecode -t 12   # System Configuration Options
echo -e "\n==========================================[ BIOS Language ]===================================================\n"         
sudo dmidecode -t 13   # BIOS Language
echo -e "\n==========================================[ Group Associations ]==============================================\n"         
sudo dmidecode -t 14   # Group Associations
echo -e "\n==========================================[ System Event Log ]================================================\n"       
sudo dmidecode -t 15   # System Event Log
echo -e "\n==========================================[ Physical Memory Array ]===========================================\n"        
sudo dmidecode -t 16   # Physical Memory Array
echo -e "\n==========================================[ Memory Device ]===================================================\n"         
sudo dmidecode -t 17   # Memory Device
echo -e "\n==========================================[ 32-bit Memory Error ]=============================================\n"         
sudo dmidecode -t 18   # 32-bit Memory Error
echo -e "\n==========================================[ Memory Array Mapped Address ]=====================================\n"         
sudo dmidecode -t 19   # Memory Array Mapped Address
echo -e "\n==========================================[ Memory Device Mapped Address ]====================================\n"         
sudo dmidecode -t 20   # Memory Device Mapped Address
echo -e "\n==========================================[ Built-in Pointing Device ]========================================\n"         
sudo dmidecode -t 21   # Built-in Pointing Device
echo -e "\n==========================================[ Portable Battery ]================================================\n"         
sudo dmidecode -t 22   # Portable Battery
echo -e "\n==========================================[ System Reset ]====================================================\n"   
sudo dmidecode -t 23   # System Reset
echo -e "\n==========================================[ Hardware Security ]===============================================\n"         
sudo dmidecode -t 24   # Hardware Security
echo -e "\n==========================================[ System Power Controls ]===========================================\n"         
sudo dmidecode -t 25   # System Power Controls
echo -e "\n==========================================[ Voltage Probe ]===================================================\n"   
sudo dmidecode -t 26   # Voltage Probe
echo -e "\n==========================================[ Cooling Device ]==================================================\n" 
sudo dmidecode -t 27   # Cooling Device
echo -e "\n==========================================[ Temperature Probe ]===============================================\n"         
sudo dmidecode -t 28   # Temperature Probe
echo -e "\n==========================================[ Electrical Current Probe ]========================================\n"         
sudo dmidecode -t 29   # Electrical Current Probe
echo -e "\n==========================================[ Out-of-band Remote Access ]=======================================\n"         
sudo dmidecode -t 30   # Out-of-band Remote Access
echo -e "\n==========================================[ Boot Integrity Services ]=========================================\n"        
sudo dmidecode -t 31   # Boot Integrity Services
echo -e "\n==========================================[ System Boot ]=====================================================\n"
sudo dmidecode -t 32   # System Boot
echo -e "\n==========================================[ 64-bit Memory Error ]=============================================\n"         
sudo dmidecode -t 33   # 64-bit Memory Error
echo -e "\n==========================================[ Management Device ]===============================================\n"        
sudo dmidecode -t 34   # Management Device
echo -e "\n==========================================[ Management Device Component ]=====================================\n"         
sudo dmidecode -t 35   # Management Device Component
echo -e "\n==========================================[ Management Device Threshold Data ]================================\n"        
sudo dmidecode -t 36   # Management Device Threshold Data
echo -e "\n==========================================[ Memory Channel ]==================================================\n"         
sudo dmidecode -t 37   # Memory Channel
echo -e "\n==========================================[ IPMI Device ]=====================================================\n"        
sudo dmidecode -t 38   # IPMI Device
echo -e "\n==========================================[ Power Supply ]====================================================\n"         
sudo dmidecode -t 39   # Power Supply
echo -e "\n==========================================>> END <<===========================================================\n"         

# echo -e "\n===== Installed Software Packages ====="
# dpkg -l | grep ii

