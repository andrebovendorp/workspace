# Proxmox Documentation

Documentation for the Proxmox virtualization platform configuration and management.

## Overview

Proxmox VE is used as the underlying virtualization platform for the homelab infrastructure.

## Components

- **Virtual Machines** - Ubuntu VMs for Kubernetes nodes
- **Containers** - LXC containers for lightweight services
- **Storage** - Local and network storage configuration
- **Networking** - Virtual networking and VLANs

## Services

### Core Services
- **AdGuard** - DNS filtering and ad blocking
- **NFS** - Network file system for shared storage
- **NTP** - Network time protocol server
- **Mail** - Mail server upgrade automation

## Management

The Proxmox infrastructure is managed through Ansible playbooks located in the `/proxmox` directory.