# Flux System

Bootstrap or reinstall Flux in two stages so the Flux Operator CRDs exist before
the `FluxInstance` is applied:

```sh
kubectl apply -k kubernetes/manifests/flux-system/operator
kubectl rollout status deployment/flux-system-flux-operator -n flux-system
kubectl apply -k kubernetes/manifests/flux-system
```

The operator manifests are pinned to Flux Operator v0.28.0, matching the
dependency package previously bundled by this directory's Helm chart.