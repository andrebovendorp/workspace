# Security Architecture

Consolidated view of identity, access, network, secrets, and runtime security design.

## Objectives
Provide baseline protection (confidentiality, integrity, availability) with minimal operational overhead suitable for a single-operator homelab while reflecting production-minded patterns.

## Layers Overview

| Layer | Primary Controls | Tools / Mechanisms | Key Decisions |
|-------|------------------|--------------------|---------------|
| Identity & Auth | Central auth, SSO, MFA capable | Authentik | Lightweight vs heavier Keycloak; chosen for simplicity |
| Access (RBAC) | Least-privilege namespace & role scoping | Kubernetes RBAC, ServiceAccounts | Namespace admin cluster role pattern |
| Network Segmentation | Policy-driven isolation | Cilium Network Policies (deny-by-default model) | Unified CNI + policy engine |
| Secrets Management | External source sync, minimal plaintext | External Secrets Operator + secret store (future) | Avoid manual secret drift |
| Certificates | Automated lifecycle | cert-manager (ACME) | Reduce manual renewal risk |
| Runtime Controls | Container isolation & security baseline | containerd + default seccomp/AppArmor (future hardening) | Favor simplicity initially |
| Data Encryption | In-transit TLS, at-rest selective | TLS ingress termination; ZFS checksums & optional encryption | Encryption where value-add |
| Audit & Logging | Trace security-relevant events | API server audit (planned), Victoria Logs | Expand coverage incrementally |

## Identity & Access
- Authentik provides SSO for user-facing applications and future MFA enablement.
- Kubernetes access uses certificate-based kubeconfig + RBAC scoped to least privilege.
- ServiceAccounts per application; no shared SA across namespaces.

Future Considerations: Add short-lived credentials issuance and audit dashboard.

## Network Security
- Cilium enforces Layer 3–7 policies; baseline deny pattern for sensitive namespaces (databases, identity, secrets sync).
- Load balancing & ingress consolidated in Cilium reduces separate NGINX/MetalLB components (smaller attack surface).
- DNS flows: CoreDNS internal, AdGuard external filtering.

Future Considerations: Expand policy coverage to 100% namespaces; implement egress controls for supply-chain protection.

## Secrets & Certificates
- External Secrets Operator sync model: source-of-truth outside cluster (future integration with vault/password store).
- All external ingress endpoints terminate TLS (ACME), internal mTLS not yet required (trade-off simplicity vs complexity).

Future Considerations: Evaluate secret rotation automation & in-cluster encryption provider if threat model tightens.

## Runtime & Node Hardening
Current Baseline:
- containerd default runtime (runc), systemd cgroup driver.
- Unprivileged containers default; privileged usage restricted.
- Weekly unattended OS security updates.

Planned Enhancements:
- Seccomp & AppArmor profile tightening.
- Image provenance checks (signing / verification pipeline).
- eBPF-based runtime anomaly detection (Cilium Tetragon evaluation).

## Logging & Audit
- Centralized log aggregation (Victoria Logs) – platform & application logs.
- Security-relevant events targeted for structured logging (auth failures, policy denials).
- API server audit policy: planned (not yet implemented) to increase traceability.

## Risk & Trade-offs
| Area | Trade-off | Rationale | Mitigation Path |
|------|-----------|-----------|-----------------|
| Single control plane | Lower HA | Operational simplicity | Backups + potential future HA migration |
| No full mTLS mesh | Reduced in-cluster encryption | Complexity avoidance | Reevaluate if threat model expands |
| Limited egress controls | Potential outbound data exfiltration | Prioritized ingress & segmentation first | Phase egress policies post coverage |
| Basic runtime hardening | Higher runtime exploit surface | Resource & time constraints | Gradual profile tightening |

## Security Roadmap (High-Level)
| Quarter | Focus | Outcome Target |
|---------|-------|---------------|
| 2025-Q4 | RBAC & namespace audit | Documented least-privilege baseline |
| 2026-Q1 | API audit logging + policy coverage expansion | 90% namespace policy coverage |
| 2026-Q2 | Runtime hardening (seccomp/AppArmor) | Hardened baseline profiles |
| 2026-Q3 | Egress policy rollout + secret rotation automation | Reduced data exfil risk |

Status: Baseline controls in place; incremental hardening planned aligned with operator capacity.