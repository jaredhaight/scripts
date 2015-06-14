#!/bin/bash

SRC_IP='192.168.13.234'

# get ip address for tap0

TAP0_IP=$(ifconfig tap0 | grep "inet addr" | cut -d ":" -f 2 | cut -d " " -f 1)

#
# delete all existing rules.
#
iptables -F

# Always accept loopback traffic
iptables -v -A INPUT -i lo -j ACCEPT


# Allow established connections, and those not coming from the outside
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allow HTTP in from everyone
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT

# Allow inbound mysql from specific host
iptables -A INPUT -s $SRC_IP -d $TAP0_IP -p tcp --dport 3306 -j ACCEPT

# Deny all
iptables -A INPUT -j DROP
