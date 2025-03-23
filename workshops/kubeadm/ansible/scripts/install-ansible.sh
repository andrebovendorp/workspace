#!/bin/bash

# Script to install Ansible on Ubuntu Linux

echo "Starting Ansible installation on Ubuntu..."

# Update the package list
sudo apt update

# Install Ansible
sudo apt install -y ansible

# Check if the installation was successful
if [ $? -eq 0 ]; then
  echo "Ansible installed successfully using APT."
  # Verify the installation
  echo "Verifying Ansible installation..."
  ansible --version
else
  echo "Error installing Ansible using APT. Please check the output above."
  exit 1
fi

echo "Ansible installation process finished on Ubuntu."