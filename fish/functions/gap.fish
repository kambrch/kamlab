function gap --description "Check whether current patch applies cleanly"
    set -l patch ".zellij/patches/current.patch"

    if not git rev-parse --is-inside-work-tree >/dev/null 2>&1
        echo "gap: not inside a git repository" >&2
        return 1
    end

    if not test -f "$patch"
        echo "gap: patch file not found: $patch" >&2
        return 1
    end

    git apply --check -- "$patch"
    or begin
        echo "gap: patch check failed for $patch" >&2
        return 1
    end
end
