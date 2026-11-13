---
name: mkdocs-documentation
description: Use when editing the MkDocs site, architecture documentation, operational guides, or decision records.
---

# MkDocs Documentation

## Sources and conventions

- Markdown pages live under `docs/`; navigation and site configuration are in the repository-root `mkdocs.yml`.
- Check the existing page and navigation structure before adding or moving a page. Keep links and navigation entries consistent.
- Use existing Markdown conventions, relative links, and terminology. Distinguish documented decisions from implementation facts; verify facts against the current configuration.
- Update the relevant decision record when a change establishes or changes architectural intent. Decision records should explain context, options, rationale, consequences, status, and review timing where appropriate.
- Do not expose private infrastructure details, credentials, tokens, or secret values in examples or generated documentation.

## Validation

The documentation workflow builds with:

```powershell
wsl.exe --cd "$PWD" --exec bash -lc 'mkdocs build --clean --strict'
```

Use WSL as described in `.agents/skills/wsl-command-workflow/SKILL.md`. Run the strict build when dependencies are available; report missing dependencies or validation limits explicitly.
