# Personal Terminal Development Workflow

## Stack

Zellij, AstroNvim, Fish, Kitty, Lazygit, Just, Direnv

**Terminal multiplexer:** Zellij
**Terminal emulator:** Kitty
**Shell:** Fish
**Editor:** AstroNvim
**Git helper:** Lazygit
**Task runner:** Just
**Environment loader:** Direnv 

## Documentation

- Main config reference: `docs/CONFIG_REFERENCE.md`
- Neovim details: `nvim/README.md`
- Zellij launch notes: `zellij/development.md`
- Project starter templates: `templates/project/README.md`

## Design Goals

- Deterministic per-project environments
- Persistent runtime context outside the editor
- Minimal context switching between editing, review, and git 

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

## Core Components

| Path | Role |
|---|---|
| `fish/` | shell behavior, aliases, helper functions, completions |
| `zellij/` | multiplexer config, plugins, pane scripts |
| `nvim/` | AstroNvim configuration and plugin modules |
| `kitty/` | terminal UI/key mappings |
| `lazygit/` | git TUI defaults and patch commands |
| `gh/` | GitHub CLI configuration |
| `git/` | global Git ignore snippets/bootstrap |
| `bat/` | bat pager/highlighter defaults |
| `ripgrep/` | shared `rg` defaults |
| `glow/` | Glow markdown viewer preferences |
| `carbonyl/` | terminal-browser integration notes |
| `matugen/` | wallpaper-driven color generation templates/config |
| `zshrc.d/` | legacy/shared Zsh snippets (Hyprland + shortcuts) |
| `scripts/` | host/tooling audit scripts |
| `templates/project/` | starter `.envrc` + `justfile` |
| `systemd/user/` | user-level services (`ssh-agent`) |
| `zellij/themes/` | Matugen-aware Zellij theme file |

## Tool Roles

### Required

| Tool | Role |
|---|---|
| `zellij` | persistent terminal sessions/panes for coding workflows |
| `direnv` | per-project environment auto-loading from `.envrc` |
| `just` | deterministic task runner for checks and workflow commands |
| `zoxide` | fast directory jumping (`z`) based on frecency |
| `ghq` | local multi-repo manager for clone/list/jump workflows |
| `rg` | fast recursive text/code search |
| `fd` | fast file and path discovery |
| `fzf` | fuzzy finder UI used by interactive shell workflows |
| `lazygit` | terminal UI for git operations |

### Optional

| Tool | Role |
|---|---|
| `delta` | enhanced syntax-highlighted diffs and pager output |
| `bat` | syntax-highlighted `cat` replacement for previews and paging |
| `jq` | JSON query and transform CLI |
| `yq` | YAML/JSON/TOML query and transform CLI |
| `fx` | interactive JSON explore/transform CLI |
| `btm` | terminal system monitor (`bottom`) |
| `cht.sh` | terminal cheat-sheet lookup client/service |
| `tldr` | concise command examples and flag shapes |
| `eza` | modern `ls` replacement |
| `tokei` | language line-count and code stats |
| `sd` | safe and fast bulk text replace |
| `yazi` | terminal file manager |
| `ncdu` | interactive disk-usage analyzer |
| `entr` | filesystem-event driven command reruns |
| `gh` | GitHub CLI for PR/issue/repo workflows |
| `glow` | terminal markdown rendering |
| `carbonyl` | terminal-first web browser for text-mode browsing |
| `matugen` | generate and apply UI/system color palettes |
| `watch` | rerun commands continuously for feedback loops |
| `uv` | fast Python packaging/environment tooling |
| `mise` | runtime and tool version manager |
| `juliaup` | Julia version manager |

## Local Commands

| Command | Purpose |
|---|---|
| `just audit` | show OS/package manager and missing/present tooling |
| `just verify-fish` | parse-check Fish config and key helper |
| `just verify-layout` | ensure legacy layout file is gone + diff script parses |
| `just smoke` | run all repo checks |
| `just ssh-agent-status` | inspect SSH agent env + identities + service |
| `just loop-test` | event-driven test loop (Python/Julia routed by file type) |
| `just loop-todo` | event-driven TODO/FIXME loop into `nvim` |
| `just loop-diff` | event-driven compact git diff loop |

## Event-Driven Loops

Prefer `entr` for filesystem-event driven loops; keep `watch` as polling fallback.

```bash
fd -e py -e toml -e yaml | entr -c pytest -q
rg -l "TODO|FIXME" . | entr -c nvim
```

Project-root wrappers:

```bash
just loop-test
just loop-todo
just loop-diff
```

## Quick Command Recall

Use both tools together: `cht.sh` for richer examples, `tldr` for fast flag-shape recall.

```bash
tldr tar
tldr systemctl
```

## Matugen Coverage

Matugen-driven theming is wired for:

- `kitty` via `globinclude ~/.config/kitty/matugen.conf`
- `git-delta` via `~/.config/git/delta-theme.gitconfig` include
- `starship` via `~/.config/starship-matugen.toml`
- `nvim` highlight overlay via generated Lua module
- `zellij` theme (`matugen`) via `zellij/themes/matugen.kdl`
- `fish` syntax colors via generated fish color file

`zellij/themes/matugen.kdl` is generated from `~/.local/state/quickshell/user/generated/colors.json`
via `scripts/sync-zellij-theme.sh` (or `just sync-zellij-theme`).

## Matugen Recovery

Fast toggle:

```bash
bash ~/.config/kamlab/scripts/matugen-mode.sh off
bash ~/.config/kamlab/scripts/matugen-mode.sh on
bash ~/.config/kamlab/scripts/matugen-mode.sh status
```

Environment override (shell/nvim overlays):

```bash
export KAMLAB_MATUGEN_DISABLE=1
```

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

- Clipboard fallback chain for Zellij copy: `wl-copy` -> `xclip` -> `pbcopy`.
- For full setting-level documentation, keep `docs/CONFIG_REFERENCE.md` in sync with config changes.
