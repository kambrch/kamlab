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

# Verify the Fish helper function file parses.
verify-fish:
    @fish -n fish/functions/dev.fish
    @echo "fish/functions/dev.fish: OK"

# Verify zellij layout references and DIFF helper script in the submodule.
verify-layout:
    @test -f zellij/layouts/dev.kdl
    @rg -n 'pane name=\"NVIM\"' zellij/layouts/dev.kdl >/dev/null
    @rg -n 'pane name=\"AGENT\"' zellij/layouts/dev.kdl >/dev/null
    @rg -n 'pane name=\"DIFF\"' zellij/layouts/dev.kdl >/dev/null
    @rg -n 'pane name=\"GIT\"' zellij/layouts/dev.kdl >/dev/null
    @rg -n 'pane name=\"AUX\"' zellij/layouts/dev.kdl >/dev/null
    @if rg -n 'pane name=\"REPL / TESTS\"' zellij/layouts/dev.kdl >/dev/null; then \
      echo "verify-layout: unexpected REPL / TESTS pane present"; \
      exit 1; \
    fi
    @rg -n 'dev-diff-pane\.sh' zellij/layouts/dev.kdl >/dev/null
    @bash -n zellij/scripts/dev-diff-pane.sh
    @echo "zellij layout + diff script: OK"

# Run all local static checks without launching interactive apps.
smoke: audit verify-fish verify-layout
    @echo "smoke: OK"
