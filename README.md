
```markdown
# Agent-Centric Terminal Development Workflow

**Stack:** Zellij · AstroNvim · Fish · Kitty · Hyprland/Wayland  
**Languages:** Python (data engineering) + occasional Julia (data science/scientific computing)  
**Coding agents:** Codex · qwen-code · mistral-vibe · tabby

---

# 1. Design Goals

- Constant-time project entry: `z → dev`
- Deterministic per-directory environments
- Long-lived runtime state outside the editor
- Continuous feedback from tests and diffs
- Agents as observable, interruptible, parallel processes
- Minimal context-switching cost
- Human-controlled Git history and semantics

---

# 2. Core Mental Model

```

directory → environment → Zellij session → (NVIM + AGENT + runtime panes)

````

Single sources of truth:

| Concern | Owner |
|---------|-------|
Environment | direnv / Nix |
Tasks | just |
History | git |

---

# 3. Project Entry

```fish
z <project>
dev
````

```fish
function dev
    set session (basename (pwd))
    zellij attach -c $session
end
```

In this repo, the Fish helper is implemented as an autoloaded function:

```
fish/functions/dev.fish
```

That keeps `fish/config.fish` simpler and makes the command easy to version and review.

---

# 4. Layered Architecture

## 4.1 Core CLI

* git
* openssh
* ripgrep
* fd
* bat
* eza
* fzf
* zoxide
* direnv
* just
* wl-clipboard
* xdg-utils

---

## 4.2 Repository Location

* ghq

Deterministic mapping:

```
repo → ~/ghq/<host>/<owner>/<name>
```

---

## 4.3 Language Runtimes & Environments

* mise
* uv (Python environments + dependencies)
* juliaup
* possibly in future: nix + flakes (full reproducibility)

---

## 4.4 Terminal & Wayland Integration

* kitty
* fuzzel (launcher)
* mako + notify-send (notifications)
* grim + slurp + swappy (screenshots / annotations)
* zathura (PDF / reports)
* imv (optional image preview)

---

## 4.5 Multiplexer / Runtime Orchestrator

* zellij

Responsibilities:

* persistent workspace topology
* long-running processes
* agent isolation
* fast session attach

---

## 4.6 Editor

**AstroNvim + community plugins**

Provides:

* LSP
* Treesitter
* Telescope
* Mason
* DAP
* Completion

---

## 4.7 LSP / Lint / Format / Debug

* basedpyright
* ruff / ruff-lsp
* julia-language-server
* bashls
* yamlls
* taplo
* conform.nvim
* nvim-lint
* nvim-dap + debugpy

---

## 4.8 Git

Inside Neovim:

* gitsigns.nvim
* vim-fugitive

Repository UI:

* lazygit (dedicated pane)

---

## 4.9 Data Engineering Tooling

Python:

* polars
* duckdb
* ipython
* jupyterlab (when needed)

Julia:

* Revise.jl
* LanguageServer.jl

---

# 5. Zellij Layout

Current implementation (editor-heavy variant):

```
+-------------------+-------------------+
|                   |       AGENT       |
|       NVIM        +-------------------+
|                   |        DIFF       |
+-------------------+-------------------+
|        GIT        |        AUX        |
+-------------------+-------------------+
```

Why this variant:

* More space for `nvim`
* `REPL / TESTS` moved out of the default layout (can be opened ad-hoc when needed)
* Keeps the core review loop visible (`AGENT`, `DIFF`, `GIT`)

---

# 6. Pane Semantics

## NVIM

* code editing
* refactoring
* LSP navigation
* semantic review of agent changes

This is the **only manual editing surface**.

---

## AGENT

Runs one of:

```
codex
qwen-code
mistral-vibe
tabby
```

Agent responsibilities:

* generate patches
* execute `just` tasks
* analyze failing tests

---

## REPL / TESTS

### REPL mode

```
ipython
julia
```

### Test loop mode

```
just test
```

or

```
ptw
```

This pane is the **continuous feedback stream** for both human and agent.

---

## DIFF

Persistent working tree inspection.

```
git diff | delta
```

or:

```
git diff --color=always | less -R
```

Continuous mode:

```
watch -n 1 'git diff --stat && echo && git diff --color=always'
```

Current implementation in this repo:

```
zellij/scripts/dev-diff-pane.sh
```

The script runs as a standalone helper, uses `delta` when available, and falls back to plain colored `git diff`.

Default behavior is **compact mode** (stats + file list). This is intentional so minified / very large diffs do not flood the small DIFF pane.

For a full patch in the pane (temporary/manual use):

```bash
DEV_DIFF_PANE_MODE=full ~/.config/kamlab/zellij/scripts/dev-diff-pane.sh
```

Purpose:

* immediate visibility of agent changes
* zero editor context switching

---

## GIT

```
lazygit
```

Commits happen only after:

* NVIM review
* DIFF verification

---

## AUX

Flexible auxiliary pane:

Typical uses:

* ad-hoc shell
* documentation preview
* manual `just` tasks
* local services (`uvicorn`, `dbt`, `docker logs`)
* monitoring (`bottom`)

---

# 7. Agent Interaction Loops

## 7.1 Fixing Failing Tests

1. TESTS pane shows failure
2. traceback → AGENT
3. agent generates patch
4. DIFF shows change set
5. NVIM → semantic corrections
6. GIT → commit

---

## 7.2 Refactor / Performance Work

* AGENT → transformation
* DIFF → scope verification
* NVIM → logic validation
* TESTS → regression check

---

## 7.3 Data Exploration

* REPL → rapid experimentation
* NVIM → stabilization into source
* AGENT → pipeline boilerplate generation

---

# 8. Deterministic Contract for Agents

Agents:

* do not modify environment loading
* execute tasks only through `just`
* produce patch-style changes
* never rewrite Git history autonomously

---

# 9. Project Structure

Conceptual per-project structure (the workflow target):

```
project/
├── .envrc
├── .zellij/layout.kdl
├── pyproject.toml
├── justfile
├── src/
└── tests/
```

Dotfiles repo implementation (this repository):

```
fish/functions/dev.fish
justfile
scripts/dev-env-audit.sh
templates/project/.envrc
templates/project/justfile
zellij/scripts/dev-diff-pane.sh
```

Note: `zellij/` is a Git submodule in this repo, so layout/script changes are tracked inside that submodule.

`direnv` guarantees:

```
cd project → correct PATH + correct runtime + correct variables
```

Template starter files for new projects (kept in this dotfiles repo):

```
templates/project/.envrc
templates/project/justfile
templates/project/README.md
```

Use these as a baseline so both humans and agents run routine tasks through `just` and rely on `direnv` for environment loading.

If you are setting this up on a new machine, start with the non-interactive checks first:

```bash
just audit
just smoke
```

That gives you a quick “what is missing?” readout before you try to launch the full workspace.

---

# 10. Wayland Integration

## Launcher

fuzzel:

* jump to ghq repo
* attach Zellij session
* run just tasks

---

## Notifications

From TESTS pane:

```
notify-send "tests passed"
notify-send "tests failed"
```

---

## Clipboard Bridge

wl-clipboard:

* NVIM ↔ AGENT ↔ system

---

## Screenshots

For documentation or agent context:

```
grim + slurp + swappy
```

---

# 11. Performance Targets

| Component              | Target     |
| ---------------------- | ---------- |
| AstroNvim startup      | < 150 ms   |
| Zellij attach          | instant    |
| Project switch         | 2 commands |
| Manual venv activation | never      |

---

# 12. Cognitive Load Optimization

Stable spatial mapping:

| Area   | Function                         |
| ------ | -------------------------------- |
| Top    | creation (NVIM + AGENT)          |
| Middle | review (DIFF) + editor focus     |
| Bottom | history & operations (GIT + AUX) |

No “where is what” overhead.

---

# 13. Scaling Properties

This workflow scales to:

* many repositories
* parallel agents (separate Zellij tabs)
* long-running data pipelines
* remote SSH development

without changing interaction patterns.

---

# 14. Minimal Viable Stack

* git · ripgrep · fd · fzf · zoxide · direnv · ghq
* mise · uv · juliaup
* zellij
* kitty
* fish
* astronvim
* lazygit
* just
* fuzzel · mako · wl-clipboard · zathura

---

# 15. Core Feedback Loop

```
tests → agent → diff → review → commit
```

Properties:

* continuous
* observable
* deterministic
* human-controlled

---

# 16. Summary

This workflow:

* treats agents as first-class cooperative processes
* keeps runtime state persistent and visible
* enforces deterministic task execution
* minimizes context switching
* preserves human control over code semantics and history

It is optimized for REPL-driven data engineering, patch-based AI collaboration, and high-throughput multi-project work.

## Practical Notes (Current Repo)

- `dev` is implemented as `fish/functions/dev.fish` and avoids resurrecting exited sessions that trigger "Waiting to run" prompts
- The root `justfile` provides local verification commands (`audit`, `verify-fish`, `verify-layout`, `smoke`)
- `justfile` also provides `ssh-agent-status` for debugging SSH agent state
- The DIFF pane helper script is `zellij/scripts/dev-diff-pane.sh` (inside the `zellij` submodule) and runs in compact mode by default
- `fish/config.fish` includes a cached fallback prompt with Git branch/dirty metadata (Starship still overrides prompt when installed)
- `fish/functions/take.fish`: `take <dir>` creates and enters a directory safely
- `fish/functions/f.fish`: fuzzy file opener using `fd + fzf` with `bat` preview and heavy-path excludes (`.git`, `node_modules`, `.venv`, `dist`, `target`)
- `fish/functions/gwt.fish`: safe Git worktree helper, including `gwt -r <branch>` to base from `origin/<branch>` when local branch is missing
- `fish/functions/gap.fish` and `fish/functions/gap3.fish`: patch applicability checks for `.zellij/patches/current.patch` with explicit errors
- `fish/functions/work.fish`: zoxide-aware project jump + `zellij attach -c` using prefixed session names (`wrk_<project>`)
- `fish/functions/doctor.fish`: one-shot local health check (`fish -n`, `zellij setup --check`, required tool presence)
- `fish/completions/gwt.fish` and `fish/completions/work.fish` provide shell completions for custom helpers
- `zellij/config.kdl` uses `copy_command "/home/kamash/.config/kamlab/zellij/scripts/copy-clipboard.sh"` for clipboard fallback across Wayland/X11/macOS (`wl-copy` → `xclip` → `pbcopy`)

This keeps the workflow spec in the README and the executable pieces close to the dotfiles that actually drive the session.
