# Kubernetes Cluster

Here lyes the Kubernetes cluster configuration files. The cluster is built using the `k3s` command and the information for the instalation can be found at `ansible/playbook.yaml`.

The roadmap and decisions made for the cluster can be found in the files `Decisions.md` and `Roadmap.md`.

## Cluster Specifications

For more information about the cluster architecture, please refer to the SVG file at `../architecture.svc`.

| Specification       | Details          |
| ------------------- | ---------------- |
| **Cluster Version** | v1.32.2          |
| **CNI**             | Cilium           |
| **CSI**             | LocalPathStorage |
| **Master Nodes**    | 1                |
| **Slaves Nodes**    | 3                |
| **Database**        | SQLite           |
| **HA**              | No               |
