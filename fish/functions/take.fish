function take --description "Create a directory and enter it"
    if test (count $argv) -ne 1
        echo "Usage: take <directory>" >&2
        return 1
    end

    set -l target $argv[1]

    if test -z "$target"
        echo "Usage: take <directory>" >&2
        return 1
    end

    mkdir -p -- "$target"; or return 1
    cd -- "$target"
end
