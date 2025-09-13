# Kubernetes Cluster

Here lyes the Kubernetes cluster configuration files. The cluster is built using the `k3s` command and the information for the instalation can be found at `ansible/playbook.yaml`.

The decisions made for the cluster can be found in the file `Decisions.md`, the roadmap is possible to be followed within the [Github Project](https://github.com/users/boveloco/projects/2) for this repo.

## Cluster Specifications

For more information about the cluster architecture, please refer to the SVG file at `../architecture.svc`.

| Specification       | Details          |
| ------------------- | ---------------- |
| **Cluster Version** | v1.33.3          |
| **CNI**             | Cilium           |
| **CSI**             | LocalPathStorage/NFS |
| **Master Nodes**    | 1                |
| **Slaves Nodes**    | 2                |
| **Database**        | SQLite           |
| **HA**              | No               |
