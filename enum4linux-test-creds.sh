#!/bin/bash

if [ -z "$3" ]; then
    echo "Usage: $0 <file_with_ips> <username_to_test> <password_to_test>"
    exit 0
fi

echo "Running enum4linux\n"
echo "IP File: $1"
echo "Username: $2"
echo "Password: $3"
echo "\n"

for ip in $(cat $1);do
    enum4linux -u $2 -p $3 $ip
done


