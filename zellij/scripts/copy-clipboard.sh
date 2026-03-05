#!/usr/bin/env sh
set -eu

if command -v wl-copy >/dev/null 2>&1; then
    exec wl-copy
fi

if command -v xclip >/dev/null 2>&1; then
    exec xclip -selection clipboard
fi

if command -v pbcopy >/dev/null 2>&1; then
    exec pbcopy
fi

echo "No clipboard command found (wl-copy/xclip/pbcopy)." >&2
exit 1
