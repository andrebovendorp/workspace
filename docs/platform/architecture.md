# Kubernetes Architecture

Describes the current cluster architecture (what exists) and the key design decisions that shape it. Operational minutiae and full configuration files are intentionally excluded; focus is on structure, rationale, and trade‑offs.

## High-Level Architecture

Single control plane K3s cluster (SQLite datastore) with Cilium providing CNI, network policy, ingress, and load balancing; hybrid storage (local + NFS); GitOps via FluxCD.

![Diagram: Infrastructure Architecture](../resources/images/architecture/infrastructure.drawio.svg)

Key characteristics:
- Lightweight control plane (K3s) prioritizing simplicity over HA
- Unified eBPF networking (Cilium) reducing component sprawl
- Hybrid storage tiers mapped to workload profiles
- GitOps reconciliation model (pull) for drift resistance
- Observability stack (Victoria Metrics / Logs) chosen for efficiency

## Component Overview

| Layer | Component | Role | Key Decision | Trade‑off |
|-------|-----------|------|--------------|-----------|
| Control Plane | K3s single server | API / scheduling / controllers | Single node (simplicity) | Reduced HA, faster recovery path required |
| Datastore | SQLite embedded | Cluster state | Avoid etcd complexity | Scale / HA limits |
| Worker Runtime | containerd | Container execution | Upstream default, minimal overhead | N/A |
| Networking | Cilium (eBPF) | CNI, Ingress, LB, Policy | Consolidate stack | Learning curve, kernel dependency |
| Ingress / LB | Cilium Ingress + LB IPAM | External traffic entry | Avoid separate NGINX/MetalLB | Fewer ingress features |
| Storage | local-path / fast-local / NFS | Persistence tiers | Map tier to workload profiles | No distributed HA storage |
| GitOps | FluxCD | Declarative reconciliation | Pull model, low footprint | Less GUI-centric ops |
| Observability | Victoria Metrics / Logs | Metrics & logs | Resource efficiency | Smaller ecosystem |

### Control Plane Summary
All core control plane processes (API server, scheduler, controller manager) run inside the single K3s server binary. Datastore is a local SQLite file with nightly backup and documented restore steps (script stored outside docs). Scale boundary monitored; migration path to multi-server + external datastore defined as a future decision trigger.

### Worker & Runtime Summary
Workers use containerd + systemd cgroups; defaults retained except tuned pod density (maxPods target ~100). Runtime configuration details are considered implementation and tracked in repository manifests, not here.

## Networking

### Cilium Architecture
eBPF data path handles service load balancing, network policy enforcement, and ingress without kube-proxy. This reduces context switches and component count.

### Network Policy Strategy
Baseline approach: *deny-by-default* in sensitive namespaces (databases, identity) and progressively expand coverage. Representative policy pattern (not exhaustive): allow only specific app → database traffic + DNS egress. Full manifests reside in GitOps repo.

## Storage

Three tiers map to different workload characteristics:

| Tier | Backing | Access | Primary Use | Notes |
|------|---------|--------|-------------|-------|
| local-path | Node SSD | RWO | Databases, stateful hot data | Fast, node affinity needed |
| fast-local | Selected high-perf SSD | RWO | Latency sensitive DB / cache | Limited capacity |
| nfs-client | NFS share | RWO/RWX (shared config) | Media, shared configs, lower IOPS | Network latency trade‑off |

Backups leverage ZFS snapshots + offsite replication (see resilience docs).

## Security (Overview)
See consolidated details in `security.md`.

Highlights:
- Authentik SSO + RBAC per namespace
- Network policies enforced by Cilium (progressive coverage)
- External Secrets Operator manages secret synchronization
- cert-manager automates external TLS

In-cluster service mesh / mTLS deferred (documented trade‑off).

### RBAC Pattern
Namespace admin role (scoped) + application-specific ServiceAccounts with minimal secret/config access. Full manifests are maintained under GitOps, omitted here for clarity.

## Observability (Overview)
Metrics + logs centralized via Victoria stack (see monitoring pages). Tracing limited to selective critical paths. Cilium provides network flow visibility. Detailed flow diagrams are maintained externally.

## Performance Envelope (Indicative)
Current baseline resource usage remains within NFR targets. Scaling considerations tracked via NFR triggers (see `../platform/nfr.md`).

## Resilience & Recovery (Summary)
Single control plane implies deliberate acceptance of higher control-plane outage risk. Mitigations: nightly datastore backup, documented restore workflow (outside docs), pod anti-affinity for critical replicated workloads, and network policy isolation limiting blast radius.

Potential future enhancements: multi-server control plane, distributed storage layer introduction.

This architecture emphasizes operational simplicity, resource efficiency, and incremental hardening. Detailed implementation manifests are managed through GitOps and intentionally excluded here.

Related pages:
- [K3s Implementation](../kubernetes/k3s.md)
- [Networking](../kubernetes/networking.md)
- [Storage](../kubernetes/storage.md)
- [Load Balancing](../kubernetes/load-balancing.md)
- [Security Architecture](security.md)