# Platform Overview

This section documents the overall platform architecture, decisions, and cross-cutting concerns for the Kubernetes-based homelab infrastructure.

## Platform Components

The platform consists of integrated systems providing container orchestration, observability, security, and operational capabilities.

### Core Architecture
- **[Architecture](architecture.md)** - High-level platform design and component integration
- **[Decisions](decisions.md)** - Architectural decisions and technical choices with rationale
- **[Non-Functional Requirements](nfr.md)** - Performance targets, constraints, and operational requirements

### Cross-Cutting Concerns
- **[Security](security.md)** - Security architecture, identity management, and compliance
- **[Observability](observability.md)** - Monitoring, logging, and observability strategy

## Design Principles

1. **Security First** - Secure by default with minimal attack surface
2. **Resource Efficiency** - Power and resource conscious operation  
3. **Operational Simplicity** - Easy to understand, maintain, and troubleshoot
4. **Reliability** - Consistent operation with predictable behavior

## Technology Stack

The platform is built on Kubernetes (K3s) with carefully selected components optimized for homelab constraints while maintaining production-grade capabilities.

Key technologies include Cilium for networking, Victoria Metrics for observability, FluxCD for GitOps, and Authentik for identity management.

See the [decisions document](decisions.md) for detailed rationale on technology choices.