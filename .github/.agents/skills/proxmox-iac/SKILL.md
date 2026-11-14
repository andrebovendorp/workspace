---
name: proxmox-iac
description: Use when editing Proxmox automation, Ansible playbooks, or Terraform infrastructure and workshop configuration in this repository.
---

# Proxmox and Infrastructure as Code

## Repository layout

- Proxmox host and service automation is grouped under `proxmox/<service>/`, typically with a playbook, inventory, variables, and templates.
- Kubernetes bootstrap Ansible is under `kubernetes/ansible/`.
- The checked-in Terraform workshop configuration is under `workshops/kubeadm/iac/`; do not assume Terraform is the mechanism for managing Proxmox services.
- Inspect the relevant playbook, variables, templates, and documented decisions before changing behavior. Reuse established Ansible modules and idempotent task patterns.

## Safety and change patterns

- Default to changing repository configuration, not live systems. Do not make live deployment a prerequisite for implementing the requested code; describe any operational follow-up separately.
- Treat inventories, `secrets.yml`, secret files, `.tfvars`, Terraform state and backups, and credentials as sensitive. Do not print their contents, commit them, or copy values into examples.
- Prefer Ansible modules over ad-hoc shell commands; make tasks idempotent and preserve handler/notification patterns where present.
- Keep Terraform changes consistent with nearby provider constraints, variables, modules, and outputs. Do not alter unrelated modules or generated `.terraform/` content.
- Consider backup/recovery, availability, access, and resource impact for changes to databases, storage, networking, or virtualization.
- Never run Ansible against live hosts or `terraform apply` without explicit user authorization. A plan may also contact providers or reveal sensitive values; confirm scope and credentials before running one.

## Validation

Run commands through `.agents/skills/wsl-command-workflow/SKILL.md`. Use focused, non-destructive checks where the relevant tools and dependencies are already available, such as `terraform fmt -check` for changed Terraform files or Ansible syntax checks for the specific playbook. Avoid initialization that downloads providers or collections unless required and authorized. State clearly what was checked; do not claim a live deployment was tested.
