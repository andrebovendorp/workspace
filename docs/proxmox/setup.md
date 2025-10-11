# Proxmox Setup

Instructions for setting up and configuring Proxmox VE.

## Installation

1. **Hardware Preparation**
   - Server hardware configuration
   - Network setup
   - Storage configuration

2. **Proxmox VE Installation**
   - ISO installation process
   - Initial configuration
   - Network setup

3. **Post-Installation Configuration**
   - Update system
   - Configure repositories
   - Setup users and permissions

## VM and Container Setup

### Kubernetes Nodes
- Ubuntu VM templates
- Resource allocation
- Network configuration

### Service Containers
- LXC container templates
- Service-specific configurations
- Backup strategies

## Automation

Configuration management is handled through Ansible playbooks for:
- AdGuard setup
- NFS configuration  
- NTP server setup
- Mail server management