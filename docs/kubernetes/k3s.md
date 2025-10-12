# K3s Implementation

This page details the K3s distribution implementation used in the homelab cluster.

## Why K3s?

K3s was chosen over standard Kubernetes for several homelab-specific advantages:

### Resource Efficiency
- **Single Binary**: All components packaged in one executable (~100MB)
- **Low Memory Footprint**: ~512MB base memory usage vs 2GB+ for full K8s
- **Optimized for Edge**: Designed for resource-constrained environments

### Operational Simplicity
- **Embedded Database**: SQLite instead of external etcd cluster
- **Built-in Components**: Includes CNI, CSI, ingress controller, and more
- **Easy Installation**: Single command deployment

### Production Ready
- **CNCF Certified**: Fully compliant Kubernetes distribution
- **Regular Updates**: Follows upstream Kubernetes release cycle
- **Enterprise Support**: Backed by SUSE/Rancher

## Database Architecture

### SQLite vs etcd

K3s uses SQLite by default, which differs from standard Kubernetes:

| Aspect | SQLite (K3s) | etcd (Standard K8s) |
|--------|--------------|-------------------|
| **Complexity** | Single file database | Distributed key-value store |
| **HA Support** | Single node only | Multi-node cluster |
| **Resource Usage** | ~10MB memory | ~200MB+ per node |
| **Backup** | File copy | etcd snapshots |
| **Maintenance** | Minimal | Cluster management required |

## Resource Usage

### Baseline Resource Consumption

| Component | CPU (cores) | Memory (MB) | Notes |
|-----------|-------------|-------------|-------|
| **K3s Server** | 0.1-0.3 | 400-600 | Including all control plane |
| **K3s Agent** | 0.05-0.1 | 100-200 | Per worker node |
| **SQLite DB** | 0.01 | 10-20 | Embedded database |

### Scaling Characteristics

```
Node Count    Total Memory    CPU Usage
1 (server)    ~500MB         ~0.2 cores
3 (1+2)       ~900MB         ~0.4 cores
5 (1+4)       ~1.3GB         ~0.6 cores
```
