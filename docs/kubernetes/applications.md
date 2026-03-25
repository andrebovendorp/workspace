# Kubernetes Applications

This document provides an overview of applications deployed in the Kubernetes homelab environment.

## Application Categories

### Productivity & Collaboration
- **Nextcloud** - Personal cloud storage and collaboration platform
- **Collabora** - Online office suite integrated with Nextcloud
- **Recipes** - Recipe management and meal planning application

### Media & Entertainment
- **Plex** - Media server for movies, TV shows, and music
- **Immich** - Self-hosted photo and video management
- **Audiobook Server** - Audiobook streaming and management

### Home Automation
- **Home Assistant** - Home automation and IoT device management
- **Matter Server** - Matter protocol bridge for IoT devices

### Development & DevOps
- **FluxCD** - GitOps continuous deployment
- **External Secrets** - Kubernetes secret management
- **Cert Manager** - Automated TLS certificate management

### Infrastructure Services
- **AdGuard Sync** - DNS filtering and blocking
- **External DNS** - Automated DNS record management
- **Victoria Metrics** - Metrics collection and monitoring
- **Authentik** - Single sign-on and identity provider

### Data & Storage
- **MariaDB** - Relational database for applications
- **PostgreSQL** - Advanced relational database
- **MongoDB** - NoSQL document database
- **Redis** - In-memory data structure store

### Backup & Recovery
- **Duplicati** - Backup and restore solution
- **MongoDB Backup** - Automated MongoDB backup
- **PostgreSQL Backup** - Automated PostgreSQL backup

## Deployment Architecture

All applications are deployed using GitOps principles with FluxCD, following these patterns:

- **Namespace Isolation** - Each application in its own namespace
- **Resource Management** - CPU and memory limits defined
- **Storage Classes** - Appropriate storage tier selection
- **Network Policies** - Microsegmentation with Cilium
- **Ingress Configuration** - TLS termination and routing
- **Monitoring Integration** - Metrics and alerting enabled

## Service Discovery

Applications are accessible through:
- **Internal DNS** - `.cluster.local` for inter-service communication
- **External Ingress** - Public domain routing through Cilium Ingress
- **Load Balancer** - Direct IP access for specific services

## Resource Allocation

The cluster efficiently manages ~25 applications across the available resources:
- **Total Workloads**: ~100 pods
- **Resource Usage**: 75%+ memory utilization, 90%+ CPU efficiency
- **Storage Consumption**: Hybrid local and network storage utilization

For detailed configuration and deployment manifests, refer to the `kubernetes/manifests/` directory in the repository.