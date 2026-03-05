function f --description "Fuzzy-find a file and open in editor"
    for cmd in fd fzf
        if not type -q $cmd
            echo "f: missing dependency: $cmd" >&2
            return 1
        end
    end

    set -l preview_cmd 'if type -q bat; bat --color=always --style=numbers --line-range=:300 -- "{}"; else sed -n "1,300p" -- "{}"; end'
    set -l file (fd --type f --hidden --follow \
        --exclude .git \
        --exclude node_modules \
        --exclude .venv \
        --exclude dist \
        --exclude target \
        . | fzf --preview "$preview_cmd")
    test -n "$file"; or return 0

    set -l editor "$EDITOR"
    test -n "$editor"; or set editor nvim
    command $editor -- "$file"
end
