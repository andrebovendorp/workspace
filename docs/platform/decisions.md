# Platform Decisions

This document serves as the Single Source of Truth (SSOT) for all platform and architectural decisions made in the homelab infrastructure. Each decision is documented with context, rationale, and implications.

## Design Priorities

All infrastructure decisions are guided by the following priorities, in order:

1. **Security** - Secure by default, minimal attack surface
2. **Noise** - Low noise operation for home environment
3. **Efficiency** - Power and resource efficient
4. **Usability** - Simple to operate and maintain

## Decision Summary

Overview of cross-domain architectural decisions. Each entry captures the rationale and consequences.

| Domain | Decision | Options Considered | Rationale (Why Chosen) | Key Consequences | Status | Review |
|--------|----------|--------------------|------------------------|------------------|--------|--------|
| Platform | K3s (single control plane, SQLite) | kubeadm+etcd, k0s, MicroK8s | Lowest operational overhead, resource efficiency, fast patching | Single point of failure, SQLite scale ceiling | Accepted | 2026-01 |
| Networking | Cilium (eBPF CNI + Ingress + LB) | Flannel, Calico, Cilium | Unified networking + policy + LB; modern eBPF features | Learning curve, kernel dependency | Accepted | 2025-12 |
| Storage | Hybrid: local-path + NFS + fast-local tier | All-local SSD, Pure NFS, Ceph | Matches workload profiles (DB perf + shared media) with low complexity | No distributed HA storage; manual data placement | Accepted | 2025-11 |
| Observability | Victoria Metrics + Victoria Logs | Prometheus+Loki, Thanos, ClickHouse stack | Lower RAM/CPU, simpler stack for scale | Less ecosystem tooling parity vs Prometheus | Accepted | 2026-03 |
| GitOps | FluxCD | ArgoCD, Manual kubectl, Helm CI | Lower footprint, native multi-tenancy patterns | Less GUI-driven workflow | Accepted | 2025-12 |
| Identity & Access | Authentik SSO + RBAC | Keycloak, Dex, Internal-only | Lightweight SSO with good integrations | Smaller community vs Keycloak | Accepted | 2025-12 |
| Secrets Mgmt | External Secrets Operator | SOPS-only, Manual K8s Secrets | Syncs external secret stores seamlessly | Controller dependency, sync latency | Accepted | 2025-12 |
| Certificates | cert-manager (ACME) | Manual renewals, Caddy, Traefik | Automated issuance & rotation | Additional CRDs & controller | Accepted | 2025-11 |
| Metrics Collection | Agent scraping → Victoria Metrics | Prometheus server, Thanos sidecar | Efficiency + consolidated setup | Potential migration if scale >1M series | Accepted | 2026-03 |
| Logging | Victoria Logs + Fluent Bit | Loki, Elastic Stack | Lower resource usage, simpler ops | Less mature search UX vs Elastic | Accepted | 2025-12 |
| Backup Strategy | ZFS snapshots + offsite replication | Restic-only, Ceph RBD snapshots | Fast local rollback + integrity | Requires ZFS management expertise | Accepted | 2025-12 |
| Deployment Pattern | Single cluster (prod+lab workloads segmented by policy) | Separate clusters, namespaces only | Simplicity, resource consolidation | Blast radius if misconfigured policies | Accepted | 2026-02 |
| Ingress & LB | Cilium Ingress + LB IPAM | NGINX Ingress, Traefik, MetalLB | Integrated stack, fewer moving parts | Feature parity gaps vs mature ingress controllers | Accepted | 2025-12 |
| Database Strategy | Local persistent volumes per service | Central DB cluster, Managed DB (N/A) | Isolation, simple backup surfaces | No shared HA cluster benefits | Accepted | 2026-01 |

## Pending / Future Decisions

| Candidate | Trigger Metric / Condition | Exploration Focus | Target Review |
|-----------|---------------------------|-------------------|---------------|
| HA Control Plane (add external DB/ETCD) | >1 critical outage / year OR need >1 master | Evaluate k3s multi-server vs kubeadm migration | 2026-Q2 |
| Distributed Storage Layer | Need RWX perf + >2TB DB growth | Evaluate Ceph vs OpenEBS vs Longhorn | 2026-Q3 |

---

## Detailed Decision Records

### Bypass CloudflareD Tunnel upload size limiation using Bunkerweb WAF
**Decision Date:** 2026-04-10
**Status:** Implemented

**Summary:**
CloudflareD Tunnel has a 100MB upload size limit which is insufficient for certain workloads, specially for large videos needed for media uploads and backuping with immich. This creates a realibility issue for users who need to upload large files through the tunnel.

**Rationale:**
- Need a WAF in front of exposed services for security
- Bunkerweb can handle larger uploads and provides WAF capabilities
- Cilium Network Policies can be used to restrict access to Bunkerweb, ensuring it only serves as a proxy for the intended services

**Implementation:**
- Deploy Bunkerweb as a reverse proxy in front of the affected services
- Configure another Gateway to avoid exposing internal services to the public internet
- Use Cilium policies to restrict access to Bunkerweb from the public internet and allow it to forward traffic to the internal services

