function gap3 --description "Check whether current patch applies cleanly with 3-way merge"
    set -l patch ".zellij/patches/current.patch"

    if not git rev-parse --is-inside-work-tree >/dev/null 2>&1
        echo "gap3: not inside a git repository" >&2
        return 1
    end

    if not test -f "$patch"
        echo "gap3: patch file not found: $patch" >&2
        return 1
    end

    git apply --3way --check -- "$patch"
    or begin
        echo "gap3: 3-way patch check failed for $patch" >&2
        return 1
    end
end
