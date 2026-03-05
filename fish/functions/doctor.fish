function doctor --description "Run quick Fish/Zellij config and dependency health checks"
    set -l failed 0

    set -l cfg_root "$HOME/.config/kamlab"
    set -l fish_cfg "$cfg_root/fish/config.fish"
    set -l zellij_cfg "$cfg_root/zellij/config.kdl"

    echo "[doctor] fish syntax: $fish_cfg"
    fish -n "$fish_cfg"
    or set failed 1

    echo "[doctor] zellij config: $zellij_cfg"
    zellij -c "$zellij_cfg" setup --check >/dev/null
    or set failed 1

    for cmd in git zellij fd fzf delta
        if type -q $cmd
            echo "[doctor] ok: $cmd"
        else
            echo "[doctor] missing: $cmd" >&2
            set failed 1
        end
    end

    if type -q bat
        echo "[doctor] ok: bat"
    else
        echo "[doctor] missing (optional): bat" >&2
    end

    if test $failed -eq 0
        echo "[doctor] healthy"
    else
        echo "[doctor] issues detected" >&2
        return 1
    end
end
