function __kamlab_git_prompt_info --description "Return cached git prompt metadata for current directory"
    git rev-parse --is-inside-work-tree >/dev/null 2>&1; or return 0

    set -l branch (git rev-parse --abbrev-ref HEAD 2>/dev/null); or return 0
    if test "$branch" = "HEAD"
        set branch (git rev-parse --short HEAD 2>/dev/null); or return 0
    end

    set -l dirty ""
    git diff --no-ext-diff --quiet --ignore-submodules HEAD -- >/dev/null 2>&1
    or set dirty "*"
    echo "$branch$dirty"
end

function fish_prompt -d "Fallback prompt (starship overrides this when installed)"
    set -l cwd (pwd)
    if test "$cwd" != "$__kamlab_prompt_cache_pwd"
        set -g __kamlab_prompt_cache_pwd "$cwd"
        set -g __kamlab_prompt_cache_git (__kamlab_git_prompt_info)
    end

    printf '%s@%s %s%s%s' $USER $hostname (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
    if test -n "$__kamlab_prompt_cache_git"
        printf ' %s(%s)%s' (set_color yellow) "$__kamlab_prompt_cache_git" (set_color normal)
    end
    printf ' > '
end

if status is-interactive # Commands to run in interactive sessions can go here

    # No greeting
    set fish_greeting

    # Optional Matugen-generated overlays.
    # Recovery switch: set KAMLAB_MATUGEN_DISABLE=1 to ignore generated theme files.
    if test "$KAMLAB_MATUGEN_DISABLE" != "1"; and not test -f ~/.config/kamlab/.matugen-disabled
        if test -f ~/.config/starship-matugen.toml
            set -gx STARSHIP_CONFIG ~/.config/starship-matugen.toml
        end
        if test -f ~/.local/state/quickshell/user/generated/fish/matugen-colors.fish
            source ~/.local/state/quickshell/user/generated/fish/matugen-colors.fish
        end
    end

    # Use starship
    if type -q starship
        starship init fish | source
    end
    if test -f ~/.local/state/quickshell/user/generated/terminal/sequences.txt
        cat ~/.local/state/quickshell/user/generated/terminal/sequences.txt
    end

    # Aliases
    alias clear "printf '\033[2J\033[3J\033[1;1H'" # fix: kitty doesn't clear properly
    alias celar "printf '\033[2J\033[3J\033[1;1H'"
    alias claer "printf '\033[2J\033[3J\033[1;1H'"
    alias ls 'eza --icons'
    alias pamcan pacman
    alias q 'qs -c ii'
    alias lg 'lazygit'
    alias gs 'git status -sb'
    alias gd 'git diff --color=always | delta'
    alias gdc 'git diff --cached --color=always | delta'
    alias gl 'git log --oneline --graph --decorate --all'
    alias ga 'git add -A'
    alias zj 'zellij'
    alias v 'nvim'
    alias k 'kitty @'
    alias c 'claude'
    alias cx 'codex --no-alt-screen'
    alias j 'just'
    alias codex 'codex --no-alt-screen'
    alias claude 'claude'
    
end

function diff --description "Use git diff+delta in repos (no args), otherwise fallback to system diff"
    if test (count $argv) -eq 0
        if git rev-parse --is-inside-work-tree >/dev/null 2>&1
            git diff --color=always | delta
            return $status
        end
    end

    command diff $argv
end

function work --description "Jump to a project (via z when available) and attach/create matching zellij session"
    if set -q ZELLIJ
        return 0
    end

    if test (count $argv) -gt 0
        if functions -q z
            z "$argv[1]"
        else
            cd -- "$argv[1]"
        end
    end

    if not type -q zellij
        echo "work: missing dependency: zellij" >&2
        return 1
    end

    set -l raw_name (basename (pwd) | string replace -ar '[^A-Za-z0-9_.-]' '_')
    set -l session_name (string sub -s 1 -l 48 -- "$raw_name")
    set -l session "wrk_$session_name"
    zellij attach -c -- "$session"
end
