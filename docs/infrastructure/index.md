# Infrastructure Overview

This section covers the underlying infrastructure layer that supports the Kubernetes cluster, including virtualization, networking, and storage systems.

## Infrastructure Stack

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                           Physical Layer                                        │
│  ┌─────────────────────────────────────────────────────────────────────────────┐ │
│  │                      Server Hardware                                        │ │
│  │  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌─────────────────────────┐│ │
│  │  │    CPU      │ │   Memory    │ │   Storage   │ │       Network           ││ │
│  │  │ (x86_64)    │ │   (DDR4)    │ │ (NVMe/SATA) │ │    (Gigabit)            ││ │
│  │  └─────────────┘ └─────────────┘ └─────────────┘ └─────────────────────────┘│ │
│  └─────────────────────────────────────────────────────────────────────────────┘ │
└─────────────────────────────┬───────────────────────────────────────────────────┘
                              │
┌─────────────────────────────▼───────────────────────────────────────────────────┐
│                       Virtualization Layer                                      │
│  ┌─────────────────────────────────────────────────────────────────────────────┐ │
│  │                        Proxmox VE                                           │ │
│  │  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌─────────────────────────┐│ │
│  │  │Hypervisor   │ │   Storage   │ │ Networking  │ │      Management         ││ │
│  │  │  (KVM)      │ │    (ZFS)    │ │  (Bridges)  │ │      (Web UI)           ││ │
│  │  └─────────────┘ └─────────────┘ └─────────────┘ └─────────────────────────┘│ │
│  └─────────────────────────────────────────────────────────────────────────────┘ │
└─────────────────────────────┬───────────────────────────────────────────────────┘
                              │
┌─────────────────────────────▼───────────────────────────────────────────────────┐
│                         Virtual Machines                                        │
│  ┌─────────────┐              ┌─────────────┐              ┌─────────────┐      │
│  │K3s Master   │              │K3s Worker-1 │              │K3s Worker-2 │      │
│  │Ubuntu 22.04 │              │Ubuntu 22.04 │              │Ubuntu 22.04 │      │
│  │4 vCPU/8GB   │              │4 vCPU/8GB   │              │4 vCPU/8GB   │      │
│  └─────────────┘              └─────────────┘              └─────────────┘      │
└─────────────────────────────────────────────────────────────────────────────────┘
```

## Core Infrastructure Components

### Proxmox VE Platform
- **Type-1 Hypervisor**: Direct hardware access for optimal performance
- **ZFS Storage**: Copy-on-write filesystem with snapshots and compression
- **Virtual Networking**: Software-defined networking with VLANs
- **High Availability**: Cluster-ready architecture (single node currently)

### Network Architecture
- **Virtual Bridges**: Layer 2 switching for VM connectivity
- **VLAN Support**: Network segmentation capabilities
- **Firewall Integration**: Built-in packet filtering

### Storage Systems
- **Local Storage**: High-performance NVMe/SATA SSDs
- **Network Storage**: NFS server for shared data
- **Backup Storage**: Dedicated backup targets
- **Snapshot Management**: Automated ZFS snapshots

## Key Features

### Resource Efficiency
- **Thin Provisioning**: Dynamic storage allocation
- **Memory Ballooning**: Efficient memory utilization
- **CPU Hotplug**: Dynamic resource scaling
- **Power Management**: ACPI-compliant power states

### Security & Isolation
- **VM Isolation**: Hardware-assisted virtualization
- **Network Segmentation**: VLAN-based separation
- **Access Control**: Role-based user management
- **Secure Boot**: UEFI secure boot support

### Operations & Management
- **Web Interface**: Intuitive management console
- **API Access**: RESTful API for automation
- **Monitoring**: Built-in performance metrics
- **Backup Solutions**: Automated VM backups

For detailed configuration and setup information, see:
- [Proxmox Setup](proxmox.md) - Installation and configuration
- [Virtual Networks](networking.md) - Network architecture details
- [Storage Systems](storage.md) - Storage configuration and management