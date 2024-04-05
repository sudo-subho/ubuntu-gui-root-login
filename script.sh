#!/bin/bash

sudo passwd

# Check if AllowRoot=true is already present in custom.conf
if ! grep -q 'AllowRoot=true' /etc/gdm3/custom.conf; then
    # Make a backup of the original custom.conf file
    sudo cp /etc/gdm3/custom.conf /etc/gdm3/custom.conf~

    # Add AllowRoot=true after [daemon] in custom.conf
    sudo sed -i '/^\[daemon\]/a AllowRoot=true' /etc/gdm3/custom.conf

    echo "AllowRoot=true added to custom.conf."
else
    echo "AllowRoot=true already present in custom.conf. Skipping."
fi

# Check if the specified line is already commented out in gdm-password
if ! grep -q '^#.*auth[[:space:]]\+required[[:space:]]\+pam_succeed_if.so[[:space:]]\+user[[:space:]]!= root[[:space:]]\+quiet_success' /etc/pam.d/gdm-password; then
    # Comment out the line in gdm-password
    sudo sed -i 's/^auth[[:space:]]\+required[[:space:]]\+pam_succeed_if.so[[:space:]]\+user[[:space:]]!= root[[:space:]]\+quiet_success/# &/' /etc/pam.d/gdm-password

    echo "Line commented out in gdm-password."
else
    echo "Line already commented out in gdm-password. Skipping."
fi

echo "Configuration check complete."
echo "Rebooting. After Rebooting login as root"

sudo reboot
