# Kubernetes Setup

Instructions for setting up and configuring the Kubernetes cluster.

## Prerequisites

- Proxmox virtualization platform
- Ubuntu VMs for cluster nodes
- Network configuration

## Installation Steps

1. **Prepare the nodes**
   - Install Ubuntu on VMs
   - Configure networking
   - Install container runtime

2. **Initialize the cluster**
   - Setup master node
   - Join worker nodes
   - Configure kubectl

3. **Install core components**
   - CNI plugin
   - Storage drivers
   - Monitoring stack

## Configuration Files

The cluster configuration is managed through Ansible playbooks and Kubernetes manifests located in the `/kubernetes` directory.