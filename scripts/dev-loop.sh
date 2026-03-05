#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: scripts/dev-loop.sh <test|todo|diff>

Subcommands:
  test   Event-driven test loop (Python/Julia routed by latest changed file type)
  todo   Event-driven TODO/FIXME -> nvim loop
  diff   Event-driven compact git diff loop
USAGE
}

require_cmd() {
  local cmd="$1"
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "dev-loop: missing required command: $cmd" >&2
    exit 1
  fi
}

repo_root() {
  git rev-parse --show-toplevel 2>/dev/null || pwd
}

latest_changed_source_file() {
  find . -type f \( \
    -name '*.py' -o -name '*.jl' -o \
    -name 'pyproject.toml' -o -name 'poetry.lock' -o \
    -name 'Project.toml' -o -name 'Manifest.toml' -o \
    -name '*.yaml' -o -name '*.yml' \
  \) -printf '%T@ %p\n' 2>/dev/null | sort -nr | head -n1 | cut -d' ' -f2-
}

run_test_once() {
  local latest
  latest="$(latest_changed_source_file || true)"

  echo "[dev-loop:test] time: $(date '+%H:%M:%S')"
  echo "[dev-loop:test] latest: ${latest:-<unknown>}"

  if [[ "$latest" == *.jl || "$latest" == */Project.toml || "$latest" == */Manifest.toml ]]; then
    if command -v julia >/dev/null 2>&1; then
      echo "[dev-loop:test] runner: julia"
      julia --project -e 'using Pkg; Pkg.test()'
    else
      echo "[dev-loop:test] julia not found; skipping"
    fi
  else
    if command -v pytest >/dev/null 2>&1; then
      echo "[dev-loop:test] runner: pytest"
      pytest -q
    else
      echo "[dev-loop:test] pytest not found; skipping"
    fi
  fi
}

run_test_loop() {
  require_cmd fd
  require_cmd entr

  local root
  root="$(repo_root)"
  cd "$root"

  local watched
  watched="$(fd -t f -e py -e jl -e toml -e yaml -e yml . || true)"
  if [[ -z "$watched" ]]; then
    echo "dev-loop(test): no matching source/config files under $root" >&2
    exit 1
  fi

  printf '%s\n' "$watched" | entr -c "$0" __run-test-once
}

run_todo_loop() {
  require_cmd rg
  require_cmd entr
  require_cmd nvim

  local root
  root="$(repo_root)"
  cd "$root"

  local matches
  matches="$(rg -l 'TODO|FIXME' . || true)"
  if [[ -z "$matches" ]]; then
    echo "dev-loop(todo): no TODO/FIXME matches yet under $root" >&2
    echo "dev-loop(todo): add a TODO/FIXME marker first, then rerun" >&2
    exit 1
  fi

  printf '%s\n' "$matches" | entr -c nvim
}

run_diff_once() {
  echo "[dev-loop:diff] time: $(date '+%H:%M:%S')"
  if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "[dev-loop:diff] not inside a git repository"
    exit 0
  fi

  echo "repo: $(git rev-parse --show-toplevel 2>/dev/null || pwd)"
  echo
  echo "[unstaged]"
  git --no-pager diff --stat || true
  echo
  echo "[staged]"
  git --no-pager diff --cached --stat || true
  echo
  echo "[changed files]"
  git --no-pager diff --name-status || true
  git --no-pager diff --cached --name-status || true
}

run_diff_loop() {
  require_cmd fd
  require_cmd entr
  require_cmd git

  local root
  root="$(repo_root)"
  cd "$root"

  local watched
  watched="$(fd -H -t f -E .git . || true)"
  if [[ -z "$watched" ]]; then
    echo "dev-loop(diff): no files to watch under $root" >&2
    exit 1
  fi

  printf '%s\n' "$watched" | entr -c "$0" __run-diff-once
}

case "${1:-}" in
  test)
    run_test_loop
    ;;
  todo)
    run_todo_loop
    ;;
  diff)
    run_diff_loop
    ;;
  __run-test-once)
    run_test_once
    ;;
  __run-diff-once)
    run_diff_once
    ;;
  *)
    usage
    exit 2
    ;;
esac
