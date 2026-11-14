---
name: kubernetes-gitops
description: Use when editing K3s resources, FluxCD configuration, Kubernetes manifests, Kustomize overlays, or Helm values in this repository.
---

# Kubernetes and GitOps

## Locate the owning configuration

- Cluster bootstrap and node setup live under `kubernetes/ansible/`.
- Application and platform resources are organized under `kubernetes/manifests/<component>/`.
- Flux reconciliation entry points and shared settings live under `kubernetes/manifests/flux-system/`.
- Read `kubernetes/DECISIONS.md` and relevant documentation before changing platform behavior. Check the current files rather than assuming overview text reflects deployed state.

## Change patterns

- For simple resources, prefer plain YAML plus a component `kustomization.yaml`; include each resource there and follow its namespace, labels, and image-version patterns.
- Use Helm for complex applications or where the component already uses a chart and `values.yaml`. Avoid adding a chart for a simple Deployment or CronJob.
- Preserve Flux ownership and reconciliation boundaries. Do not make a parallel/manual source of truth for a Flux-managed resource.
- Follow neighboring resource security and operations patterns: least privilege, non-root where supported, restricted privilege escalation, resource requests and limits, and explicit storage mounts/claims for persistent data.
- Review network policy, ingress/Gateway API, secret references, backups, and storage implications when changing a workload that depends on them.
- Keep image and chart versions explicit and consistent with the component's existing mechanism. Do not upgrade unrelated components.
- Never add credentials to manifests or output. Preserve external-secret references and secret boundaries.

## Live cluster safety

- Treat infrastructure requests as repository changes by default. Implement the desired manifests without assuming live deployment or data migration is requested; describe any cutover steps or risks separately.
- Never use `kubectl` to change anything on a live cluster, even when requested or authorized. Edit the repository's manifests and configuration instead.
- If an operation requires a live change, ask the user to perform it. Provide the exact command, explain its purpose and impact, and identify any target or values the user must verify before running it. Do not execute it yourself.

## Validation

Run commands through `.agents/skills/wsl-command-workflow/SKILL.md`. For a plain Kustomize component, use `kubectl kustomize <component-directory>` or `kustomize build <component-directory>` when installed. For Helm-based components, render the chart with its existing values if the chart and required dependencies are locally available. Report missing tools or dependencies rather than silently skipping validation.

Do not run `kubectl apply`, make cluster connections, or change live resources as validation.
