# patch_apply.fish - Apply the current patch with explicit confirmation
# Usage:
#   patch_apply              # Apply current.patch after y/N confirmation
#   patch_apply --force      # Apply without confirmation
#   patch_apply --help       # Show help
#
# Uses `git apply` (working tree only, safer than --index).
# Requires explicit confirmation to prevent accidental changes.

function patch_apply --description "Apply .zellij/patches/current.patch with confirmation"
    set -l patch_file ".zellij/patches/current.patch"
    set -l force_mode false

    # Parse arguments
    while set -q argv[1]
        switch $argv[1]
            case "--help"
                echo "Usage: patch_apply [--force]"
                echo ""
                echo "Applies .zellij/patches/current.patch using git apply."
                echo ""
                echo "Options:"
                echo "  --force    Skip confirmation prompt"
                echo "  --help     Show this help"
                echo ""
                echo "Safety:"
                echo "  - Uses 'git apply' (working tree only, not staged)"
                echo "  - Requires explicit y/N confirmation by default"
                echo "  - Run 'git status' after to review changes"
                return 0
            case "--force"
                set force_mode true
                set -e argv[1]
            case "*"
                echo "Unknown option: $argv[1]" >&2
                echo "Use --help for usage information." >&2
                return 1
        end
    end

    # Check if patch file exists
    if not test -f "$patch_file"
        echo "Error: No patch file found at: $patch_file" >&2
        echo "" >&2
        echo "Create a patch first using:" >&2
        echo "  patch_set < file.patch" >&2
        echo "  OR" >&2
        echo "  git diff --cached > $patch_file" >&2
        return 1
    end

    # Check if file is empty
    if not test -s "$patch_file"
        echo "Error: Patch file is empty: $patch_file" >&2
        return 1
    end

    # Confirm unless --force is used
    if not $force_mode
        echo "=== Patch to apply ==="
        echo "File: $patch_file"
        echo ""
        
        # Show patch summary (first few lines)
        echo "--- Preview (first 10 lines) ---"
        head -n 10 "$patch_file"
        echo "---"
        echo ""
        
        # Ask for confirmation
        read -n 1 -p "Apply this patch? (y/N): " confirm
        echo ""  # Newline after single-char read
        
        if test "$confirm" != "y" -a "$confirm" != "Y"
            echo "Patch application cancelled."
            return 0
        end
    end

    # Apply the patch using git apply (working tree only)
    # Not using --index to keep changes in working tree for review before staging
    echo "Applying patch..."
    if git apply "$patch_file"
        echo ""
        echo "✓ Patch applied successfully!"
        echo ""
        echo "Next steps:"
        echo "  git status          # Review changes"
        echo "  git diff            # See full diff"
        echo "  git add <files>     # Stage when ready"
        echo ""
        echo "To undo: git checkout -- <files>  OR  git apply -R $patch_file"
    else
        echo ""
        echo "✗ Patch application failed!" >&2
        echo "" >&2
        echo "Possible reasons:" >&2
        echo "  - Patch doesn't match current code state" >&2
        echo "  - Files have been modified since patch was created" >&2
        echo "  - Patch format is invalid" >&2
        echo "" >&2
        echo "Try:" >&2
        echo "  git apply --check $patch_file   # Check without applying" >&2
        echo "  git apply --3way $patch_file    # Attempt 3-way merge" >&2
        return 1
    end
end
