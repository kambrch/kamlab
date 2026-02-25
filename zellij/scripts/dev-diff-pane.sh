#!/usr/bin/env bash
set -euo pipefail

refresh_secs="${DEV_DIFF_PANE_REFRESH_SECS:-1}"
mode="${DEV_DIFF_PANE_MODE:-compact}" # compact|full
last_snapshot=""

render_not_repo() {
  clear
  printf 'DIFF pane (refresh %ss)\n' "$refresh_secs"
  printf 'Status: not inside a git repository\n'
  printf 'cwd: %s\n' "$(pwd)"
}

render_diff() {
  clear
  printf 'DIFF pane (refresh %ss)\n' "$refresh_secs"
  printf 'repo: %s\n' "$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
  printf 'mode: %s\n' "$mode"
  printf 'time: %s\n\n' "$(date '+%H:%M:%S')"

  if git diff --quiet --ignore-submodules -- && git diff --cached --quiet --ignore-submodules --; then
    printf 'No changed files\n'
    return 0
  fi

  printf '[unstaged]\n'
  git --no-pager diff --stat || true
  printf '\n'

  if [[ "$mode" != "full" ]]; then
    printf 'Compact view (stats-only).\n'
    printf 'Changed files (unstaged):\n'
    git --no-pager diff --name-status || true
    printf '\nOpen full diff in AUX: git diff --color=always | %s\n' "$(command -v delta >/dev/null 2>&1 && echo 'delta' || echo 'less -R')"
  else
    local unstaged_raw
    unstaged_raw="$(git --no-pager diff --no-color || true)"
    if command -v delta >/dev/null 2>&1; then
      printf '%s' "$unstaged_raw" | delta --paging=never || true
    else
      git --no-pager diff --color=always || true
    fi
  fi

  if ! git diff --cached --quiet --ignore-submodules --; then
    printf '\n[staged]\n'
    git --no-pager diff --cached --stat || true
    printf '\n'
    if [[ "$mode" != "full" ]]; then
      printf 'Compact view (stats-only) for staged changes.\n'
      printf 'Changed files (staged):\n'
      git --no-pager diff --cached --name-status || true
      printf '\nOpen full staged diff in AUX: git diff --cached --color=always | %s\n' "$(command -v delta >/dev/null 2>&1 && echo 'delta' || echo 'less -R')"
    else
      local staged_raw
      staged_raw="$(git --no-pager diff --cached --no-color || true)"
      if command -v delta >/dev/null 2>&1; then
        printf '%s' "$staged_raw" | delta --paging=never || true
      else
        git --no-pager diff --cached --color=always || true
      fi
    fi
  fi
}

while true; do
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    # Redraw only when meaningful diff state changes so pane scrollback remains usable.
    # Include status + stat summaries so edits to already-modified files still trigger updates.
    snapshot="$(
      {
        printf '[status]\n'
        git status --porcelain=v1 --untracked-files=all 2>/dev/null || true
        printf '\n[unstaged-stat]\n'
        git --no-pager diff --stat --ignore-submodules -- 2>/dev/null || true
        printf '\n[staged-stat]\n'
        git --no-pager diff --cached --stat --ignore-submodules -- 2>/dev/null || true
      }
    )"
    if [[ "$snapshot" != "$last_snapshot" ]]; then
      last_snapshot="$snapshot"
      render_diff
    fi
  else
    if [[ "$last_snapshot" != "__not_repo__" ]]; then
      last_snapshot="__not_repo__"
      render_not_repo
    fi
  fi
  sleep "$refresh_secs"
done
