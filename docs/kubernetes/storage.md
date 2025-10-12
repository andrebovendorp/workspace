# Kubernetes Storage (CSI)

This page details the Container Storage Interface (CSI) implementation used in the cluster, including local storage and NFS-based persistent volumes.

## Storage Architecture Overview

The cluster implements a hybrid storage architecture optimized for different workload types:

<!-- TODO: IMAGE FOR STORAGE ARCHITECTURE showing local path, NFS CSI, and application tiers -->

## Storage Classes

### Local Path Storage (Default)

Used for applications that don't require high availability but performance.

**Characteristics:**
- **Performance**: High I/O performance (local SSD)
- **Availability**: Node-specific (no HA)
- **Use Cases**: Databases, caches, temporary storage
- **Backup**: Application-level backups required

### NFS Storage Class

Used for shared data that needs to be accessible from multiple pods or persisted across node failures.

**Characteristics:**
- **Performance**: Network-dependent I/O
- **Availability**: High availability (network storage)
- **Use Cases**: Media files, shared configs, backups
- **Backup**: NFS-level snapshots and backups

## Design

### Storage Class Design

1. **Default Class**: Keep `local-path` as default for most workloads
2. **Specific Classes**: Create purpose-built classes for special requirements
3. **Reclaim Policies**: Use `Retain` for important data, `Delete` for temporary

### Application Guidelines

1. **Stateless Apps**: Use `emptyDir` or no persistent storage
2. **Databases**: Use local storage with backup strategies
3. **Shared Data**: Use NFS for multi-pod access
4. **Media Files**: Use NFS with appropriate mount options

### Performance Optimization

1. **Node Affinity**: Pin high-I/O workloads to specific nodes
2. **Storage Tiering**: Use fast local storage for hot data
3. **Mount Options**: Optimize NFS mount options for workload type
4. **Resource Limits**: Set appropriate I/O limits to prevent noisy neighbors

For more information on the overall cluster architecture, see [Kubernetes Overview](index.md).