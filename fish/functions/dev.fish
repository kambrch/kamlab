function dev --description "Attach or create a Zellij session named after the current directory"
    if not type -q zellij
        echo "dev: zellij not found in PATH" >&2
        return 127
    end

    set -l session (basename (pwd))
    if test -z "$session"
        set session "dev"
    end

    # Avoid "attach to resurrect" prompts for exited serialized sessions.
    # Use exact session-name matching (not regex) and strip ANSI colors from list output.
    set -l sessions_raw (zellij list-sessions 2>/dev/null)
    if test -n "$sessions_raw"
        set -l sessions_clean (printf "%s\n" "$sessions_raw" | string replace -ar '\x1b\[[0-9;]*m' '')
        for line in (string split \n -- "$sessions_clean")
            if test -z "$line"
                continue
            end
            if string match -q -- "$session *" "$line"
                and string match -q -- "*EXITED*attach to resurrect*" "$line"
                zellij delete-session "$session" >/dev/null 2>&1
                break
            end
        end
    end

    zellij attach -c "$session"
end
