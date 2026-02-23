function dev --description "Attach or create a Zellij session named after the current directory"
    if not type -q zellij
        echo "dev: zellij not found in PATH" >&2
        return 127
    end

    set -l session (basename (pwd))
    if test -z "$session"
        set session "dev"
    end

    # Avoid "attach to resurrect" command prompts for exited serialized sessions.
    set -l sessions_out (zellij list-sessions 2>/dev/null)
    if string match -qr "^$session\\b.*EXITED\\s+-\\s+attach to resurrect" -- $sessions_out
        zellij delete-session "$session" >/dev/null 2>&1
    end

    zellij attach -c "$session"
end
