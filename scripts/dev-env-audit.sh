#!/usr/bin/env bash
set -euo pipefail

required_tools=(
  zellij
  direnv
  just
  zoxide
  ghq
  rg
  fd
  fzf
  lazygit
)

optional_tools=(
  delta
  watch
  uv
  mise
  juliaup
)

detect_os() {
  local os="unknown"
  if [[ -f /etc/os-release ]]; then
    os="$(. /etc/os-release; printf '%s' "${ID:-unknown}")"
  else
    os="$(uname -s 2>/dev/null || printf 'unknown')"
  fi
  printf '%s' "$os"
}

detect_pkg_manager() {
  local pm
  for pm in pacman apt dnf yum zypper brew apk; do
    if command -v "$pm" >/dev/null 2>&1; then
      printf '%s' "$pm"
      return 0
    fi
  done
  printf 'unknown'
}

check_tools() {
  local label="$1"
  shift
  local present=()
  local missing=()
  local t
  for t in "$@"; do
    if command -v "$t" >/dev/null 2>&1; then
      present+=("$t")
    else
      missing+=("$t")
    fi
  done

  printf -- "- %s present: " "$label"
  if ((${#present[@]})); then
    printf '%s' "${present[0]}"
    for t in "${present[@]:1}"; do
      printf ', %s' "$t"
    done
    printf '\n'
  else
    printf '(none)\n'
  fi

  printf -- "- %s missing: " "$label"
  if ((${#missing[@]})); then
    printf '%s' "${missing[0]}"
    for t in "${missing[@]:1}"; do
      printf ', %s' "$t"
    done
    printf '\n'
  else
    printf '(none)\n'
  fi
}

printf -- "- OS: %s\n" "$(detect_os)"
printf -- "- Package manager: %s\n" "$(detect_pkg_manager)"
check_tools "required" "${required_tools[@]}"
check_tools "optional" "${optional_tools[@]}"
