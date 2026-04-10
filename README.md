# 🏠 Homelab Infrastructure Monorepo

A comprehensive infrastructure-as-code repository showcasing modern DevOps practices, Kubernetes orchestration, and self-hosted applications in a production-ready homelab environment.

## 🌟 Overview

This monorepo contains the complete infrastructure definition for a modern homelab setup, serving as both a functional production environment and a learning laboratory for exploring cutting-edge automation and Kubernetes technologies.

**Key Highlights:**
- **🔧 Infrastructure as Code** - Complete automation using Ansible, Terraform, and GitOps
- **☸️ Kubernetes at Scale** - Production-ready K8s cluster with 25+ applications
- **🚀 GitOps Workflow** - Flux-based continuous deployment
- **📊 Observability Stack** - Comprehensive monitoring with Victoria Metrics
- **🔒 Security First** - Authentik SSO, certificate automation, secrets management
- **🏡 Home Automation** - Home Assistant integration with Matter/Thread support

## 📚 Documentation

Comprehensive documentation is available at **[boveloco.github.io/workspace](https://boveloco.github.io/workspace)**

- **Architecture** - System design and component overview
- **Kubernetes** - Cluster setup, applications, and operational decisions  
- **Proxmox** - Virtualization platform configuration
- **Studies & Workshops** - Learning materials and hands-on guides

## 🏗️ Architecture

### Infrastructure Layer
- **Proxmox VE** - Virtualization platform
- **Ubuntu VMs** - Kubernetes nodes
- **Network Segmentation** - VLANs and firewall rules
- **Storage** - Local and NFS-based persistent storage

### Platform Layer
- **Kubernetes 1.33+** - Container orchestration
- **Flux CD** - GitOps continuous deployment
- **Cert-Manager** - Automatic SSL/TLS certificates
- **External Secrets** - Secure secrets management
- **Victoria Metrics** - Monitoring and observability

### Application Layer
```
🏠 Home & Productivity      🔧 Development & Ops    🔐 Security & Infrastructure
├── Home Assistant          ├── GitOps (Flux)        ├── Authentik SSO            
├── Nextcloud               ├── Container Registry   ├── AdGuard DNS Filtering
├── Collabora Office        ├── CI/CD Pipelines      ├── External DNS
└── Recipe Management       └── Monitoring Stack     └── Backup Solutions

🗄️ Data & Databases
├── PostgreSQL Cluster
├── MongoDB
├── Redis
└── Automated Backups
```

## 📊 Key Metrics & Features

- **25+ Applications** deployed and managed via GitOps
- **99.9% Uptime** through HA configuration and monitoring
- **Automated Backups** for all critical data
- **Zero-Touch Deployments** via Flux CD
- **Comprehensive Monitoring** with custom dashboards
- **Security Hardening** with regular vulnerability scanning

## 🔍 Use Cases & Learning

This repository demonstrates practical implementations of:

- **Enterprise Kubernetes Patterns** - Multi-tenancy, security, observability
- **Infrastructure Automation** - Ansible, Terraform, GitOps workflows  
- **Site Reliability Engineering** - Monitoring, alerting, incident response
- **DevOps Best Practices** - CI/CD, testing, deployment strategies
- **Cloud-Native Technologies** - Service mesh, observability, security

## 🛠️ Technologies Used

**Infrastructure:** Proxmox, Ubuntu, Ansible, Terraform  
**Container Platform:** Kubernetes, Docker, Helm, Kustomize  
**GitOps & CI/CD:** Flux CD, GitHub Actions, ArgoCD  
**Monitoring:** Victoria Metrics, Grafana, OpenTelemetry  
**Security:** Authentik, Cert-Manager, External Secrets  
**Applications:** 25+ self-hosted applications (see documentation)

## 📈 Project Status

- ✅ **Production Ready** - Actively running critical home services
- 🔄 **Continuously Evolving** - Regular updates and new feature additions
- 📖 **Well Documented** - Comprehensive guides and decision records
- 🧪 **Testing Ground** - Experimental features and proof-of-concepts

## 💼 Professional Services

This repository showcases real-world expertise in:
- Cloud-native infrastructure design and implementation
- Kubernetes cluster architecture and operations
- DevOps automation and GitOps workflows
- Infrastructure as Code best practices
- Monitoring and observability solutions

For professional consulting, training, or implementation services, please reach out:

**Contact Information:**
- 💼 LinkedIn: [Andre Bovendorp](https://linkedin.com/in/andrebovendorp)
- 🐙 GitHub: [@andrebovendorp](andrebovendorp)

---

## 📄 License

This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

Built with open-source technologies and inspired by the vibrant Kubernetes and homelab communities.

