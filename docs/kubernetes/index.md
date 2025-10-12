# Kubernetes Cluster Overview

This section documents the K3s-based Kubernetes cluster that forms the core of the homelab infrastructure.

## Cluster Specifications

| Specification       | Details                    |
|-------------------|---------------------------|
| **Distribution**    | K3s v1.33.3               |
| **Master Nodes**    | 1 (single control plane)  |
| **Worker Nodes**    | 2                         |
| **Container Runtime** | containerd               |
| **CNI**             | Cilium (eBPF-based)       |
| **CSI**             | Local Path + NFS CSI      |
| **Database**        | SQLite (embedded)         |
| **Load Balancer**   | Cilium LB IPAM      |
| **Ingress**         | Cilium Ingress Controller |
| **High Availability** | No (single master)      |

## Architecture Overview

The cluster implements a production-ready architecture optimized for homelab environments:

![Infrastructure Architecture](../resources/images/architecture/infrastructure.drawio.svg)

## Core Components

### Control Plane (1 node)
- **K3s Server**: Single control plane for simplicity
- **SQLite Database**: Embedded datastore (no external etcd)
- **Kubernetes API Server**: Cluster management endpoint
- **Scheduler & Controller Manager**: Workload orchestration

### Worker Nodes (2 nodes)
- **K3s Agents**: Join control plane via secure token
- **Container Runtime**: containerd for container execution
- **Kubelet**: Node agent for pod lifecycle management
- **Kube-proxy**: Network routing (supplemented by Cilium)

### Network Layer (Cylium CNI)
- **eBPF-based Networking**: High-performance packet processing
- **Network Policies**: Microsegmentation and security
- **Service Mesh Ready**: Transparent encryption capabilities
- **Ingress Controller**: L7 load balancing and TLS termination

### Storage Layer
- **Local Path Provisioner**: Local storage for stateless workloads
- **NFS CSI Driver**: Shared storage for persistent data
- **Automatic Provisioning**: Dynamic PV creation

### Load Balancing (Cilium IPAM)
- **Bare Metal LoadBalancer**: External IP allocation
- **BGP Mode**: Route advertisement to upstream router
- **IP Pool Management**: Dedicated IP ranges for services

## Key Features

### GitOps with FluxCD
- **Source Controller**: Git repository synchronization
- **Kustomize Controller**: Manifest processing and application
- **Helm Controller**: Helm chart deployment and management
- **Notification Controller**: Alerting and webhook integration

### Observability Stack
- **Victoria Metrics**: Time-series metrics storage
- **Victoria Logs**: Log aggregation (replaced Loki)
- **OpenTelemetry**: Traces and metrics collection
- **Grafana**: Visualization and alerting

### Security Framework
- **Authentik**: Identity provider and SSO
- **External Secrets**: Secret management from external systems
- **Cert-manager**: Automatic TLS certificate provisioning
- **Network Policies**: Traffic microsegmentation

### Application Platform
- **25+ Applications**: Production workloads running
- **Multi-tenancy**: Namespace-based isolation
- **Resource Management**: Requests, limits, and quotas
- **Health Monitoring**: Probes and automated restarts

## Network Architecture

### IP Allocation
```
Cluster CIDR:     10.42.0.0/16
Service CIDR:     10.43.0.0/16
Pod CIDR:         10.42.0.0/16
Cilium LB Pool:     192.168.x.240/28
```

### DNS Configuration
- **CoreDNS**: Cluster DNS resolution
- **External DNS**: Automatic DNS record management
- **AdGuard**: DNS filtering integration

For detailed technical information, see the individual component pages:
- [K3s Implementation](k3s.md) - K3s-specific configuration
- [Networking](networking.md) - Cilium CNI deep dive
- [Storage](storage.md) - CSI drivers and storage classes
- [Load Balancing](load-balancing.md) - Cilium LB configuration
- [Applications](applications.md) - Deployed workloads