# Research & Evaluation Outcomes

Concise record of investigations that informed architectural decisions plus currently active evaluations. Focus is on outcomes, not process.

## Completed Evaluations (Key Outcomes)
| Topic | Question | Decision Influence | Key Outcome | Resulting Decision |
|-------|----------|--------------------|-------------|--------------------|
| K3s vs kubeadm (HA) | Is operational simplicity worth reduced HA? | Platform choice | 60% lower overhead with K3s; HA risk acceptable | Adopt single K3s server |
| GitOps (FluxCD vs ArgoCD) | Which controller suits resource-constrained cluster? | Deployment model | FluxCD ~40% lower footprint | FluxCD selected |
| Observability (Victoria Metrics vs Prometheus) | Can we cut monitoring resource usage? | Metrics stack | ~70% RAM, ~50% storage savings | Victoria Metrics stack |
| Logging (Victoria Logs vs Loki) | Simplify log aggregation footprint? | Logging approach | Lower ingestion overhead | Victoria Logs selected |
| Network (Cilium vs Calico/Flannel) | Consolidate policy + LB + observability? | CNI choice | Unified eBPF features offset complexity | Cilium chosen |
| Storage Tiers | Do workloads justify hybrid tiers? | Persistence model | DB latency gains vs pure NFS | Hybrid local + NFS |
| Secrets Management | Manual vs controller sync | Secret strategy | Reduced drift risk with ESO | External Secrets Operator |

## Active Evaluations
| Topic | Goal | Metric / Success Signal | Status |
|-------|------|-------------------------|--------|
| Victoria Metrics vs long-term scaling | Validate single-node ceiling | Active series & query latency trends | In progress |
| eBPF Network Security Extensions | Expand runtime/network visibility | Coverage % of enforced policies | Planning |
| Runtime Hardening (seccomp/AppArmor) | Reduce container attack surface | Incidents / denied syscalls (baseline) | Pending |

## Backlog / Potential Future Evaluations
| Candidate | Trigger | Exploration Focus | Notes |
|-----------|---------|-------------------|-------|
| HA Control Plane | Control-plane outage > target | Migration path (multi-server / etcd) | Already tracked in decisions |
| Distributed Storage | Capacity / RWX performance gap | Ceph vs Longhorn vs OpenEBS | Complexity vs benefit |
| Tracing Expansion | Increased microservices count | Tempo vs Jaeger vs OTEL only | Resource overhead check |
| Egress Policy Enforcement | Higher data exfil risk | Policy design patterns | After ingress policy maturity |

## Removed / Deferred Topics
| Topic | Reason Deferred | Revisit Condition |
|-------|-----------------|-------------------|
| Full service mesh | Complexity outweighs benefit currently | Increased inter-service auth needs |
| Multi-cluster federation | Single cluster sufficient | Edge deployment requirement emerges |
| Runtime isolation (gVisor/Kata) | Performance cost unjustified | High-risk multi-tenant workloads |

## Method (Brief)
Each evaluation captures: Question → Options → Outcome → Decision / No Decision. Detailed experiment logs kept outside public docs.

Evaluation depth proportional to impact; low-risk choices may have lightweight comparison only.

## Learning Impact (Condensed)
| Area | Capability Improved | Example Artifact |
|------|--------------------|------------------|
| Platform Ops | Faster recovery planning | Control plane restore doc |
| Observability | Efficient metrics taxonomy | Retention policy matrix |
| Security | Policy-driven isolation | Cilium baseline patterns |

Professional growth outcomes are emergent side effects, not a primary doc focus.

## Knowledge Management (Summary)
Outcomes distilled here; raw experiment notes kept privately. Only decisions influencing architecture are promoted to the Decisions Summary.

Continuous learning remains implicit; only architecture-impacting results surface here.