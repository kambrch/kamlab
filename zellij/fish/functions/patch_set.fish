# patch_set.fish - Create/update the current patch file
# Usage:
#   patch_set < file.patch           # Read from stdin
#   patch_set file.patch             # Read from file argument
#   patch_set                        # Show usage
#
# Creates .zellij/patches/ directory if it doesn't exist.
# Writes to .zellij/patches/current.patch

function patch_set --description "Write patch to .zellij/patches/current.patch"
    set -l patch_dir ".zellij/patches"
    set -l patch_file "$patch_dir/current.patch"

    # Show usage if no arguments and stdin is a tty
    if count $argv >/dev/null 2>&1
        if test (count $argv) -eq 0
            if test -t 0
                echo "Usage: patch_set < file.patch  OR  patch_set file.patch"
                echo ""
                echo "Creates .zellij/patches/current.patch from stdin or file argument."
                return 1
            end
        end
    end

    # Ensure patch directory exists
    if not test -d "$patch_dir"
        mkdir -p "$patch_dir"
        echo "Created patch directory: $patch_dir" >&2
    end

    # Handle file argument or stdin
    if set -q argv[1]
        # File argument provided
        set -l input_file $argv[1]
        if not test -f "$input_file"
            echo "Error: File not found: $input_file" >&2
            return 1
        end
        cp "$input_file" "$patch_file"
        echo "Patch written to: $patch_file (from $input_file)" >&2
    else
        # Read from stdin
        cat > "$patch_file"
        echo "Patch written to: $patch_file (from stdin)" >&2
    end
end
