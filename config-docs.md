# Kamlab Configuration Reference

This document is the operational reference for the dotfiles set in this repository.

## Scope

This repo manages terminal-centric development config for:

- Fish shell
- Zellij multiplexer
- AstroNvim-based Neovim
- Kitty terminal
- Lazygit
- GitHub CLI
- Glow markdown viewer
- Carbonyl terminal browser
- Matugen theme generation
- Bootstrap scripts, templates, and user-level systemd services

## Repository Map

| Path | Purpose |
|---|---|
| `fish/` | Shell behavior, aliases, interactive helpers, completions |
| `zellij/` | Multiplexer keymaps, plugins, pane helpers |
| `nvim/` | Editor runtime and plugin config |
| `kitty/` | Terminal UI and key mappings |
| `lazygit/` | Git TUI defaults + patch workflow shortcuts |
| `gh/` | GitHub CLI configuration |
| `git/` | Git global ignore bootstrap snippets |
| `bat/` | Bat pager/highlighter defaults |
| `ripgrep/` | Ripgrep default flags config |
| `glow/` | Glow markdown viewer configuration |
| `carbonyl/` | Carbonyl usage and integration notes |
| `matugen/` | Matugen theme templates and generation config |
| `zshrc.d/` | Zsh snippets kept alongside Fish-first setup |
| `zellij/themes/` | optional Matugen Zellij theme definitions |
| `scripts/` | Host/tooling audit helpers |
| `templates/project/` | Starter `.envrc` + `justfile` for new projects |
| `systemd/user/` | User services (currently SSH agent) |
| `justfile` | Repo-level verification and utility commands |

## Fish (`fish/`)

### Primary behavior

Main startup file: `fish/config.fish`

Key behavior:

- Defines a cached fallback prompt (`fish_prompt`) with Git branch/dirty marker.
- Uses Starship if present (`starship init fish | source`).
- Adds aliases for common operations (`ls`, `git` shortcuts, `nvim`, `zellij`, `just`, `codex`).
- Overrides `diff` with Git+Delta behavior when inside a repo and called with no args.
- Defines `work` helper to jump to a path/project and auto-attach/create a Zellij session.

### High-value custom functions

| Function | File | Purpose |
|---|---|---|
| `doctor` | `fish/functions/doctor.fish` | Validates fish/zellij config and dependency availability |
| `f` | `fish/functions/f.fish` | Fuzzy file finder + editor opener with preview |
| `take` | `fish/functions/take.fish` | `mkdir -p` then `cd` |
| `gwt` | `fish/functions/gwt.fish` | Git worktree helper with optional `-r/--remote` |
| `gap` | `fish/functions/gap.fish` | Checks if `.zellij/patches/current.patch` applies |
| `gap3` | `fish/functions/gap3.fish` | 3-way patch applicability check |

### Fish plugin and conf layout

- Plugin list: `fish/fish_plugins`
- Auto-loaded snippets: `fish/conf.d/*.fish`
- Completions: `fish/completions/*.fish`
- Functions: `fish/functions/*.fish`

## Zellij (`zellij/`)

Main config: `zellij/config.kdl`

### Core runtime settings

- `default_shell "fish"`
- `session_serialization false` (prevents resurrect behavior)
- `default_layout "default"`
- `scroll_buffer_size 50000`
- `copy_command "/home/kamash/.config/kamlab/zellij/scripts/copy-clipboard.sh"`
- `scrollback_editor "nvim"`

### Plugin integration

Configured local plugins:

- `monocle.wasm`
- `multitask.wasm`
- `zellij-forgot.wasm`
- `zellij-bookmarks.wasm`
- `zellij-favs.wasm`
- `zjstatus.wasm`
- `zellij-autolock.wasm`

Autolock plugin is enabled with trigger command patterns including `nvim`, `lazygit`, `fzf`, `codex`, and `claude`.

### Important keybind conventions

- `Ctrl g` toggles locked/normal mode boundaries.
- `Alt+h/j/k/l` performs pane/tab movement in shared modes.
- `Alt+1..4` are fixed-layout focus jumps (documented in config comments).
- Session mode (`Ctrl a`) exposes plugin launch actions.

### Zellij helper scripts

| Script | Purpose |
|---|---|
| `zellij/scripts/dev-diff-pane.sh` | Diff pane renderer with compact/full mode and incremental redraw |
| `zellij/scripts/copy-clipboard.sh` | Clipboard fallback chain (`wl-copy` -> `xclip` -> `pbcopy`) |
| `zellij/scripts/multitask_run.sh` | Multitask launcher hook |

