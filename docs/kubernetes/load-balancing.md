# Load Balancing

This page details the load balancing implementation using Cilium's native LoadBalancer capabilities for bare metal Kubernetes clusters, including L2 announcements, BGP integration, and advanced traffic management features.

## Cilium LoadBalancer Overview

Cilium provides integrated LoadBalancer services for bare metal clusters through its native L2 announcements and BGP capabilities, eliminating the need for separate load balancer implementations like MetalLB.

### Why Cilium LoadBalancer?

| Feature | Cilium LB | Cloud LoadBalancer | NodePort | ClusterIP |
|---------|-----------|-------------------|----------|-----------|
| **Integration** | Native with CNI | Cloud-native | Built-in | Built-in |
| **eBPF Performance** | Yes (high performance) | Varies | No | No |
| **Network Policies** | Integrated & advanced | Limited | None | None |
| **Observability** | Built-in Hubble | Cloud-specific | Basic | Basic |
| **Configuration** | Kubernetes CRDs | Cloud console | Service spec | Service spec |
| **BGP Support** | Yes | Yes | No | No |
| **L2 Announcements** | Yes | N/A | No | No |
| **Service Mesh** | Integrated | Separate product | No | No |
| **Cost** | Free (self-hosted) | Pay per LB | Free | Free |
| **External Access** | Dedicated IPs | Cloud IPs | Node IPs + ports | Internal only |

## Architecture

### Cilium LoadBalancer Components

Cilium's LoadBalancer implementation consists of several integrated components:

<!-- TODO: IMAGE FOR CILIUM LB ARCHITECTURE showing agent, operator, and L2/BGP announcements -->

**Key Components:**
- **Cilium Agent**: Handles eBPF datapath and service load balancing
- **Cilium Operator**: Manages LoadBalancer IP allocation and announcements
- **L2 Announcement**: ARP/NDP-based IP advertisement (current implementation)
- **BGP Integration**: Router peering for advanced networking (future option)

### L2 Announcements (Current Implementation)

Cilium uses L2 announcements to advertise LoadBalancer IPs on the local network:

<!-- TODO: IMAGE FOR CILIUM L2 ANNOUNCEMENTS showing leader election and ARP responses -->

**Characteristics:**
- **eBPF Acceleration**: Fast packet processing with eBPF datapath
- **Leader Election**: Automatic failover between Cilium agents
- **Network Policy Integration**: Service-level security policies
- **Observability**: Built-in metrics and Hubble flow visibility
- **Limitations**: Single active node per service (like traditional L2)

### IP Address Planning

1. **Reserve Ranges**: Create separate CiliumLoadBalancerIPPool resources for different service types
2. **Documentation**: Maintain IP allocation spreadsheet with pool assignments
3. **DHCP Exclusions**: Exclude Cilium LoadBalancer IP ranges from DHCP
4. **Network Segmentation**: Consider VLANs for different service tiers

### Security Considerations

1. **Network Policies**: Use Cilium NetworkPolicies for service-level security
2. **Service Mesh**: Leverage Cilium's service mesh capabilities for mTLS
3. **Certificate Management**: Use cert-manager for TLS certificates
4. **Access Control**: Implement proper RBAC for Cilium resources
5. **Firewall Integration**: Configure firewall rules for LoadBalancer IPs

### Performance Optimization

1. **eBPF Acceleration**: Ensure eBPF is properly enabled for maximum performance
2. **Node Distribution**: Cilium agents run on all nodes automatically
3. **Traffic Policies**: Choose appropriate external traffic policy (Local vs Cluster)
4. **Resource Limits**: Set appropriate resource limits for Cilium agents
5. **Interface Selection**: Configure appropriate network interfaces for L2 announcements
6. **Load Balancing Algorithm**: Use consistent hashing (maglev) for better distribution

For more information on networking, see [Networking (CNI)](networking.md) and the overall [Kubernetes Overview](index.md).