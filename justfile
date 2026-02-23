set shell := ["bash", "-eu", "-o", "pipefail", "-c"]

default:
    @just --list

# Print concise environment/tool inventory for this workflow host.
audit:
    @bash scripts/dev-env-audit.sh

# Verify the Fish helper function file parses.
verify-fish:
    @fish -n fish/functions/dev.fish
    @echo "fish/functions/dev.fish: OK"

# Verify zellij layout references and DIFF helper script in the submodule.
verify-layout:
    @test -f zellij/layouts/dev.kdl
    @rg -n 'pane name=\"(NVIM|AGENT|REPL / TESTS|DIFF|GIT|AUX)\"' zellij/layouts/dev.kdl >/dev/null
    @rg -n 'dev-diff-pane\.sh' zellij/layouts/dev.kdl >/dev/null
    @bash -n zellij/scripts/dev-diff-pane.sh
    @echo "zellij layout + diff script: OK"

# Run all local static checks without launching interactive apps.
smoke: audit verify-fish verify-layout
    @echo "smoke: OK"
