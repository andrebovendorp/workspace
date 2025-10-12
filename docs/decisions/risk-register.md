# Risk Register

Tracks key architectural risks, impacts, and mitigations.

| ID | Risk | Impact | Likelihood | Mitigation | Residual | Owner | Review |
|----|------|--------|-----------|------------|----------|-------|--------|
| R1 | Single control plane (SQLite) failure | Full cluster outage | Medium | Nightly state DB backup + scripted restore; monitor API health | Medium | Platform | 2025-12 |
| R2 | SQLite scaling ceiling (writes, size) | Performance degradation | Low (current scale) | Track API latency & DB size; threshold triggers HA evaluation | Low | Platform | 2026-03 |
| R3 | Insufficient backups / corruption | Data loss | Low | Hourly snapshots + offsite replication; quarterly restore test | Low | Ops | 2025-12 |
| R4 | Network policy misconfiguration | Lateral movement / outage | Medium | Baseline deny + staged policy rollout + audit logging | Medium | Security | 2025-11 |
| R5 | Secrets exposure via mis-scope | Credential leak | Medium | External Secrets namespace scoping + RBAC review | Low | Security | 2025-11 |
| R6 | Metrics TSDB cardinality explosion | Monitoring blind spots | Low | Label hygiene + monthly cardinality audit | Low | Observability | 2026-01 |
| R7 | Resource saturation (CPU/RAM) | Performance degradation | Medium | NFR triggers + autoscaling evaluation | Medium | Platform | 2026-01 |
| R8 | Operator bus factor (single maintainer) | Sustainability risk | Medium | Documentation depth + automation + knowledge sharing | Medium | Platform | 2026-02 |
| R9 | Security patch lag | Vulnerability exposure | Low | Weekly unattended upgrades + alerts | Low | Security | 2025-12 |
| R10 | Log retention insufficiency | Incident analysis gaps | Low | Align retention with NFR; periodic retention audit | Low | Observability | 2026-01 |

## Notes
- Impact/Likelihood scales: Low / Medium / High (qualitative for now).
- Residual reflects post-mitigation assessment.
- Future enhancement: attach quantitative risk scoring.