function hs-ssh-scan
    set -l net "192.168.75.0/24"
    if test (count $argv) -ge 1
        set net $argv[1]
    end
    
    echo "🔍 Skanuję SSH w $net"
    echo
    
    nmap -p 22 --open -R -oG - $net | \
                awk '
            /^Host: / && $0 ~ /Ports: 22\/open\// {
                # Obsłuż format: Host: <ip> (<name>) ...
                # albo:          Host: <name> (<ip>) ...
                if (match($0, /^Host: ([^ ]+) \(([^)]+)\)/, a)) {
                    x=a[1]; y=a[2];
                    # jeśli x wygląda jak IPv4 → x=ip, y=name
                    if (x ~ /^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$/) {
                        ip=x; name=y;
                    } else {
                        name=x; ip=y;
                    }
                    printf "🔐 %s (%s)\n", name, ip
                }
            }
        '
end