Related note: [zellij/development.md](zellij/development.md) documents directory-first launch flow.

## Neovim (`nvim/`)

This is an AstroNvim v5+ setup.

Primary files:

- `nvim/init.lua`: bootstraps `lazy.nvim` and loads setup modules.
- `nvim/lua/lazy_setup.lua`: registers AstroNvim core + community + local plugin modules.
- `nvim/lua/polish.lua`: late-stage behavior tweaks (Python provider auto-resolution, spell setup).
- `nvim/lua/plugins/*.lua`: plugin-specific config modules.

### Plugin config modules currently present

`nvim/lua/plugins/` includes:

- Core/LSP: `astrocore.lua`, `astrolsp.lua`, `mason.lua`, `none-ls.lua`, `lsp-signature.lua`, `lsp-lens.lua`, `diagnostics.lua`
- Editing/UI: `comment.lua`, `surround.lua`, `auto-save.lua`, `flash.lua`, `windows.lua`, `yanky.lua`, `smartcolumn.lua`, `indent-blankline.lua`, `highlight-colors.lua`, `neoscroll.lua`, `twilight.lua`, `tint.lua`, `feline.lua`, `dashboard.lua`
- Language/domain: `python.lua`, `sql.lua`, `vimtex.lua`, `neorg.lua`, `language_packs.lua`, `treesitter.lua`, `dap.lua`
- Misc: `cheat.lua`, `diagram.lua`, `garbage-day.lua`, `illuminate.lua`, `smart-splits.lua`, `tabby.lua`, `user.lua`, `wrap.lua`

Additional docs:

- [nvim/README.md](nvim/README.md)
- [nvim/QWEN.md](nvim/QWEN.md)

## Kitty (`kitty/`)

Main config: `kitty/kitty.conf`

Key settings:

- Font: `JetBrains Mono Nerd Font`, size `11.0`
- Cursor: `beam`, `cursor_trail 1`
- Margin: `window_margin_width 21.75`
- Remote control: `socket-only` on `unix:/tmp/kitty`
- Shell: `fish`
- Search split mapping using `kitty +kitten search.py`
- Copy and zoom/scroll keymaps

Local kitty kittens/scripts:

- `kitty/search.py`
- `kitty/scroll_mark.py`

## Lazygit (`lazygit/`)

Main config: `lazygit/config.yml`

Behavior:

- Auto-fetch enabled.
- Pager routed through Delta (`delta --paging=never`).
- Custom commands for staged patch workflow:
  - `Y`: export staged patch to `.zellij/patches/current.patch`
  - `I`: validate patch applies cleanly
  - `G`: refresh patch view helpers
  - `U`: apply saved patch via Fish helper scripts

## GitHub CLI (`gh/`)

Primary files:

- `gh/config.yml`
- `gh/hosts.yml`

Behavior:

- sets default git protocol and CLI interaction preferences
- defines command aliases (for example `co: pr checkout`)

## Git (`git/`)

Primary file:

- `git/ignore`
- `git/delta.gitconfig`

Behavior:

- documents/bootstraps global excludesfile usage:
  `git config --global core.excludesfile ~/.config/git/ignore`
- stores host-level ignore patterns (for example `**/.claude/settings.local.json`)
- provides reusable `git-delta` configuration include

To enable delta settings globally:

```bash
git config --global include.path ~/.config/kamlab/git/delta.gitconfig
```

## Bat (`bat/`)

Primary file:

- `bat/config`

Behavior:

- sets default display style/paging for `bat` previews in terminal workflows

To enable:

```bash
mkdir -p ~/.config/bat
ln -sf ~/.config/kamlab/bat/config ~/.config/bat/config
```

## Ripgrep (`ripgrep/`)

Primary files:

- `ripgrep/config`
- [ripgrep/README.md](ripgrep/README.md)

Behavior:

- provides shared default `rg` flags for this workflow

To enable globally:

```bash
export RIPGREP_CONFIG_PATH="$HOME/.config/kamlab/ripgrep/config"
```

## Glow (`glow/`)

Primary file:

- `glow/glow.yml`

Behavior:

- controls markdown TUI rendering defaults (style/width/mouse/pager)

## Carbonyl (`carbonyl/`)

