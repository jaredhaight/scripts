if [ -z "$1" ]; then
    echo "Usage: $0 <file_with_ips>"
        exit 0
    fi

    echo "Running enum4linux\n"
    echo "IP File: $1"
    echo "\n"

    for ip in $(cat $1);do
        echo "Scanning $ip..."
        enum4linux $ip > $ip"_enum4linux" &
    done


