# Zellij Launch With Directory Picker

This note is the practical version of the idea for the current `kamlab` setup: pick a project directory first, then start Zellij so every pane inherits the correct `cwd`.

## Goal

Open Zellij from a keybind, but choose the starting directory first.

## Recommendation

Use a launcher script that prompts for a directory *before* starting Zellij, then `cd` into that directory and launch Zellij.

This is the reliable approach because pane working directories are set when panes are spawned. A floating prompt inside Zellij appears too late to change the initial `cwd` of panes that already opened.

## Example Launcher Script

Create `~/bin/zellij-pick-dir` (adjust the search roots to match your machine):

```bash
#!/usr/bin/env bash
set -euo pipefail

dir="$(find ~/code ~/work -maxdepth 3 -type d 2>/dev/null | fzf --prompt='Zellij dir> ')" || exit 0
[ -d "$dir" ] || exit 0

cd "$dir"
exec zellij
```

Make it executable:

```bash
chmod +x ~/bin/zellij-pick-dir
```

## Hyprland Keybind Example

```ini
bind = SUPER, Z, exec, kitty -e ~/bin/zellij-pick-dir
```

## Related Files In This Repo

- Fish `dev` helper: `fish/functions/dev.fish`
- DIFF pane script: `zellij/scripts/dev-diff-pane.sh`

Note: `zellij/` is a submodule here, so changes under that directory are versioned in the submodule repository.

## Alternative (Not Recommended)

A bootstrap Zellij session with a transient floating prompt pane could collect a directory and then spawn the real layout, but it is more complex and less reliable than prompting before launch.