Primary file:

- [carbonyl/README.md](carbonyl/README.md)

Behavior:

- documents how Carbonyl is used in this terminal-first workflow
- tracks install/verification commands for host setup

## Matugen (`matugen/`)

Primary files:

- `matugen/config.toml`
- `matugen/templates/*`

Behavior:

- maps generated palette outputs into Hyprland, Hyprlock, Fuzzel, GTK, and Quickshell paths
- keeps template artifacts versioned in-repo

Additional generated integration targets:

- `~/.config/kitty/matugen.conf` (Kitty overlay)
- `~/.config/git/delta-theme.gitconfig` (Delta override include)
- `~/.config/starship-matugen.toml` (Starship config overlay)
- `~/.local/state/quickshell/user/generated/nvim/matugen.lua` (Nvim highlights)
- `~/.local/state/quickshell/user/generated/fish/matugen-colors.fish` (Fish colors)
- `~/.config/kamlab/zellij/themes/matugen.kdl` (optional Zellij theme)

`zellij/themes/matugen.kdl` is synchronized from generated `colors.json` using:

```bash
just sync-zellij-theme
```

### Matugen Recovery Controls

Scripted toggle:

```bash
bash ~/.config/kamlab/scripts/matugen-mode.sh off
bash ~/.config/kamlab/scripts/matugen-mode.sh on
bash ~/.config/kamlab/scripts/matugen-mode.sh status
```

Default baseline is `theme "default"` in `zellij/config.kdl`.
The toggle creates/removes `~/.config/kamlab/.matugen-disabled` and switches managed lines in Kitty/Zellij.
Shell and Nvim overlays also honor `KAMLAB_MATUGEN_DISABLE=1`.

## Zsh Snippets (`zshrc.d/`)

Primary files:

- `zshrc.d/auto-Hypr.sh`
- `zshrc.d/dots-hyprland.zsh`
- `zshrc.d/shortcuts.zsh`

Behavior:

- retains legacy/shared shell snippets for Hyprland auto-start and key bindings

## Repo Automation (`justfile`, `scripts/`, `systemd/`)

### `justfile` commands

| Command | Purpose |
|---|---|
| `just audit` | Run environment/tool audit |
| `just ssh-agent-status` | Show SSH agent env + identities + service status |
| `just verify-fish` | Parse-check Fish helper file |
| `just verify-layout` | Ensure legacy layout removed + diff script syntax check |
| `just smoke` | Combined non-interactive verification |
| `just loop-test` | Event-driven test loop with Python/Julia routing |
| `just loop-todo` | Event-driven TODO/FIXME loop into `nvim` |
| `just loop-diff` | Event-driven compact git diff loop |

### Environment audit script

`scripts/dev-env-audit.sh` detects:

- OS and likely package manager
- required tools (`zellij`, `direnv`, `just`, `zoxide`, `ghq`, `rg`, `fd`, `fzf`, `lazygit`)
- optional tools (`gh`, `glow`, `carbonyl`, `matugen`, `jq`, `yq`, `fx`, `btm`, `cht.sh`, `tldr`, `eza`, `tokei`, `sd`, `yazi`, `ncdu`, `entr`, `bat`, `delta`, `watch`, `uv`, `mise`, `juliaup`)

### Event-Driven Workflow Patterns

Prefer `entr` for file event triggers; keep `watch` as a polling fallback.

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

### Quick Command Recall

Pair `cht.sh` (richer examples) with `tldr` (quick flag-shape reminders):

```bash
tldr tar
tldr systemctl
```

### User service

`systemd/user/ssh-agent.service`:

- starts user-level ssh-agent
- exports socket at `%t/ssh-agent.socket`

## Project Templates (`templates/project/`)

Starter artifacts for new repos:

- `.envrc`: adds `.venv/bin` and `bin/` to `PATH`, sets `PYTHONUNBUFFERED=1`
- `justfile`: baseline `test`, `lint`, `format`, `run`
- [templates/project/README.md](templates/project/README.md): short usage notes

Use these when bootstrapping a new repo that should follow the same human/agent workflow contract.

## Maintenance Checklist

When changing config behavior:

1. Update the relevant config file.
2. Update this reference doc for new defaults/keymaps/helpers.
3. Re-run local checks (`just audit`, `just verify-layout`, plus targeted command checks).
4. Validate runtime behavior in an actual shell/Zellij session.
