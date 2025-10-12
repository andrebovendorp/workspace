# Infrastructure Storage

This document details the storage architecture and systems implemented in the homelab infrastructure layer.

## Storage Architecture Overview

The infrastructure implements a multi-tier storage strategy combining high-performance local storage with network-attached storage for different workload requirements.

### Storage Tiers
```yaml
Tier 1 - High Performance:
  Technology: NVMe SSD storage
  Use Cases: Operating systems, databases, caches
  Characteristics: Low latency, high IOPS
  Redundancy: Local ZFS mirroring

Tier 2 - Shared Storage:
  Technology: Network File System (NFS)
  Use Cases: Shared configurations, media files
  Characteristics: High capacity, shared access
  Redundancy: RAID-Z2 with network replication

Tier 3 - Backup Storage:
  Technology: External/cloud storage
  Use Cases: Backups, archival data
  Characteristics: High capacity, cost-effective
  Redundancy: Geographic distribution
```

## ZFS Storage Foundation

### ZFS Pool Configuration
```yaml
Root Pool (rpool):
  Devices: NVMe SSD (mirrored for redundancy)
  Compression: lz4 (space efficient, fast)
  Deduplication: Disabled (resource intensive)
  Snapshots: Automated hourly/daily snapshots
  
Data Pool (data):
  Devices: SATA SSDs in RAID-Z2 configuration
  Compression: lz4 for general data
  Encryption: AES-128 for sensitive data
  Recordsize: Optimized per dataset type
```

### ZFS Dataset Organization
```yaml
Dataset Structure:
  rpool/ROOT: Proxmox root filesystem
  rpool/data: VM storage datasets
  rpool/images: VM templates and ISOs
  
  data/vms: Virtual machine disk images
  data/containers: Container persistent volumes
  data/backups: Local backup storage
  data/exports: NFS export datasets
```

### ZFS Performance Tuning
```yaml
Memory Allocation:
  ARC Size: 25% of system RAM maximum
  L2ARC: NVMe cache for frequently accessed data
  ZIL: Separate SLOG device for sync writes

Block Sizes:
  Default: 128KB for mixed workloads
  Databases: 8KB recordsize for random access
  Media Files: 1MB recordsize for sequential access
  VM Images: 64KB recordsize balanced performance
```

## Network File System (NFS)

### NFS Server Configuration
```yaml
NFS Version: NFSv4.1 with Kerberos support
Exports Configuration:
  /exports/kubernetes: Kubernetes persistent volumes
  /exports/media: Media server content
  /exports/backups: Backup storage access
  /exports/configs: Shared configuration files

Performance Options:
  async: Improved write performance
  no_subtree_check: Better performance
  crossmnt: Cross-mount support
  fsid: Unique filesystem identifiers
```

### NFS Client Optimization
```yaml
Mount Options:
  nfsvers=4.1: Latest stable protocol version
  hard: Ensure data integrity
  intr: Allow signal interruption
  rsize=32768: Read buffer size optimization
  wsize=32768: Write buffer size optimization
  timeo=600: Timeout configuration
```

### Network Storage Performance
```yaml
Network Configuration:
  Dedicated Storage VLAN: Isolated traffic
  Jumbo Frames: 9000 MTU where supported
  Link Aggregation: Bonded interfaces
  Quality of Service: Storage traffic prioritization

Throughput Characteristics:
  Sequential Read: 800+ MB/s
  Sequential Write: 600+ MB/s  
  Random IOPS: 10,000+ IOPS
  Latency: <2ms average
```

## Kubernetes Storage Integration

