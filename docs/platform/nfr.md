# Non-Functional Requirements (NFRs)

Defines target qualities and constraints shaping architectural decisions.

## Summary Table

| Category | Target / Constraint | Rationale | Measurement / SLO | Current State |
|----------|---------------------|-----------|-------------------|---------------|
| Power Consumption | <150W cluster total (idle+baseline) | Residential energy + heat constraints | Monthly average wattage | ~140W baseline (est.) |
| Availability (Core Services) | 99.5% (single control plane) | Accepts brief maintenance windows | Uptime of critical namespaces | Within target |
| Recovery Time Objective (RTO) | Control Plane: 30 min, App Data: 4h | Balance complexity vs risk | Time from incident start to restore | Not yet formally timed |
| Recovery Point Objective (RPO) | ≤1h for critical data | Frequent snapshots + replication | Data loss window | Hourly snapshots configured |
| Security Posture | 100% TLS external; RBAC least-privilege | Protect user data & identity | Periodic access review | TLS enforced |
| Performance (Latency intra-node) | <1ms pod→pod median | User experience & DB perf | Synthetic network tests | Achieved |
| Performance (Cross-node latency) | <5ms p95 | Service chaining responsiveness | Network benchmark | Achieved |
| Storage Efficiency | >50% compression (hot datasets) | Optimize cost & space | ZFS metrics | ~55% |
| Observability Coverage | Metrics + logs 100% workloads | Troubleshooting speed | Coverage audit | ~95% (traces partial) |
| Noise / Acoustic | Silent (no audible fans at 1m) | Residential comfort | Periodic manual check | Met |
| Operational Overhead | <5h / week maintenance | Sustainability (single operator) | Time tracking | Approx. 3h |
| Cost (CapEx growth) | No major hardware until scale trigger | Avoid premature scaling | Decision review triggers | Stable |

## Constraints

| Constraint | Description | Impact on Design |
|-----------|-------------|------------------|
| Single Operator | Limited human time | Preference for simplicity over maximum HA |
| Limited Physical Space | Rack/desk space capped | Consolidated nodes, no large SAN |
| Power Budget Ceiling | 150W target envelope | High-efficiency components, K3s choice |
| Budget Awareness | Avoid enterprise licensing | Open-source, lightweight stack |
| Home Network Topology | Single switching layer | Simpler VLAN segmentation model |

## Quality Attribute Priorities

1. Operational Simplicity
2. Resource Efficiency
3. Security Baseline
4. Reliability (bounded by simplicity)
5. Observability Depth

Trade-off: Chosen simplicity reduces raw HA level (single control plane) but improves maintainability and adoption speed.

## Triggers for Reassessment

| Metric / Signal | Threshold | Reassessment Action |
|-----------------|-----------|---------------------|
| Control plane outages | >1 incident / 12 months | Evaluate HA control plane migration |
| Metrics active series | >800k | Assess Victoria Metrics scaling or alternative |
| Storage utilization | >75% sustained | Expand capacity or add distributed layer |
| Node CPU saturation | >70% avg over 2 weeks | Add worker or optimize workloads |
| Secrets sync latency | >30s p95 | Tune ESO or alternative secrets path |

## Verification Cadence

| Review Item | Frequency | Owner |
|-------------|-----------|-------|
| NFR Audit | Quarterly | Platform |
| Power Profile | Monthly | Infra |
| Backup Restore Test | Quarterly | Ops |
| Security Access Review | Quarterly | Security |
| Observability Coverage | Semi-Annual | Ops |

Status: Initial baseline established; next holistic review scheduled 2026-Q1.