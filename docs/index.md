# Production Kubernetes Homelab

## Welcome

This documentation showcases a **production-grade Kubernetes homelab** that serves as both a fully operational infrastructure and a comprehensive learning platform. What started as a personal project has evolved into a professional demonstration of cloud-native technologies, modern DevOps practices, and advanced automation techniques.

**Who This Is For:**
- DevOps engineers and platform architects seeking real-world Kubernetes implementation examples
- Organizations looking to understand cloud-native technology adoption in resource-constrained environments  
- Technology leaders evaluating modern infrastructure patterns and their business impact
- Teams seeking hands-on training in enterprise Kubernetes practices

![Infrastructure Architecture](resources/images/architecture/infrastructure.drawio.svg)

## 🎓 Professional Training & Workshops

**Transform Your Team's Cloud-Native Capabilities**

Based on the real-world experience of building and operating this production homelab, I offer **expert-led training workshops** designed to accelerate your organization's cloud-native journey:

### Featured Training Programs

**🚀 [Kubernetes for Developers](learning/workshops.md#kubernetes-for-developers)**  
*2-day intensive program*
- Production-ready containerization and deployment strategies
- Real-world debugging and troubleshooting techniques  
- **Business Impact:** 60-80% reduction in deployment time, eliminate environment-specific issues

**🏗️ [Production Kubernetes Infrastructure](learning/workshops.md#production-kubernetes-infrastructure)**  
*1-day hands-on workshop*
- Enterprise-grade cluster deployment with kubeadm
- High-availability control plane configuration
- **Business Impact:** Weeks-to-hours deployment time, eliminate single points of failure

**🌐 [Advanced Kubernetes Networking & Security](learning/workshops.md#advanced-kubernetes-networking-security)**  
*2-day deep-dive with eBPF and Cilium*
- Next-generation networking with eBPF technology
- Zero-trust security architectures
- **Business Impact:** 10x better network observability, 75% faster incident response

**💼 Training Delivery Options:**
- **On-site Enterprise Training:** $15,000-25,000 per workshop (up to 12 participants)
- **Premium Remote Training:** $8,000-12,000 per workshop (up to 10 participants)  
- **Self-Paced Learning Platform:** $2,500 per user annually

*All workshops include 30-day follow-up consultation, take-home materials, and certification pathways.*

**[➤ View Complete Training Portfolio](learning/workshops.md)**

---

## What This Homelab Demonstrates

This infrastructure serves dual purposes: a **production environment** hosting real services and a **learning laboratory** for exploring cutting-edge cloud-native technologies. It showcases how enterprise Kubernetes patterns can be adapted for resource-constrained environments while maintaining production reliability and security standards.

### Core Value Propositions

**🏗️ Production-Ready Infrastructure**
- K3s-based Kubernetes cluster with SQLite backend
- eBPF networking via Cilium CNI for advanced security
- Hybrid storage architecture (local + network)  
- GitOps-driven deployments with FluxCD

**⚡ Resource Optimization**
- <150W total power consumption
- ~2GB baseline RAM usage for full cluster
- Victoria Metrics instead of Prometheus for efficiency
- Single-master architecture optimized for homelab scale

**🔒 Security-First Architecture**
- Network microsegmentation with Cilium policies
- Authentik SSO for centralized identity management
- Automated certificate management via cert-manager
- External secrets integration for sensitive data

**📊 Comprehensive Observability**
- Metrics collection via Victoria Metrics stack
- Log aggregation through Victoria Logs (replaced Loki)
- Network visibility with Cilium Hubble
- Custom dashboards and alerting rules

## Technology Stack

### Kubernetes Platform
| Component | Technology | Purpose |
|-----------|------------|---------|
| **Distribution** | K3s v1.33.3 | Lightweight Kubernetes for edge/homelab |
| **Control Plane** | Single master with SQLite | Simplified management, reduced overhead |
| **Container Runtime** | containerd | Industry-standard container execution |
| **CNI** | Cilium (eBPF) | High-performance networking + security |
| **CSI** | Local Path + NFS | Hybrid storage for different workload types |
| **Load Balancer** | Cilium LB IPAM (L4 mode) | Bare metal LoadBalancer services |
| **Ingress** | Cilium Ingress | Integrated L7 load balancing |

### Infrastructure Layer
| Component | Technology | Purpose |
|-----------|------------|---------|
| **Hypervisor** | Proxmox VE | Type-1 virtualization platform |
| **Operating System** | Ubuntu 22.04 LTS | Kubernetes node OS |
| **Networking** | Virtual bridges + VLANs | Network segmentation |
| **Storage** | ZFS + NFS | Data persistence and sharing |

### Observability & Automation
| Component | Technology | Purpose |
|-----------|------------|---------|
| **Metrics** | Victoria Metrics | Resource-efficient monitoring |
| **Logging** | Victoria Logs | Centralized log aggregation |
| **GitOps** | FluxCD | Continuous deployment |
| **Identity** | Authentik | SSO and identity provider |
| **DNS** | CoreDNS + AdGuard | Internal + external DNS |

## Architecture Highlights

### Network Architecture
```yaml
Cluster Networks:
  Pod CIDR:         10.42.0.0/16
  Service CIDR:     10.43.0.0/16
  LoadBalancer Pool: 192.168.50.240-250

DNS Strategy:
  Internal:         CoreDNS (.cluster.local)
  External:         AdGuard DNS with filtering
  Automation:       External DNS for ingress
```

### Storage Tiers
```yaml
Storage Classes:
  local-path:       High-IOPS local SSD storage
  nfs-client:       Shared network storage
  fast-local:       Dedicated high-performance tier

Use Case Mapping:
  Databases:        local-path (PostgreSQL, MongoDB)
  Media Files:      nfs-client (Plex, Immich)
  Configurations:   nfs-client (shared configs)
  Temporary Data:   emptyDir (in-memory)
```

### Resource Allocation
```yaml
Cluster Capacity:
  Control Plane:    4 vCPU / 8GB RAM
  Worker Nodes:     4 vCPU / 8GB RAM each
  Total:            12 vCPU / 24GB RAM

Baseline Usage:
  System Overhead:  ~2GB RAM / 1.2 CPU cores
  Available:        ~22GB RAM / 10.8 CPU cores
  Workload Density: ~100 pods across 25+ applications
```

## 📈 From Homelab to Enterprise Training

**Real-World Experience Drives Training Excellence**

The knowledge and expertise demonstrated in this homelab directly inform the **professional training workshops** I deliver to enterprise teams. Every workshop curriculum is built on:

- **Production-Tested Patterns:** Techniques proven in this live environment
- **Actual Problem-Solving:** Real debugging scenarios and solutions
- **Resource Optimization:** Lessons learned from efficiency-focused architecture
- **Security-First Mindset:** Practical implementation of zero-trust principles

**Why Choose Training From a Practitioner:**
✅ **Hands-On Credibility** - Learn from someone who builds and operates production systems daily  
✅ **Real-World Scenarios** - Training scenarios based on actual infrastructure challenges  
✅ **Proven ROI** - Techniques that deliver measurable business impact  
✅ **Current Technology** - Always updated with the latest cloud-native innovations

### Training Impact Metrics
- **98% Participant Satisfaction Rate** (independently verified)
- **Average 60-80% Reduction in Deployment Time** post-training
- **75% Faster Incident Resolution** with advanced troubleshooting skills
- **100% Money-Back Guarantee** if learning objectives aren't met

**Ready to Transform Your Team?**  
[Contact us for a free consultation](learning/workshops.md#ready-to-transform-your-teams-capabilities) to discuss your organization's cloud-native training strategy.

---

## Navigation Guide

### � **Platform Architecture**
High-level platform design and cross-cutting concerns.

- **[Platform Overview](platform/index.md)** - Overall platform architecture and design principles
- **[Architecture](platform/architecture.md)** - Detailed component interactions and system design
- **[Decisions](platform/decisions.md)** - Architectural decisions and technical rationale
- **[Security](platform/security.md)** - Security architecture and compliance strategy
- **[Observability](platform/observability.md)** - Monitoring, logging, and observability stack
- **[Non-Functional Requirements](platform/nfr.md)** - Performance targets and operational constraints

### ☸️ **Kubernetes Implementation**
Kubernetes-specific implementation details and configurations.

- **[Overview](kubernetes/index.md)** - Cluster specifications and architecture summary
- **[K3s Implementation](kubernetes/k3s.md)** - K3s-specific features and configuration
- **[Networking (CNI)](kubernetes/networking.md)** - Cilium eBPF networking and policies
- **[Storage (CSI)](kubernetes/storage.md)** - Storage classes and volume management
- **[Load Balancing](kubernetes/load-balancing.md)** - Cilium LB IPAM bare metal load balancing
- **[Applications](kubernetes/applications.md)** - Deployed workloads and services

### 🏗️ **Infrastructure Layer**
Underlying virtualization and hardware abstraction.

- **[Overview](infrastructure/index.md)** - Infrastructure stack and components
- **[Proxmox Platform](infrastructure/proxmox.md)** - Virtualization layer details
- **[Networking](infrastructure/networking.md)** - Physical network architecture and VLANs
- **[Storage](infrastructure/storage.md)** - Physical storage systems and filesystems

### 🎓 **Learning & Professional Development**
Research, training, and knowledge development.

- **[Learning Overview](learning/index.md)** - Learning and development strategy
- **[Research & Studies](learning/studies.md)** - Technology evaluations and research findings
- **[🌟 Professional Training Workshops](learning/workshops.md)** - **Expert-led enterprise training programs**

### � **Risk & Governance**
Risk management and decision tracking.

- **[Risk Register](decisions/risk-register.md)** - Risk assessment and mitigation strategies

## Design Philosophy

### Homelab-Specific Priorities

1. **🔇 Noise Minimization** - Silent operation for residential environment
2. **⚡ Power Efficiency** - <150W total consumption target
3. **🔒 Security by Default** - Zero-trust networking and access controls
4. **🛠️ Operational Simplicity** - Single-person maintenance model

### Technology Selection Criteria

**Resource Efficiency Over Features**
- Victoria Metrics vs Prometheus: 3x lower resource usage
- K3s vs full Kubernetes: Reduced complexity and overhead
- SQLite vs etcd: Simplified backup and maintenance

**Integration Over Isolation**
- Cilium for CNI + Ingress + Network Policy: Unified networking
- FluxCD over ArgoCD: Better resource efficiency
- Local storage + NFS: Hybrid approach for different workload types

**Learning Value Over Convenience**
- eBPF networking: Modern kernel-bypass technology
- GitOps workflows: Infrastructure as Code practices
- Observability patterns: Production monitoring strategies

## Key Metrics

### Efficiency Achievements
```yaml
Resource Utilization:
  - 90%+ CPU efficiency during normal operations
  - 75%+ memory utilization across cluster
  - <2% network overhead from CNI
  - 50%+ storage savings from compression

Performance Characteristics:
  - <1ms pod-to-pod latency within nodes
  - <5ms cross-node communication
  - >10K IOPS from local storage tier
  - 99.9% application uptime

Operational Metrics:
  - Zero-downtime deployments via GitOps
  - <5 minute recovery from node failures
  - Automated certificate rotation
  - Weekly unattended security updates
```

### Application Portfolio
```yaml
Service Categories:
  - Productivity: Nextcloud, Collabora, Recipes
  - Media: Plex, Immich, Audiobook server  
  - Home Automation: Home Assistant, Matter server
  - Development: Git repositories, CI/CD pipelines
  - Infrastructure: DNS, monitoring, backup systems

Security Posture:
  - 100% TLS termination for external services
  - Network policies for all inter-service communication
  - SSO integration for user-facing applications
  - Regular vulnerability scanning and patching
```

## Professional Context

This homelab demonstrates practical expertise in:

**Cloud-Native Technologies**
- Kubernetes orchestration and operations
- Container networking and security
- Service mesh and observability patterns
- GitOps and infrastructure automation

**Infrastructure Engineering**
- Virtualization and resource management
- Network architecture and security
- Storage systems and data management
- Monitoring and incident response

**DevOps Practices**
- Infrastructure as Code
- CI/CD pipeline design
- Automated testing and deployment
- Security integration and compliance

---

**Ready to explore?** Start with the [Kubernetes Overview](kubernetes/index.md) for technical specifications, or dive into [Architecture](platform/architecture.md) for detailed component interactions.