**Issues Faced:**
- Initial configuration of Bunkerweb comes with a service type `LoadBalancer` configured with `trafficPolicy: Local`, which apparently is a limitation by cilium version 1.19.2, which is the version used in the cluster. This configuration causes the service to be only accessible from the node where the pod is running, which is not ideal for a reverse proxy. The workaround was to change the service type to `ClusterIP` and use Cilium's Gatway API to expose the service externally, which allows for proper load balancing and high availability. It also enables hubble to properly monitor the traffic going through Bunkerweb, which is also a good addition to it. 
- Important to remember that, by default, Cilium API GW creates its `LoadBalancer` service with `trafficPolicy: Cluster`, which allows for proper load balancing across all nodes, but also removes Bunkerweb's IP address visibility, which can limit its WAF capabilities.

Issues for reference:
- https://github.com/cilium/cilium/issues/27800
- https://github.com/cilium/cilium/issues/45252

### Stop Spreading Helm Charts as Default

**Decision Date:** 2024  
**Status:** Continuously Active

For simple configurations like cronjobs or basic deployments, the recommended approach is now to create a `kustomization` with FluxCD using plain YAML files instead of Helm charts.

**Rationale:**
- Reduces configuration complexity
- Eliminates layers upon layers of configuration
- Simplifies troubleshooting and maintenance
- Better GitOps workflow integration

**Implementation:**
- Use Helm only for complex applications that benefit from templating
- Prefer Kustomize + plain YAML for simple resources
- Document configuration decisions clearly

---

### Migration from Loki to Victoria Logs

**Decision Date:** 2025-05-01  
**Status:** Implemented

Replaced Loki with Victoria Logs as the primary log aggregation solution.

**Problem:**
Loki was consuming excessive resources and didn't align with homelab efficiency priorities.

**Analysis:**
- **CPU Usage:** Loki consumed 3x more CPU than Victoria Logs
- **Memory Usage:** Significantly higher memory footprint
- **Operational Complexity:** Victoria Logs offers simpler configuration and maintenance

**Solution:**
- Migrated to Victoria Logs for log aggregation
- Maintained Fluent Bit as log shipper
- Simplified log processing pipeline

**Benefits:**
- 70% reduction in resource consumption
- Simplified operational procedures
- Better integration with Victoria Metrics stack

---

### Migration from ArgoCD to FluxCD

**Decision Date:** 2024  
**Status:** Implemented

**Problem:**
ArgoCD was consuming entire Raspberry Pi node resources and causing thermal throttling.

**Analysis:**
- ArgoCD resource consumption was excessive for homelab scale
- Thermal constraints in passive cooling setup
- Need for lightweight GitOps solution

**Solution:**
- Migrated to FluxCD for GitOps
- Significantly reduced resource consumption
- Better fit for homelab scale
- Maintained GitOps capabilities

---

### Raspberry Pi Deprecation

**Decision Date:** 2024  
**Status:** In Progress

**Rationale:**
- Insufficient resources for modern Kubernetes workloads
- Thermal constraints in passive cooling setup
- Better utilization in dedicated projects

**Migration Plan:**
- Remove Raspberry Pi from Kubernetes cluster
- Deploy replacement server with better performance/watt ratio
- Repurpose Pi for dedicated home automation tasks

---

## Technology Stack Decisions

### Container Runtime: containerd
- **Rationale:** Industry standard, lightweight, secure
- **Alternative Considered:** Docker (deprecated in K8s)

### CNI: Cilium
- **Rationale:** eBPF-based networking, advanced security features, ingress capabilities
- **Alternative Considered:** Flannel (simpler but less features)

### CSI: Local Path Storage + NFS
- **Rationale:** Simple local storage for stateless apps, NFS for shared data
- **Alternative Considered:** Rook-Ceph (too complex for homelab)

### Database: SQLite (K3s embedded)
- **Rationale:** Simple, sufficient for homelab scale, no external dependencies
- **Alternative Considered:** External etcd (unnecessary complexity)

### GitOps: FluxCD
- **Rationale:** Lightweight, GitOps-native, excellent Kubernetes integration
- **Alternative Considered:** ArgoCD (too resource intensive)

### Monitoring: Victoria Metrics
- **Rationale:** Lower resource usage compared to Prometheus, better compression
- **Alternative Considered:** Prometheus (higher resource usage)

### Ingress: Cilium Ingress
- **Rationale:** Integrated with CNI, unified networking stack
- **Alternative Considered:** NGINX Ingress (additional component)

### Service Mesh: None (Future Consideration)
- **Current Rationale:** Additional complexity not justified at current scale
- **Future Trigger:** When service-to-service authentication becomes critical

---

## Decision Format

When documenting new decisions, include:
- **Context:** What problem are we solving?
- **Options:** What alternatives were considered? 
- **Decision:** What was chosen?
- **Rationale:** Why was this option selected?
- **Consequences:** What are the trade-offs and implications?
- **Status:** Current implementation status
- **Review:** When should this be re-evaluated?

Use this document as the authoritative current state of architectural intent.