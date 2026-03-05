function gwt --description "Create/switch to git worktree for a branch"
    argparse 'r/remote' -- $argv
    or return 1

    if test (count $argv) -ne 1
        echo "Usage: gwt [-r|--remote] <branch>" >&2
        return 1
    end

    set -l branch "$argv[1]"

    git rev-parse --is-inside-work-tree >/dev/null 2>&1
    or begin
        echo "gwt: not inside a git repository" >&2
        return 1
    end

    set -l target "../$branch"
    if test -e "$target"
        echo "gwt: target already exists: $target" >&2
        return 1
    end

    if git show-ref --verify --quiet "refs/heads/$branch"
        git worktree add -- "$target" "$branch"
        or begin
            echo "gwt: failed to add worktree for local branch '$branch'" >&2
            return 1
        end
    else if set -q _flag_remote
        if git show-ref --verify --quiet "refs/remotes/origin/$branch"
            git worktree add -b "$branch" -- "$target" "origin/$branch"
            or begin
                echo "gwt: failed to add worktree from 'origin/$branch'" >&2
                return 1
            end
        else
            echo "gwt: remote branch not found: origin/$branch" >&2
            return 1
        end
    else
        git worktree add -b "$branch" -- "$target"
        or begin
            echo "gwt: failed to create and add branch '$branch'" >&2
            return 1
        end
    end

    cd -- "$target"
end
