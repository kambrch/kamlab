# Agent-Centric Terminal Development Workflow

**Stack:** Zellij, AstroNvim, Fish, Kitty, Lazygit, Just, Direnv  
**Primary use case:** high-throughput coding with human + agent collaboration in a persistent terminal workspace.

## Documentation

- Main config reference: `docs/CONFIG_REFERENCE.md`
- Neovim details: `nvim/README.md`
- Zellij launch notes: `zellij/development.md`
- Project starter templates: `templates/project/README.md`

## Design Goals

- Deterministic per-project environments
- Persistent runtime context outside the editor
- Continuous diff/test visibility during agent work
- Minimal context switching between editing, review, and git
- Human-controlled code semantics and git history

## Quick Start

1. Clone and enter the repo.
2. Run non-interactive checks:

```bash
just audit
just verify-fish
just verify-layout
# optional aggregate check:
just smoke
```

`just smoke` can fail if required tools are missing on the host (for example `ghq`), which is expected on fresh machines.

## Daily Workflow

### Open a project session

From Fish:

```fish
work <project-or-path>
```

Behavior:

- if `z` exists, it is used for project jump
- otherwise it `cd`s directly
- attaches/creates a Zellij session named `wrk_<project>`

The `work` helper is defined in `fish/config.fish`.

### Main feedback loop

```text
tests -> agent patch -> diff review -> nvim review -> commit
```

## Workspace Model

```text
directory -> environment -> zellij session -> (nvim + agent + diff/git panes)
```

Single source of truth per concern:

| Concern | Owner |
|---|---|
| Environment | `direnv` / runtime manager |
| Tasks | `just` |
| History | `git` |

## Core Components

| Path | Role |
|---|---|
| `fish/` | shell behavior, aliases, helper functions, completions |
| `zellij/` | multiplexer config, plugins, pane scripts |
| `nvim/` | AstroNvim configuration and plugin modules |
| `kitty/` | terminal UI/key mappings |
| `lazygit/` | git TUI defaults and patch commands |
| `scripts/` | host/tooling audit scripts |
| `templates/project/` | starter `.envrc` + `justfile` |
| `systemd/user/` | user-level services (`ssh-agent`) |

## Important Local Commands

| Command | Purpose |
|---|---|
| `just audit` | show OS/package manager and missing/present tooling |
| `just verify-fish` | parse-check Fish config and key helper |
| `just verify-layout` | ensure legacy layout file is gone + diff script parses |
| `just smoke` | run all repo checks |
| `just ssh-agent-status` | inspect SSH agent env + identities + service |

## Key Workflow Files

- `fish/config.fish`:
  - fallback prompt cache
  - aliases
  - `work` session helper
  - git-aware `diff` wrapper
- `zellij/config.kdl`:
  - keymaps
  - plugin wiring
  - autolock trigger config
  - clipboard command fallback
- `zellij/scripts/dev-diff-pane.sh`:
  - compact/full diff pane rendering
  - redraw-on-change logic for stable scrollback
- `lazygit/config.yml`:
  - Delta pager
  - patch export/check/apply custom actions

## Project Templates

Use `templates/project/` as a baseline for new repos:

- `.envrc` for environment loading (`.venv/bin`, `bin/`)
- `justfile` for deterministic `test/lint/format/run`

## Notes

- `zellij/` is a git submodule; edits there are tracked in the submodule repository.
- Clipboard fallback chain for Zellij copy: `wl-copy` -> `xclip` -> `pbcopy`.
- For full setting-level documentation, keep `docs/CONFIG_REFERENCE.md` in sync with config changes.
