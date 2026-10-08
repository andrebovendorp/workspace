# Glance

Home remains the default page, with Tautulli media tabs in the main column and
compact Epic free games in the left sidebar. Service monitors are on
Infrastructure, not Home. News is unchanged; the separate Media page is removed.

## Configuration Layout

- `glance.yaml`: existing Home/News config and new page includes.
- `config/infrastructure.yml`: Infrastructure page layout.
- `config/infrastructure-platform.yml`: platform HTTP checks and admin links.
- `config/infrastructure-apps.yml`: application HTTP checks and links.
- `config/infrastructure-components.yml`: reference links for cluster controllers,
  scheduled jobs, database services, and Proxmox services without HTTP dashboards.
  These links are not live Kubernetes health checks.
- `config/widgets/`: one file per requested community integration.
- `widget-secrets.yaml`: Infisical-backed ExternalSecret.
- `secrets.md`: required values, sources, and endpoint compatibility notes.

Kustomize generates `glance-pages` with a content hash and updates the Deployment
reference when any included file changes. A projected volume combines the original
ConfigMap and the generated files. The Deployment mounts each file read-only at
`/app/config/<filename>` using `subPath`, preserving the per-file mount layout.
Glance expands `$include` directives relative to the main config file. The flat
ConfigMap filenames are explicitly mapped in `kustomization.yaml`.

Every generated filename needs a matching Deployment `volumeMounts` entry.
ConfigMap updates do not refresh existing `subPath` mounts in-place. Changes to
included files trigger a rollout through the generated ConfigMap hash; changes
only to the original `glance` ConfigMap require a Deployment restart after sync:

```sh
kubectl -n glance rollout restart deployment/glance
kubectl -n glance rollout status deployment/glance
```

Application/platform services under `kubernetes/manifests` are represented
by HTTP checks or reference links. `_gitops` and `cluster-configs` are configuration,
not additional services. Proxmox playbook services are also included. The Plex
link is retained although its deployment is not present in this repository.
Storage, Drive, and inactive RustFS are omitted. The sample media stacks under `test/` and
learning environments under `studies/` are not treated as production services.

The widget templates adapt the community examples:

- [Tautulli stats](https://github.com/glanceapp/community-widgets/tree/main/widgets/tautulli-stats): activity, recently added, and top movies. Poster URLs containing API keys are intentionally omitted.
- [Cloudflare tunnel status](https://github.com/glanceapp/community-widgets/tree/main/widgets/cloudflare-tunnel-status): health, origin IP, connector count; cached for one minute instead of polling every few seconds.
- [Epic free games](https://github.com/glanceapp/community-widgets/tree/main/widgets/epic-free-widget): compact thumbnail list on Home with claim links and Swedish availability (`SE`). Change `country` and `allowCountries` for another region.
- [TrueNAS Scale pools](https://github.com/glanceapp/community-widgets/tree/main/widgets/truenas-scale-pools): root dataset usage and pool health; requires REST v2 support.
- [UniFi](https://github.com/glanceapp/community-widgets/tree/main/widgets/unifi): WAN state, uptime, client counts, latency, CPU, and RAM.

Infrastructure website checks test HTTP reachability, not authenticated application
functionality. A protected endpoint can report an error even when the service is
running; prefer a suitable internal `check-url` rather than treating every 401/403
response as healthy.

## Internal Tautulli Connection

`kustomization.yaml` generates `glance-widget-config` with
`TAUTULLI_URL=http://tautulli.tautulli.svc.cluster.local:8181`. The Deployment reads
it as an environment variable; config changes update the hash and roll the pods.
Only `TAUTULLI_API_KEY` is a secret. Widget API requests and the service monitor
use the internal address. Widget title links are omitted; the monitor's internal
link is only usable by clients that can resolve and reach cluster Services.

**Assumption to verify:** Service `tautulli`, namespace `tautulli`, Service port
`8181`, HTTP, with no URL base. This Service is not defined in this repository,
and live discovery was blocked by Unauthorized on the local-cluster context.
Adjust the ConfigMap literal if your Service differs. Use the Service port in
the URL and the pod's target port in the CNP rule.

`cnp.yaml` explicitly allows egress to namespace `tautulli` on TCP 8181. The
existing `toEntities: cluster` rule is retained, so this named rule documents the
dependency but does not restrict other cluster egress. If Tautulli is in another
namespace or uses another pod port, update that rule too.

If Tautulli's namespace already denies ingress, add a matching allow rule to its
own CNP after verifying its pod labels. For example, for pods labeled
`app: tautulli`:

```yaml
apiVersion: cilium.io/v2
kind: CiliumNetworkPolicy
metadata:
    name: allow-glance
    namespace: tautulli
spec:
    endpointSelector:
        matchLabels:
            app: tautulli
    ingress:
        - fromEndpoints:
                - matchLabels:
                        io.kubernetes.pod.namespace: glance
                        app: glance
            toPorts:
                - ports:
                        - port: "8181"
                            protocol: TCP
```

This backend policy is intentionally not part of Glance's Kustomization: Flux's
`targetNamespace: glance` would put it in the wrong namespace. Manage it alongside
Tautulli's existing policies, preserving access for its other clients.

## Validation

```sh
kubectl kustomize kubernetes/manifests/glance
```

Populate the values in `secrets.md` before Flux reconciles the updated Deployment.
No additional widget containers or Helm dependencies are required.