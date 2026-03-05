function fish_prompt -d "Write out the prompt"
    # This shows up as USER@HOST /home/user/ >, with the directory colored
    # $USER and $hostname are set by fish, so you can just use them
    # instead of using `whoami` and `hostname`
    printf '%s@%s %s%s%s > ' $USER $hostname \
        (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
end

if status is-interactive # Commands to run in interactive sessions can go here

    # No greeting
    set fish_greeting

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
    alias gap 'git apply --check .zellij/patches/current.patch'
    alias gap3 'git apply --3way --check .zellij/patches/current.patch'
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
            z $argv[1]
        else
            cd $argv[1]
        end
    end

    set -l session (basename (pwd) | string replace -ar '[^A-Za-z0-9_.-]' '_')
    zellij attach -c $session
end
