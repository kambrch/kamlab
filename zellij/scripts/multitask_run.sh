#!/usr/bin/env bash
set -euo pipefail

plugin_path="${HOME}/.config/kamlab/zellij/plugins/multitask.wasm"

if [[ ! -f "$plugin_path" ]]; then
  echo "multitask plugin not found: $plugin_path" >&2
  exit 1
fi

# `ccwd` should reflect the cwd of the pane where the keybinding was triggered.
ccwd="$(pwd)"
shell_bin="${SHELL:-/bin/bash}"
plugin_cfg="shell=${shell_bin},ccwd=${ccwd}"

# `multitask_run` will launch the plugin if it isn't running and then open the task menu.
exec zellij action pipe \
  --plugin "file:${plugin_path}" \
  --plugin-configuration "${plugin_cfg}" \
  --floating-plugin true \
  --plugin-title "multitask" \
  --name "multitask_run" \
  -- "."
