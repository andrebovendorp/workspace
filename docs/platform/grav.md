# Grav Deployment

This page documents how Grav is deployed in this environment using FluxCD, Cilium Gateway API, NFS CSI, and External Secrets.

## Deployment Model

- Runtime: Kubernetes (k3s)
- Delivery: FluxCD `Kustomization`
- Ingress: `HTTPRoute` via Cilium Gateway
- Persistence: NFS CSI-backed `PersistentVolume` and `PersistentVolumeClaim`
- Secrets: External Secrets + 1Password ClusterSecretStore

> Grav is deployed in **flat-file mode** (no SQL database required).

## Files

Grav manifests live under:

- `kubernetes/manifests/grav`
- `kubernetes/manifests/_gitops/grav.yaml`

Configured hostname:

- `blog.nullservers.com`

## Required Inputs Before First Production Deploy

Update these values before rollout:

1. NFS server and NFS share path in `pv.yaml`
2. Timezone (`TZ`) in `deployment.yaml`
3. Container image tag in `kustomization.yaml` when upgrading versions

## Deployment Steps

1. Commit and push the new manifests.
2. Ensure DNS for `blog.nullservers.com` resolves to your gateway edge.
3. Verify Flux applies `kubernetes/manifests/_gitops/grav.yaml`.
4. Confirm resources are healthy:
   - Namespace, PV, PVC, Deployment, Service, HTTPRoute, CiliumNetworkPolicy
5. Access the configured Grav hostname and complete the CMS setup wizard.

## Operational Notes

- Grav content and configuration are persisted at `/config` inside the container.
- `persistentVolumeReclaimPolicy: Retain` is used to protect data during resource recreation.
- Network policy allows ingress from both `cloudflare` and `cilium-gateway-system` namespaces, and limits egress to DNS plus common Grav update endpoints.
- Image is pinned to `linuxserver/grav:2.0.19`.

## If You Want Database-Backed Mode Later

Default Grav does not need a database. If you choose a plugin/theme architecture that requires SQL in the future, follow your platform decision and host DB on Proxmox, then add:

- `ExternalSecret` for DB credentials
- DB env vars in `deployment.yaml`
- Cilium egress rule for DB host/port

At that point, provide these inputs:

1. DB engine (`postgres` or `mysql`)
2. DB hostname and port
3. Database name
4. 1Password item/key names for username/password
5. TLS requirement for DB connection
