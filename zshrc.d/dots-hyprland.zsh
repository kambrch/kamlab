# Use the generated color scheme

if [[ "$KAMLAB_MATUGEN_DISABLE" != "1" ]] && [[ ! -f ~/.config/kamlab/.matugen-disabled ]] && test -f ~/.config/starship-matugen.toml; then
    export STARSHIP_CONFIG=~/.config/starship-matugen.toml
fi

if test -f ~/.local/state/quickshell/user/generated/terminal/sequences.txt; then
    cat ~/.local/state/quickshell/user/generated/terminal/sequences.txt
fi