### Storage Classes
```yaml
local-path:
  Provisioner: Local Path Provisioner
  VolumeBindingMode: WaitForFirstConsumer
  StorageBackend: Local NVMe storage
  Use Cases: Databases, high-IOPS workloads

nfs-client:
  Provisioner: NFS Subdir External Provisioner  
  VolumeBindingMode: Immediate
  StorageBackend: Network NFS storage
  Use Cases: Shared data, configuration files

fast-local:
  Provisioner: Local Path Provisioner
  VolumeBindingMode: WaitForFirstConsumer
  StorageBackend: Dedicated high-performance tier
  Use Cases: Critical applications, caches
```

### Volume Management Strategy
```yaml
Persistent Volume Claims:
  Sizing: Right-sized with growth planning
  Access Modes: ReadWriteOnce for most workloads
  Reclaim Policy: Retain for data protection
  Storage Selection: Workload-appropriate tiers

Volume Lifecycle:
  Creation: Dynamic provisioning preferred
  Expansion: Online volume expansion supported
  Backup: Automated snapshot scheduling
  Cleanup: Orphaned volume detection and cleanup
```

## Backup and Recovery Strategy

### Backup Architecture
```yaml
Local Backups:
  ZFS Snapshots: Point-in-time recovery
  Frequency: Hourly for critical data
  Retention: 24 hourly, 7 daily, 4 weekly
  Recovery Time: Minutes for snapshot restore

Remote Backups:
  Network Replication: ZFS send/receive
  Frequency: Daily incremental, weekly full
  Destination: Remote NAS or cloud storage
  Recovery Time: Hours for full restore

Application Backups:
  Database Dumps: Logical backups for databases
  Configuration Exports: Application settings
  Volume Snapshots: Kubernetes PVC snapshots
  Testing: Monthly backup restore verification
```

### Disaster Recovery Planning
```yaml
Recovery Objectives:
  RTO: 4 hours for complete infrastructure
  RPO: 1 hour maximum data loss
  Testing: Quarterly disaster recovery drills

Recovery Procedures:
  Level 1: ZFS snapshot rollback (5 minutes)
  Level 2: VM restore from backup (30 minutes)
  Level 3: Full infrastructure rebuild (4 hours)
  Level 4: Remote site activation (8 hours)
```

## Monitoring and Maintenance

### Storage Monitoring
```yaml
Metrics Collection:
  ZFS Pool Health: Scrub status, error rates
  Disk Health: SMART data, temperature
  Performance: IOPS, throughput, latency
  Capacity: Usage trends, growth planning

Alerting:
  Critical: Disk failures, pool degradation
  Warning: High capacity usage, performance issues
  Info: Scrub completion, snapshot creation

Tools Integration:
  Prometheus: Metrics collection and alerting
  Victoria Metrics: Efficient storage of metrics
  Grafana: Storage dashboard visualization
```

### Maintenance Procedures
```yaml
Regular Maintenance:
  Weekly: ZFS scrub operations
  Monthly: Disk health assessment
  Quarterly: Backup restore testing
  Annually: Storage capacity planning

Performance Optimization:
  Compression Analysis: Ratio monitoring
  Deduplication Review: Space vs. performance
  Cache Tuning: ARC and L2ARC optimization
  Workload Analysis: Storage tier optimization
```

## Security and Compliance

### Data Protection
```yaml
Encryption:
  At Rest: ZFS native encryption
  In Transit: NFS with Kerberos/TLS
  Key Management: Secure key storage
  Compliance: Data protection regulations

Access Control:
  POSIX Permissions: File system level security
  NFS Security: Network access controls
  Kubernetes RBAC: Volume access policies
  Audit Logging: Storage access tracking
```

### Data Integrity
```yaml
Checksumming:
  ZFS: Built-in checksum verification
  Scrubbing: Regular data integrity checks
  Repair: Automatic error correction
  Monitoring: Error rate tracking

Validation:
  Backup Verification: Restore testing
  Corruption Detection: Checksum monitoring
  Performance Validation: Benchmark testing
  Capacity Planning: Growth trend analysis
```

This storage architecture provides the reliable, performant foundation required for running production workloads in the Kubernetes homelab environment.