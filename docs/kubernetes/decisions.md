# Kubernetes Decisions

This page documents important architectural decisions made for the Kubernetes cluster.

For the complete decision log, see the [DECISIONS.md](../../kubernetes/DECISIONS.md) file in the repository.

## Key Decisions Summary

### Infrastructure Priorities
All servers run in a home environment, which means the following priorities guide all decisions:
- **Security** - Secure by default
- **Noise** - Low noise components
- **Efficiency** - Power and resource efficient
- **Usability** - Simple to operate and maintain

### Application Deployment Strategy
- **Simplified Helm Usage** - Moving away from Helm charts as default for simple configurations
- **Kustomization Preference** - Using FluxCD kustomizations with plain YAML files for simpler configurations
- **Resource Efficiency** - Avoiding unnecessary complexity and resource overhead

### Logging Stack Decision
**Victoria Logs over Loki** (2025-05-01)
- Loki consumes 3x more CPU than Victoria Logs
- Higher memory usage compared to Victoria Logs
- Victoria Logs single instance reduces network overhead
- Better alignment with home lab efficiency priorities

### Database Management
**No Database Visualization Tools in Cluster** (2025-05-21)
- Database visualization done via port-forwarding and local tools
- Reduces resource usage in the cluster
- VPN access for external visualization needs
- Visualization queries documented in repository

### Hardware Changes
**Raspberry Pi Deprecation**
- Removing Raspberry Pi nodes from Kubernetes cluster
- Reallocating Pi resources to other projects
- Planning replacement with more efficient server hardware

## Architecture Principles

1. **Resource Efficiency** - Minimize CPU, memory, and power consumption
2. **Simplicity** - Prefer simple solutions over complex ones
3. **Home Lab Optimized** - Decisions tailored for home environment constraints
4. **Documentation First** - All decisions documented and version controlled