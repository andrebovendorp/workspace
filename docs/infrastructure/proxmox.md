# Proxmox Virtualization Platform

Decision-focused summary of the virtualization layer supporting the Kubernetes cluster. Detailed operational procedures and raw config are intentionally omitted.

## Overview
| Aspect | Current Choice | Rationale | Trade-off |
|--------|----------------|-----------|----------|
| Version | Proxmox VE 8.x | Modern kernel + stable features | Upgrade coordination |
| Topology | Single-node (no Proxmox cluster) | Simplicity, reduced quorum overhead | No hypervisor HA |
| Storage Backend | ZFS (NVMe + SSD pools) | Integrity, compression, snapshots | Management complexity |
| Networking | Linux bridges w/ VLAN awareness | Flexible multi-network mapping | Manual VLAN hygiene |
| Provisioning | Cloud-init + Ansible | Repeatable node builds | Slight upfront automation effort |
| Backup | ZFS snapshots + offsite replication | Fast rollback + integrity | Requires ZFS skill |

## Hardware & Resource Model
| Resource | Approach | Notes |
|----------|---------|-------|
| CPU | Pass-through host CPU type (host) | Max performance for workloads |
| Memory | Conservative overcommit (~1.5:1) | Maintain stability; KSM assists |
| NUMA | Awareness considered for larger VMs | Current scale modest |
| Root FS | ZFS on NVMe mirror | Fast metadata + integrity |
| VM Datasets | ZFS datasets w/ lz4 compression | Space savings (~50% on text/log) |
| Backup Target | Network storage (NFS/ZFS send) | Offsite replication supported |
| Snapshots | Automated scheduled | Basis for rapid rollback |

## Network Virtualization
| Bridge | Purpose | VLAN Mode | Key Traffic |
|--------|---------|-----------|-------------|
| vmbr0 | Management / infra services | VLAN aware | Proxmox mgmt, auth, DNS |
| vmbr1 | Kubernetes cluster data | VLAN aware | Pod / service east‑west |
| vmbr2 | Storage traffic | VLAN aware | NFS, backup replication |

Bonding: Physical NIC redundancy (where hardware permits) reduces single-link failure risk.

## VM Profile (Kubernetes Nodes)
| Attribute | Standard Value | Rationale |
|-----------|----------------|-----------|
| OS | Ubuntu 22.04 LTS (cloud-init) | Stable LTS + ecosystem maturity |
| vCPU | 4 cores | Balance density vs per-node resilience |
| Memory | 8GB | Supports workloads + system overhead |
| Root Disk | 40GB | Sufficient for OS + logs rotation window |
| IO Bus | VirtIO SCSI | Performance & paravirtual efficiency |
| Ballooning | Enabled | Memory efficiency under idle load |

Provisioning Flow (summary): Template → Cloud-init customization → Ansible role (k3s join) → Metrics onboarding.

### Resource Allocation Strategy
Goal: Maintain headroom for burst while avoiding fragmentation.
| Aspect | Strategy | Comment |
|--------|----------|---------|
| Memory Overcommit | ~1.5:1 | Protects from swap thrash |
| CPU Scheduling | Fair-share, no pinning (current) | Simpler; revisit if latency SLO threatened |
| I/O Prioritization | Critical workloads favored via ZFS dataset tuning | Minimal manual tuning so far |
| Capacity Planning | NFR triggers based on sustained >70% utilization | Drives scale/upgrade decision |

## Resilience & Backup
| Mechanism | Purpose | Frequency | Notes |
|-----------|---------|-----------|-------|
| ZFS Snapshots | Point-in-time rollback | Daily (plus ad-hoc pre-change) | Fast local recovery |
| Offsite Replication | Disaster recovery | Daily incremental | Protects against local loss |
| Config Export | Rebuild hypervisor state | Weekly | Scripted task |
| Restore Test | Validate recoverability | Quarterly | Logged results |

## Operational Observability
Lightweight approach: native Proxmox metrics exported (via node exporter integration) and central log aggregation at host level. Update cadence weekly (security) / quarterly (feature).

## Security Snapshot
| Area | Control | Notes |
|------|---------|-------|
| Auth | PAM users + optional 2FA | Central SSO not integrated (scoped locally) |
| Access Roles | Least privilege for automation user | No wide admin sharing |
| Network | Segmented bridges + firewall | Management isolated from workload VLANs |
| Patching | Weekly unattended upgrades | Manual review for major changes |
| Audit | Access logs retained centrally | Future: integrate deeper audit export |

## Integration with Kubernetes
Provisioning + join sequence automated— ensures consistent kernel modules, time sync, and resource labeling. Metrics surface through node + kube exporters; storage + network health captured at host and cluster layers.

## Lifecycle & Maintenance
| Cadence | Activity |
|---------|----------|
| Weekly | Security updates, snapshot validity check |
| Monthly | Capacity review, cleanup old snapshots |
| Quarterly | Restore drill, hardware health audit |
| Annual | Version upgrade planning |

This platform balances integrity (ZFS) and operational simplicity, accepting single-node hypervisor risk mitigated by snapshots + offsite replication.