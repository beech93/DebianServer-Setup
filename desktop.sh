#!/bin/sh
# Placeholder

echo "-------------------------------------------------"
echo "Setting Up Desktop - Installing Sudo"
echo "-------------------------------------------------"

#  Install sudo
apt update
apt install sudo -yy

#  Find the standard user you created during installation and make it a variable
user=$(getent passwd 1000 |  awk -F: '{ print $1}')

#  Echo the user into the sudoers file
echo "$user  ALL=(ALL:ALL)  ALL" >> /etc/sudoers

# Install Apps
sudo apt install git curl -yy

echo "-------------------------------------------------"
echo "Setup complete."
echo "-------------------------------------------------"
