# Kubernetes Applications

Overview of applications deployed on the Kubernetes cluster.

## Core Infrastructure

### Flux System
GitOps controller for managing cluster state.

### Cert-manager  
Automatic SSL/TLS certificate management.

### External DNS
Automated DNS record management.

## Applications

### Media & Entertainment
- **Plex** - Media server for movies, TV shows, and music
- **Immich** - Self-hosted photo and video management
- **Audiobook** - Audiobook streaming service

### Productivity  
- **Nextcloud** - File sharing and collaboration platform
- **Collabora** - Online office suite
- **Recipes** - Recipe management

### Home Automation
- **Home Assistant** - Home automation platform
- **Matter Server** - Matter/Thread support

### Development & Monitoring
- **Victoria Metrics** - Monitoring and alerting
- **OpenTelemetry** - Observability stack
- **Glance** - Dashboard and status page

### Utilities
- **AdGuard Sync** - DNS filtering sync
- **Duplicati** - Backup solution
- **QBittorrent** - BitTorrent client

## Security & Authentication

### Authentik
Identity provider and SSO solution.

### External Secrets
Kubernetes operator for managing secrets from external systems.

### 1Password Server
Self-hosted password management (if applicable).

## Databases

### PostgreSQL
Primary database for applications.

### MongoDB  
Document database for specific applications.

### Redis
In-memory data structure store.