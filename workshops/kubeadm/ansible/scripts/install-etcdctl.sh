#!/bin/bash

# Script to install etcdctl on Ubuntu Server

echo "Starting etcdctl installation on Ubuntu Server..."

# --- Configuration ---
# Replace with the desired etcd version if needed.
# Check the latest stable version at https://github.com/etcd-io/etcd/releases
ETCD_VERSION="v3.5.13"
ARCH=$(uname -m)
OS="linux"
INSTALL_DIR="/usr/local/bin"
TMP_DIR="/tmp"
ETCD_FILENAME="etcd-${ETCD_VERSION}-${OS}-${ARCH}.tar.gz"
DOWNLOAD_URL="https://github.com/etcd-io/etcd/releases/download/${ETCD_VERSION}/${ETCD_FILENAME}"
ETCDCTL_BINARY="etcdctl"

# --- Installation Steps ---

# Create temporary directory if it doesn't exist
mkdir -p "${TMP_DIR}"

# Download etcd release
echo "Downloading etcd release: ${DOWNLOAD_URL}"
wget -P "${TMP_DIR}" "${DOWNLOAD_URL}"

if [ $? -ne 0 ]; then
  echo "Error downloading etcd release. Please check the URL and your network connection."
  exit 1
fi

# Extract etcdctl binary
echo "Extracting ${ETCDCTL_BINARY} from the downloaded archive..."
tar -xzvf "${TMP_DIR}/${ETCD_FILENAME}" -C "${TMP_DIR}" --strip-components=1 "${ETCDCTL_BINARY}"

if [ $? -ne 0 ]; then
  echo "Error extracting ${ETCDCTL_BINARY} from the archive."
  exit 1
fi

# Create installation directory if it doesn't exist
sudo mkdir -p "${INSTALL_DIR}"

# Move etcdctl to the installation directory
echo "Moving ${ETCDCTL_BINARY} to ${INSTALL_DIR}..."
sudo mv "${TMP_DIR}/${ETCDCTL_BINARY}" "${INSTALL_DIR}"

if [ $? -ne 0 ]; then
  echo "Error moving ${ETCDCTL_BINARY} to ${INSTALL_DIR}. You might need to run this script with sudo."
  exit 1
fi

# Make etcdctl executable
echo "Making ${ETCDCTL_BINARY} executable..."
sudo chmod +x "${INSTALL_DIR}/${ETCDCTL_BINARY}"

if [ $? -ne 0 ]; then
  echo "Error making ${ETCDCTL_BINARY} executable."
  exit 1
fi

# Clean up temporary files
echo "Cleaning up temporary files..."
rm -f "${TMP_DIR}/${ETCD_FILENAME}"

# Verify installation
echo "Verifying etcdctl installation..."
etcdctl version

echo "etcdctl installation finished successfully."