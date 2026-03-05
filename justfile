set shell := ["bash", "-eu", "-o", "pipefail", "-c"]

default:
    @just --list

# Print concise environment/tool inventory for this workflow host.
audit:
    @bash scripts/dev-env-audit.sh

# Show SSH agent socket, loaded identities, and systemd user service status.
ssh-agent-status:
    @env | rg '^SSH_AUTH_SOCK=' || echo "SSH_AUTH_SOCK=<unset>"
    @ssh-add -l 2>&1 || true
    @if command -v systemctl >/dev/null 2>&1; then \
      systemctl --user --no-pager --full status ssh-agent.service 2>&1 | sed -n '1,30p' || true; \
    else \
      echo "systemctl not found"; \
    fi

# Verify Fish config and core helper files parse.
verify-fish:
    @fish -n fish/config.fish
    @fish -n fish/functions/doctor.fish
    @echo "fish/config.fish + fish/functions/doctor.fish: OK"

# Verify legacy dev layout is removed and DIFF helper script still parses.
verify-layout:
    @if test -f zellij/layouts/dev.kdl; then \
      echo "verify-layout: zellij/layouts/dev.kdl should be removed"; \
      exit 1; \
    fi
    @bash -n zellij/scripts/dev-diff-pane.sh
    @echo "zellij legacy layout removed + diff script: OK"

# Run all local static checks without launching interactive apps.
smoke: audit verify-fish verify-layout
    @echo "smoke: OK"

# Verify tooling required by event-driven loop workflows.
audit-loop-tools:
    @for t in entr fd rg; do command -v $$t >/dev/null 2>&1 || { echo "missing: $$t"; exit 1; }; done

# Event-driven test loop (routes Python/Julia by changed file type).
loop-test: audit-loop-tools
    @bash scripts/dev-loop.sh test

# Event-driven TODO/FIXME loop into nvim.
loop-todo: audit-loop-tools
    @bash scripts/dev-loop.sh todo

# Event-driven compact git diff loop.
loop-diff: audit-loop-tools
    @bash scripts/dev-loop.sh diff
