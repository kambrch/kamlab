if not status is-interactive
    exit
end

function __ssh_agent_restore_from_env_file -a env_file
    if not test -f "$env_file"
        return 1
    end

    set -l sock_line (string match -r '^SSH_AUTH_SOCK=.*' -- (cat "$env_file"))
    set -l pid_line (string match -r '^SSH_AGENT_PID=.*' -- (cat "$env_file"))

    if test -z "$sock_line"; or test -z "$pid_line"
        return 1
    end

    set -l restored_sock (string replace -r '^SSH_AUTH_SOCK=([^;]+);.*$' '$1' -- "$sock_line")
    set -l restored_pid (string replace -r '^SSH_AGENT_PID=([^;]+);.*$' '$1' -- "$pid_line")

    if test -n "$restored_sock"; and test -n "$restored_pid"
        set -gx SSH_AUTH_SOCK "$restored_sock"
        set -gx SSH_AGENT_PID "$restored_pid"
        return 0
    end

    return 1
end

function __ssh_agent_start_without_bass -a env_file
    set -l agent_output (ssh-agent -c)
    set -l sock_line (string match -r '^setenv SSH_AUTH_SOCK [^;]+;' -- (string split \n -- "$agent_output"))
    set -l pid_line (string match -r '^setenv SSH_AGENT_PID [^;]+;' -- (string split \n -- "$agent_output"))

    if test -z "$sock_line"; or test -z "$pid_line"
        return 1
    end

    set -l new_sock (string replace -r '^setenv SSH_AUTH_SOCK ([^;]+);$' '$1' -- "$sock_line")
    set -l new_pid (string replace -r '^setenv SSH_AGENT_PID ([^;]+);$' '$1' -- "$pid_line")

    if test -z "$new_sock"; or test -z "$new_pid"
        return 1
    end

    set -gx SSH_AUTH_SOCK "$new_sock"
    set -gx SSH_AGENT_PID "$new_pid"

    # Keep compatibility with existing env-file restore path.
    command sh -c 'umask 077; ssh-agent -s > "$1"' sh "$env_file"
    return 0
end

function __ssh_agent_socket_ok
    if set -q SSH_AUTH_SOCK
        test -S "$SSH_AUTH_SOCK"
        return $status
    end
    return 1
end

function __ssh_agent_has_identities
    ssh-add -l >/dev/null 2>&1
    # ssh-add exit codes:
    # 0 = identities present, 1 = agent reachable but no identities, 2 = no agent
    test $status -eq 0
end

set -l __ssh_agent_env_file "$HOME/.ssh/agent.env"
set -l __systemd_ssh_agent_socket ""
if test -n "$XDG_RUNTIME_DIR"
    set __systemd_ssh_agent_socket "$XDG_RUNTIME_DIR/ssh-agent.socket"
end

# Prefer a systemd-managed user ssh-agent socket if present.
if test -n "$__systemd_ssh_agent_socket"
    set -gx SSH_AUTH_SOCK "$__systemd_ssh_agent_socket"
end

# If the systemd socket path is configured but missing, try to start the user service once.
if test -n "$__systemd_ssh_agent_socket"
    if not __ssh_agent_socket_ok
        if type -q systemctl
            systemctl --user start ssh-agent.service >/dev/null 2>&1
        end
    end
end

# Try to restore a previously started agent if current shell has no valid socket.
if not __ssh_agent_socket_ok
    if test -f "$__ssh_agent_env_file"
        if type -q bass
            bass source "$__ssh_agent_env_file" >/dev/null 2>&1
        else
            __ssh_agent_restore_from_env_file "$__ssh_agent_env_file" >/dev/null 2>&1
        end
    end
end

# Start a new agent if needed and persist its environment for future shells.
if not __ssh_agent_socket_ok
    if type -q ssh-agent
        if type -q bass
            command sh -c 'umask 077; ssh-agent -s > "$1"' sh "$__ssh_agent_env_file"
            bass source "$__ssh_agent_env_file" >/dev/null 2>&1
        else
            __ssh_agent_start_without_bass "$__ssh_agent_env_file" >/dev/null 2>&1
        end
    end
end

# Try to load the default GitHub key once per shell session (prompts for passphrase if needed).
if not set -q __ssh_add_attempted
    set -g __ssh_add_attempted 1
    if __ssh_agent_socket_ok
        if not __ssh_agent_has_identities
            if test -f "$HOME/.ssh/id_ed25519"
                if test -t 0; and test -r /dev/tty
                    ssh-add "$HOME/.ssh/id_ed25519" </dev/tty >/dev/null 2>&1
                end
            end
        end
    end
end
