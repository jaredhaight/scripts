#! /bin/bash

BASEIP=$(ifconfig eth0 | grep "inet addr" | cut -d ":" -f 2 | cut -d " " -f 1 | awk -F'[.]' '{print $1 "." $2 "." $3 "."}')

i=1

while [ $i -lt 255 ]; do
    ping $BASEIP$i -c 2
    i=$[i+1]
done



