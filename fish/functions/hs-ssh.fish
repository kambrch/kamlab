function hs-ssh
    set -l net "192.168.75.0/24"
    if test (count $argv) -ge 1
        set net $argv[1]
    end
    
    set -l rows (nmap -p 22 --open -R -oG - $net | \
                    awk '
            /^Host: / && $0 ~ /Ports: 22\/open\// {
                if (match($0, /^Host: ([^ ]+) \(([^)]+)\)/, a)) {
                    x=a[1]; y=a[2];
                    if (x ~ /^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$/) { ip=x; name=y; }
                    else { name=x; ip=y; }
                    printf "%s\t%s\n", name, ip
                }
            }
        ')
    
    if test (count $rows) -eq 0
        echo "Brak hostów z otwartym SSH w $net"
        return 1
    end
    
    echo "Hosty z SSH w $net:"
    for i in (seq (count $rows))
        set -l parts (string split \t -- $rows[$i])
        set -l name $parts[1]
        set -l ip   $parts[2]
        printf "%2d) %-40s %s\n" $i $name $ip
    end
    
    echo
    read -P "Wybierz numer hosta (ENTER=anuluj): " idx
    if test -z "$idx"
        return 0
    end
    
    if not string match -qr '^[0-9]+$' -- $idx
        echo "To nie jest numer."
        return 1
    end
    
    if test $idx -lt 1 -o $idx -gt (count $rows)
        echo "Poza zakresem."
        return 1
    end
    
    set -l sel (string split \t -- $rows[$idx])
    set -l name $sel[1]
    set -l ip   $sel[2]
    
    echo "Łączę: $name ($ip)"
    ssh $name
end
