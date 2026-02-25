# patch_refresh.fish - Display the current patch with delta syntax highlighting
# Usage:
#   patch_refresh              # Show current.patch in DIFF pane
#   patch_refresh --help       # Show help
#
# Uses delta --paging=never for non-interactive rendering suitable for Zellij panes.
# Falls back to bat if delta is unavailable, or shows message if no patch exists.

function patch_refresh --description "Render .zellij/patches/current.patch with delta"
    set -l patch_file ".zellij/patches/current.patch"

    # Handle --help
    if set -q argv[1]
        if test "$argv[1]" = "--help"
            echo "Usage: patch_refresh"
            echo ""
            echo "Renders .zellij/patches/current.patch using delta for syntax highlighting."
            echo "Uses --paging=never for non-interactive display in Zellij panes."
            echo ""
            echo "If no patch file exists, displays a message indicating how to create one."
            return 0
        end
    end

    # Keep the DIFF pane readable across repeated refreshes.
    command -q clear; and clear

    # Check if patch file exists
    if not test -f "$patch_file"
        echo "=== No patch file found ==="
        echo "Path: $patch_file"
        echo ""
        echo "To create a patch:"
        echo "  1. Make changes and stage them: git add <files>"
        echo "  2. Generate patch: git diff --cached > $patch_file"
        echo "     Or use: patch_set < file.patch"
        echo ""
        echo "  3. Refresh this view: patch_refresh"
        return 0
    end

    # Check if file is empty
    if not test -s "$patch_file"
        echo "=== Patch file is empty ==="
        echo "Path: $patch_file"
        echo ""
        echo "Add content to the patch file, then run: patch_refresh"
        return 0
    end

    # Render with delta (non-interactive mode)
    # --paging=never prevents less/more pager interference in Zellij panes
    # --line-numbers adds line numbers for reference
    # --syntax-highlighting=git uses git's color configuration
    if command -q delta
        delta --paging=never --line-numbers "$patch_file"
    else if command -q bat
        # Fallback to bat if delta is not available
        echo "=== Note: delta not found, using bat ==="
        bat --style=plain "$patch_file"
    else
        # Plain cat as last resort
        echo "=== Note: neither delta nor bat found, showing raw content ==="
        cat "$patch_file"
    end
end
