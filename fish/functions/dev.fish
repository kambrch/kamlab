function dev --description "Attach or create a Zellij session named after the current directory"
    if not type -q zellij
        echo "dev: zellij not found in PATH" >&2
        return 127
    end

    set -l session (basename (pwd))
    if test -z "$session"
        set session "dev"
    end

    zellij attach -c "$session"
end
