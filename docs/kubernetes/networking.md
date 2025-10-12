# Kubernetes Networking (CNI)

This page details the Cilium CNI implementation used for cluster networking, including eBPF-based features, network policies, and ingress capabilities.

## Cilium Overview

Cilium is an eBPF-based CNI that provides advanced networking, security, and observability features for Kubernetes.

### Why Cilium?

| Feature | Cilium | Traditional CNI |
|---------|--------|-----------------|
| **Performance** | eBPF in-kernel processing | Userspace processing |
| **Security** | Network policies + microsegmentation | Basic network policies |
| **Observability** | L3/L4/L7 visibility | Limited visibility |
| **Load Balancing** | Native L4/L7 LB | External LB required |
| **Service Mesh** | Built-in capabilities | Separate service mesh |
| **Protocol Support** | L3/L4/L7 | Primarily L3/L4 |

## Architecture

### eBPF-Based Networking

Cilium leverages eBPF (extended Berkeley Packet Filter) for high-performance networking:

```
┌─────────────────────────────────────────────────────────────┐
│                    Application Layer                        │
└─────────────────┬───────────────────────────────────────────┘
                  │
┌─────────────────▼───────────────────────────────────────────┐
│                 Kubernetes Service                          │
└─────────────────┬───────────────────────────────────────────┘
                  │
┌─────────────────▼───────────────────────────────────────────┐
│            Cilium eBPF Programs                             │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────────────────┐│
│  │ L4 Ingress  │ │ L4 Egress   │ │    Network Policies     ││
│  │    Proxy    │ │    Proxy    │ │                         ││
│  └─────────────┘ └─────────────┘ └─────────────────────────┘│
└─────────────────┬───────────────────────────────────────────┘
                  │
┌─────────────────▼───────────────────────────────────────────┐
│                 Linux Kernel                                │
│              (eBPF Execution)                               │
└─────────────────┬───────────────────────────────────────────┘
                  │
┌─────────────────▼───────────────────────────────────────────┐
│                Physical Network                             │
└─────────────────────────────────────────────────────────────┘
```

### Cilium Components

#### Cilium Agent (DaemonSet)
- **eBPF Program Management**: Loads and manages eBPF programs
- **Policy Enforcement**: Implements network policies
- **Service Load Balancing**: Distributes traffic to endpoints
- **CNI Plugin**: Handles pod network interface creation

#### Cilium Operator (Deployment)
- **CRD Management**: Handles Cilium custom resources
- **IP Address Management**: Manages pod IP allocation
- **Node Discovery**: Maintains cluster node information
- **Garbage Collection**: Cleans up unused resources

#### Hubble (Optional Observability)
- **Network Visibility**: L3/L4/L7 traffic observation
- **Flow Logs**: Detailed network flow information
- **Service Maps**: Automatic service dependency mapping
- **Security Monitoring**: Policy violation detection

## Ingress Controller

![Ingress Architecture](../resources/images/architecture/ingress.drawio.svg)

### Cilium Ingress vs NGINX Ingress

| Feature | Cilium Ingress | NGINX Ingress |
|---------|----------------|---------------|
| **Integration** | Native CNI integration | Separate component |
| **Performance** | eBPF L4/L7 processing | User-space proxy |
| **Network Policies** | Seamless integration | Limited integration |
| **Resource Usage** | Lower overhead | Higher memory usage |
| **Features** | Basic L7 routing | Advanced L7 features |

## Security Features

### Network Microsegmentation

Cilium enables fine-grained security policies:

#### L3/L4 Policies
```yaml
apiVersion: cilium.io/v2
kind: CiliumNetworkPolicy
metadata:
  name: database-access
spec:
  endpointSelector:
    matchLabels:
      app: postgresql
  ingress:
  - fromEndpoints:
    - matchLabels:
        app: nextcloud
    - matchLabels:
        app: authentik
    toPorts:
    - ports:
      - port: "5432"
        protocol: TCP
```

#### L7 HTTP Policies
```yaml
apiVersion: cilium.io/v2
kind: CiliumNetworkPolicy
metadata:
  name: api-l7-policy
spec:
  endpointSelector:
    matchLabels:
      app: api-server
  ingress:
  - fromEndpoints:
    - matchLabels:
        app: frontend
    toPorts:
    - ports:
      - port: "8080"
        protocol: TCP
      rules:
        http:
        - method: "GET"
          path: "/api/.*"
        - method: "POST"
          path: "/api/v1/data"
          headers:
          - "Content-Type: application/json"
```

## Observability with Hubble

### Hubble UI

Access the Hubble UI for visual network observability

## DNS Architecture

![DNS Architecture](../resources/images/architecture/dns.drawio.svg)

The cluster implements a comprehensive DNS strategy combining internal cluster DNS with external DNS management and filtering.

### DNS Components

#### CoreDNS (Cluster DNS)
- **Internal Resolution**: Service and pod name resolution within cluster
- **Custom Domains**: Internal `.cluster.local` domain handling
- **Upstream Forwarding**: External DNS queries forwarded to AdGuard

#### External DNS
- **Automatic Records**: Creates DNS records for ingress resources
- **AdGuard Integration**: Updates AdGuard DNS with service endpoints
- **Domain Management**: Manages `.homelab.local` domain records

#### AdGuard DNS Filtering
- **Upstream DNS**: Handles external DNS resolution
- **Ad Blocking**: Network-wide advertisement filtering
- **Custom Rules**: Homelab-specific DNS rules and overrides

For more information on load balancing, see [Load Balancing](load-balancing.md).