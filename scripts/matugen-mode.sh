#!/usr/bin/env bash
set -euo pipefail

ROOT="${HOME}/.config/kamlab"
MARKER="${ROOT}/.matugen-disabled"
KITTY_CONF="${ROOT}/kitty/kitty.conf"
ZELLIJ_CONF="${ROOT}/zellij/config.kdl"
SYNC_ZELLIJ="${ROOT}/scripts/sync-zellij-theme.sh"

usage() {
  cat <<'USAGE'
Usage: scripts/matugen-mode.sh <on|off|status>

on     Enable Matugen overlays and remove disable marker.
off    Disable Matugen overlays (recovery mode) and create disable marker.
status Show current mode and managed-line status.
USAGE
}

set_on() {
  rm -f "$MARKER"
  sed -i 's/^# \(globinclude .*MATUGEN_MANAGED\)$/\1/' "$KITTY_CONF"
  sed -i 's/theme "default" \/\/ MATUGEN_MANAGED/theme "matugen" \/\/ MATUGEN_MANAGED/' "$ZELLIJ_CONF"
  if [[ -x "$SYNC_ZELLIJ" ]] && [[ -f "$HOME/.local/state/quickshell/user/generated/colors.json" ]]; then
    "$SYNC_ZELLIJ" || echo "warning: zellij theme sync failed; fallback file remains in use" >&2
  fi
  echo "Matugen mode: ON"
}

set_off() {
  touch "$MARKER"
  sed -i 's/^\(globinclude .*MATUGEN_MANAGED\)$/# \1/' "$KITTY_CONF"
  sed -i 's/theme "matugen" \/\/ MATUGEN_MANAGED/theme "default" \/\/ MATUGEN_MANAGED/' "$ZELLIJ_CONF"
  echo "Matugen mode: OFF"
}

show_status() {
  if [[ -f "$MARKER" ]]; then
    echo "mode: off (marker exists: $MARKER)"
  else
    echo "mode: on (no marker)"
  fi

  echo "kitty line:"
  rg -n "MATUGEN_MANAGED" "$KITTY_CONF" || true
  echo "zellij line:"
  rg -n "MATUGEN_MANAGED" "$ZELLIJ_CONF" || true
  if [[ -f "$ROOT/zellij/themes/matugen.kdl" ]]; then
    echo "zellij theme file:"
    sed -n '1,4p' "$ROOT/zellij/themes/matugen.kdl"
  fi
}

case "${1:-}" in
  on) set_on ;;
  off) set_off ;;
  status) show_status ;;
  *) usage; exit 2 ;;
esac
