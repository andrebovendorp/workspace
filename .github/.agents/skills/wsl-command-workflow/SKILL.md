---
name: wsl-command-workflow
description: Use whenever running shell commands for this repository; execute them in WSL rather than PowerShell or cmd.exe.
---

# WSL Command Workflow

All repository shell commands must run through WSL. From the repository's PowerShell terminal, invoke:

```powershell
wsl.exe --cd "$PWD" --exec bash -lc '<bash command>'
```

Examples:

```powershell
wsl.exe --cd "$PWD" --exec bash -lc 'git status --short'
wsl.exe --cd "$PWD" --exec bash -lc 'kubectl kustomize kubernetes/manifests/audiobook'
wsl.exe --cd "$PWD" --exec bash -lc 'mkdocs build --clean --strict'
```

Put Linux shell syntax and repository-relative paths inside the single-quoted Bash command. Keep the Windows path only in the `--cd "$PWD"` argument; do not pass Windows paths to Linux programs. Quote paths and shell arguments containing spaces or metacharacters.

Run commands from the repository root unless a tool requires a subdirectory. Prefer read-only or validation commands; never use WSL as a way to bypass safeguards on live infrastructure. Never use `kubectl` to change a live cluster; follow `.agents/skills/kubernetes-gitops/SKILL.md` instead. If WSL is unavailable, stop and report the blocker rather than silently switching shells.
