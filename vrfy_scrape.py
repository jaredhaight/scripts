#!/usr/bin/python
import socket
import sys
if len(sys.argv) !=3:
    print "Usage: vrfy.py <host/ip> <username>"
    sys.exit(1)

s=socket.socket(socket.AF_INET, socket.SOCK_STREAM)
connect = s.connect((sys.arg[1], 25))
banner=s.recv(1024)
print banner

s.send('VRFY ' + sys.argv[2] + '\r\n')
result = s.recv(1024)
print result
s.close()
