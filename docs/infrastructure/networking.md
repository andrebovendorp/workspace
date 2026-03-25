# Infrastructure Networking

This document details the network architecture and design patterns implemented in the homelab infrastructure layer.

## Network Architecture Overview

The infrastructure implements a multi-tier network design with physical and virtual network separation to support both the hypervisor layer and Kubernetes workloads.

### Physical Network Layer
```yaml
Physical Infrastructure:
  Switch: Managed Layer 2/3 switch with VLAN support
  Uplink: Gigabit Internet connection
  Redundancy: Link aggregation for critical paths
  Cabling: Cat6 structured cabling

Router Configuration:
  Gateway: pfSense/OPNsense router
  WAN: Internet service provider connection
  LAN Segments: Multiple VLANs for segmentation
  Firewall: Stateful packet filtering
```

## VLAN Segmentation

### Network Segments
```yaml
VLAN Design:
  VLAN 10: Management Network (192.168.10.0/24)
    - Proxmox management interface
    - Network equipment management
    - Administrative access

  VLAN 20: Infrastructure Services (192.168.20.0/24)
    - DNS servers (AdGuard)
    - NTP servers
    - Monitoring systems

  VLAN 30: Kubernetes Cluster (192.168.30.0/24)
    - K3s control plane nodes
    - Worker nodes
    - Inter-node communication

  VLAN 40: Storage Network (192.168.40.0/24)
    - NFS storage servers
    - iSCSI targets
    - Backup systems

  VLAN 50: Load Balancer Pool (192.168.50.0/24)
    - Cilium LB IPAM addresses
    - External service endpoints
    - Ingress controller IPs
```

### VLAN Routing and ACLs
```yaml
Inter-VLAN Routing:
  Management → All: Administrative access
  Kubernetes → Storage: Data persistence
  Kubernetes → Infrastructure: DNS, NTP services
  Load Balancer → Internet: External access

Access Control Lists:
  Default: Deny all inter-VLAN traffic
  Explicit Allow: Required service communication
  Logging: Traffic analysis and security monitoring
```

## Proxmox Network Configuration

### Virtual Bridge Setup
```yaml
Network Bridges:
  vmbr0: Management Bridge
    - Physical interface: eth0
    - VLAN aware: Yes
    - Used for: Proxmox management, VM management

  vmbr1: Cluster Bridge  
    - Physical interface: eth1
    - VLAN aware: Yes
    - Used for: Kubernetes node communication

  vmbr2: Storage Bridge
    - Physical interface: eth2 (optional dedicated)
    - VLAN aware: Yes
    - Used for: Storage traffic isolation

Bridge Configuration:
  STP: Spanning Tree Protocol disabled (single switch)
  Multicast: IGMP snooping enabled
  MTU: 1500 (standard Ethernet)
  VLAN Filtering: Enabled for security
```

### VM Network Assignment
```yaml
Virtual Machine Networks:
  Kubernetes Master:
    - Management: vmbr0.10 (VLAN 10)
    - Cluster: vmbr1.30 (VLAN 30)
    - Storage: vmbr2.40 (VLAN 40)

  Kubernetes Workers:
    - Cluster: vmbr1.30 (VLAN 30)
    - Storage: vmbr2.40 (VLAN 40)

  Infrastructure Services:
    - Service Network: vmbr0.20 (VLAN 20)
    - Management: vmbr0.10 (VLAN 10)
```

## DNS Architecture

### DNS Resolution Strategy
```yaml
DNS Hierarchy:
  Level 1: Kubernetes CoreDNS
    - Cluster internal resolution (.cluster.local)
    - Service discovery within Kubernetes
    - Pod-to-pod communication

  Level 2: Infrastructure DNS (AdGuard)
    - Internal domain resolution (.local, .lan)
    - External DNS filtering and blocking
    - Network-wide DNS policies

  Level 3: External DNS
    - Internet domain resolution
    - Public DNS providers (1.1.1.1, 8.8.8.8)
    - Failover and redundancy
```

### DNS Flow
```yaml
Resolution Path:
  Pod Query → CoreDNS → AdGuard → External DNS
  
Internal Domains:
  *.cluster.local → CoreDNS directly
  *.local → AdGuard DNS
  *.lan → AdGuard DNS

External Domains:
  Public domains → AdGuard → External DNS
  Blocked domains → AdGuard (blocked response)
```

## Network Security

### Firewall Strategy
```yaml
Network Policies:
  Default Deny: All traffic blocked by default
  Explicit Allow: Required communications only
  Logging: Security events and policy violations

Firewall Layers:
  1. Router/Gateway: Internet ingress filtering
  2. Proxmox Host: VM traffic filtering  
  3. Kubernetes: Cilium network policies
  4. Application: Service-specific controls
```

### Traffic Flow Control
```yaml
Ingress Traffic:
  Internet → Router → Load Balancer VLAN → Cilium Ingress

Internal Traffic:
  Pod-to-Pod: Cilium CNI within cluster network
  Pod-to-Service: Service discovery and load balancing
  Cross-VLAN: Controlled router-based routing

Storage Traffic:
  Dedicated VLAN: Isolation from cluster traffic
  Performance: Reduced network contention
  Security: Storage-specific access controls
```

## Monitoring and Observability

### Network Monitoring
```yaml
Metrics Collection:
  Interface Statistics: Bandwidth, packets, errors
  VLAN Utilization: Per-VLAN traffic analysis
  Bridge Performance: Virtual bridge metrics
  DNS Queries: Resolution patterns and failures

Tools:
  SNMP: Switch and router monitoring
  Prometheus: Network metrics collection
  Victoria Metrics: Efficient metrics storage
  Grafana: Network dashboard visualization
```

### Network Troubleshooting
```yaml
Diagnostic Tools:
  Physical Layer: Cable testing, port statistics
  Data Link: VLAN configuration, bridge status
  Network Layer: Routing tables, ARP entries
  Transport Layer: Port connectivity, service health

Log Analysis:
  Router Logs: Traffic patterns, blocked connections
  Proxy Logs: DNS resolution issues
  Kubernetes: CNI plugin logs and events
```

## Performance Optimization

### Bandwidth Management
```yaml
Traffic Shaping:
  Management Traffic: 100 Mbps guaranteed
  Kubernetes Cluster: 500 Mbps guaranteed  
  Storage Traffic: 200 Mbps guaranteed
  Internet Access: Remaining bandwidth

Quality of Service:
  Real-time: Management and monitoring
  High Priority: Cluster communication
  Medium Priority: Storage replication
  Low Priority: Backup and bulk transfers
```

### Network Efficiency
- **Jumbo Frames**: Enabled where supported for storage traffic
- **Link Aggregation**: Bonded interfaces for bandwidth and redundancy
- **VLAN Pruning**: Unused VLANs removed from trunk links
- **Multicast Optimization**: IGMP snooping for efficient multicast

This network architecture provides the foundation for secure, performant, and scalable infrastructure supporting the Kubernetes homelab environment.