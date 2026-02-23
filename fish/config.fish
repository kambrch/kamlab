# Editor defaults
set -gx EDITOR nvim
set -gx VISUAL nvim

if status is-interactive
    # No greeting
    set -g fish_greeting ""

    # Prompt (Starship) - always load as requested
    if type -q starship
        starship init fish | source
    end

    # Lazy-load zoxide on first use
    function __init_zoxide --on-event fish_prompt
        if not set -q __zoxide_loaded
            if type -q zoxide
                zoxide init fish | source
                set -g __zoxide_loaded true
            end
            functions -e __init_zoxide  # Remove this function after loading
        end
    end

    # Auto-load direnv on first use
    function __init_direnv --on-event fish_prompt
        if not set -q __direnv_loaded
            if type -q direnv
                direnv hook fish | source
                set -g __direnv_loaded true
            end
            functions -e __init_direnv  # Remove this function after loading
        end
    end

    # Quickshell terminal sequences (if present)
    if test -f ~/.local/state/quickshell/user/generated/terminal/sequences.txt
        command cat -- ~/.local/state/quickshell/user/generated/terminal/sequences.txt
    end

    # Command not found helper hook
    if test -r /usr/share/doc/pkgfile/command-not-found.fish
        source /usr/share/doc/pkgfile/command-not-found.fish
    end

    ### ---------- helpers ----------
    function __has --argument-names cmd
        type -q $cmd
    end

    # Choose best available tools (used by abbr below)
    if __has bat
        set -g __CAT bat
    else
        set -g __CAT cat
    end

    if __has rg
        set -g __GREP rg
    else
        set -g __GREP grep
    end

    ### ---------- your existing abbr ----------
    abbr -a pamcan pacman
    abbr -a q 'qs -c ii'

    ### ---------- redefine ls (as requested) ----------
    # Define ls/l/ll/la/lt/lS consistently using the best available backend.
    if __has eza
        abbr -a ls 'eza --icons'
        abbr -a l  'eza --icons'
        abbr -a ll 'eza --icons -alF'
        abbr -a la 'eza --icons -A'
        abbr -a lt 'eza --icons -alF --sort=modified'
        abbr -a lS 'eza --icons -alF --sort=size'
    else if __has exa
        abbr -a ls 'exa'
        abbr -a l  'exa'
        abbr -a ll 'exa -alF'
        abbr -a la 'exa -A'
        abbr -a lt 'exa -alF --sort=modified'
        abbr -a lS 'exa -alF --sort=size'
    else
        # GNU ls fallback (Arch)
        abbr -a ls 'ls --color=auto'
        abbr -a l  'ls --color=auto'
        abbr -a ll 'ls --color=auto -alF'
        abbr -a la 'ls --color=auto -A'
        abbr -a lt 'ls --color=auto -alFht'
        abbr -a lS 'ls --color=auto -alFhS'
    end

    ### ---------- navigation ----------
    abbr -a .. 'cd ..'
    abbr -a ... 'cd ../..'
    abbr -a .... 'cd ../../..'
    abbr -a ..... 'cd ../../../..'
    abbr -a - 'cd -'
    abbr -a c 'clear'
    abbr -a ~ 'cd ~'

    # Quick dirs (customize)
    abbr -a dl 'cd ~/Downloads'
    abbr -a dt 'cd ~/Desktop'
    abbr -a doc 'cd ~/Documents'
    abbr -a proj 'cd ~/Projects'

    ### ---------- files / viewing ----------
    abbr -a cp 'cp -iv'
    abbr -a mv 'mv -iv'
    abbr -a rm 'rm -Iv'
    abbr -a ln 'ln -iv'
    abbr -a md 'mkdir -p'

    abbr -a cat "$__CAT"
    abbr -a less 'less -R'
    abbr -a h 'history'
    abbr -a path 'printf "%s\n" $PATH'
    abbr -a head 'head -n 50'
    abbr -a tailf 'tail -f'
    if __has tree
        abbr -a tree 'tree -C'
    end

    ### ---------- search / text ----------
    if __has rg
        abbr -a rg  'rg --smart-case'
        abbr -a rgi 'rg -i'
        abbr -a rgl 'rg -n --hidden --follow'
    else
        abbr -a rg 'grep -R --color=auto'
    end
    abbr -a gi "$__GREP -i"
    abbr -a gr "$__GREP -R"

    if __has fd
        abbr -a f  'fd'
        abbr -a fa 'fd -HI'
    else
        abbr -a f 'find . -name'
    end

    if __has jq
        abbr -a jqq 'jq .'
    end
    if __has yq
        abbr -a yqq 'yq'
    end

    ### ---------- disk / memory / processes ----------
    abbr -a dfh 'df -hT'
    abbr -a duh 'du -h'
    abbr -a dus 'du -sh * 2>/dev/null | sort -h'
    abbr -a free 'free -h'
    abbr -a psa 'ps auxf'
    if __has htop
        abbr -a top 'htop'
    end
    abbr -a psg "ps aux | $__GREP -i"
    if __has lsof
        abbr -a lsofi 'lsof -i'
    end

    ### ---------- networking ----------
    if __has ip
        abbr -a ip 'ip -c'
        abbr -a ipa 'ip -c a'
        abbr -a ipr 'ip -c r'
    end
    if __has ss
        abbr -a ports 'ss -tulpn'
    end
    abbr -a pingg 'ping -c 5'
    abbr -a curlh 'curl -I'
    abbr -a curlv 'curl -v'
    if __has dig
        abbr -a dns 'dig +short'
    end

    ### ---------- systemd / logs ----------
    if __has systemctl
        abbr -a sc 'systemctl'
        abbr -a scu 'systemctl --user'
        abbr -a sct 'systemctl status'
        abbr -a sctu 'systemctl --user status'
        abbr -a sre 'systemctl restart'
        abbr -a sta 'systemctl start'
        abbr -a sto 'systemctl stop'
        abbr -a en 'systemctl enable'
        abbr -a dis 'systemctl disable'
    end
    if __has journalctl
        abbr -a jc 'journalctl -xe'
        abbr -a jcu 'journalctl --user -xe'
        abbr -a jcf 'journalctl -f'
        abbr -a jcb 'journalctl -b'
    end

    ### ---------- pacman (Arch) ----------
    if __has pacman
        abbr -a pms 'pacman -Ss'
        abbr -a pmi 'sudo pacman -S'
        abbr -a pmu 'sudo pacman -Syu'
        abbr -a pmr 'sudo pacman -Rns'
        abbr -a pmq 'pacman -Qi'
        abbr -a pmql 'pacman -Ql'
    end
    if __has yay
        abbr -a yays 'yay -Ss'
        abbr -a yayi 'yay -S'
        abbr -a yayu 'yay -Syu'
        abbr -a yayr 'yay -Rns'
    end

    ### ---------- git ----------
    if __has git
        abbr -a g 'git'
        abbr -a ga 'git add'
        abbr -a gaa 'git add -A'
        abbr -a gb 'git branch'
        abbr -a gba 'git branch -a'
        abbr -a gbd 'git branch -d'
        abbr -a gbD 'git branch -D'
        abbr -a gco 'git checkout'
        abbr -a gcb 'git checkout -b'
        abbr -a gs 'git status'
        abbr -a gst 'git status -sb'
        abbr -a gd 'git diff'
        abbr -a gds 'git diff --staged'
        abbr -a gl 'git log --oneline --decorate --graph --all'
        abbr -a gp 'git push'
        abbr -a gpf 'git push --force-with-lease'
        abbr -a gpl 'git pull --rebase'
        abbr -a gcl 'git clone'
        abbr -a gcm 'git commit -m'
        abbr -a gca 'git commit --amend'
        abbr -a gsw 'git switch'
        abbr -a gswc 'git switch -c'
        abbr -a gsta 'git stash push'
        abbr -a gstp 'git stash pop'
        
        # Better-commits integration
        abbr -a bc 'better-commits'
        abbr -a bb 'better-branch'
    end

    ### ---------- containers ----------
    if __has docker
        abbr -a d 'docker'
        abbr -a dps 'docker ps'
        abbr -a dpsa 'docker ps -a'
        abbr -a di 'docker images'
        abbr -a drm 'docker rm'
        abbr -a drmi 'docker rmi'
        abbr -a dlog 'docker logs -f'
        abbr -a dex 'docker exec -it'
        abbr -a dcu 'docker compose up -d'
        abbr -a dcd 'docker compose down'
        abbr -a dcl 'docker compose logs -f'
    end

    ### ---------- python / dev ----------
    if __has python3
        abbr -a py 'python3'
    end
    if __has pip
        abbr -a pipi 'pip install'
        abbr -a pipu 'pip install -U'
    end
    if __has uv
        abbr -a uvi 'uv pip install'
        abbr -a uvr 'uv run'
    end
    if __has poetry
        abbr -a poe 'poetry'
        abbr -a poi 'poetry install'
        abbr -a por 'poetry run'
    end
    if __has make
        abbr -a mk 'make'
    end

    ### ---------- ssh / rsync ----------
    abbr -a sshc 'ssh -o ControlMaster=auto -o ControlPersist=10m -o ControlPath=~/.ssh/cm-%r@%h:%p'
    abbr -a rsy 'rsync -avh --progress'
    abbr -a rsyx 'rsync -avh --progress --delete'

    ### ---------- plugin configurations ----------
    # Sponge settings
    set -U sponge_delay 5
    set -U sponge_regex_patterns "rm -rf.*" "pamac.*-R.*" "docker.*rm.*"
    
    # Done notification settings
    set -U __done_min_cmd_duration 8000
    set -U __done_notify_sound 1
    
    # FZF settings
    set -U FZF_LEGACY_KEYBINDINGS 0

    ### ---------- functions ----------
    function please --description "Rerun last command with sudo"
        if test (count $history) -gt 0
            eval sudo $history[1]
        end
    end

    function mkcd --description "mkdir -p and cd into it"
        mkdir -p $argv; and cd $argv[1]
    end
    
    ### ---------- plugin toggles ----------
    # Function to toggle autopair on/off if needed
    function toggle_autopair
        if set -q autopair_left[1]
            set -l i
            for i in (seq (count $autopair_left))
                bind --erase $autopair_left[$i] $autopair_right[$i]
            end
            set -e autopair_left autopair_right autopair_pairs
            echo "Autopair disabled"
        else
            source (dirname (status -f))/conf.d/autopair.fish
            echo "Autopair enabled"
        end
    end
    
    # Function to check for key binding conflicts
    function check_key_bindings
        echo "Current key bindings for special characters:"
        for key in \( \[ \{ \" \' \. \! \$ \*
            set bindings (bind -k $key 2>/dev/null; or bind $key 2>/dev/null)
            if test -n "$bindings"
                echo "$key: $bindings"
            end
        end
    end
    
    ### ---------- error handling ----------
    # Check if plugins loaded correctly
    function check_plugin_status --on-event fish_startup
        set -l missing_plugins ""
        
        # Check for expected plugin functions
        if not functions -q _fzf_search_history
            set missing_plugins $missing_plugins "fzf"
        end
        
        if not functions -q __done_ended
            set missing_plugins $missing_plugins "done"
        end
        
        if not functions -q _sponge_on_postexec
            set missing_plugins $missing_plugins "sponge"
        end
        
        if test -n "$missing_plugins"
            echo "Warning: The following plugins may not be loaded correctly: $missing_plugins"
            echo "Please run: fisher update"
        end
    end
end

