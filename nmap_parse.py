#!/bin/python

import sys
from libnmap.parser import NmapParser

if len(sys.argv) !=2:
    print "Usage: nmap_parse.py <nmap_xml_file>"
    sys.exit(1)

try: 
    nmap_report = NmapParser.parse_fromfile(sys.argv[1])
except:
    print "Could not open XML file"
    sys.exit(1)

host_list = list()
for host in nmap_report.hosts:
    if host.status == 'up':
        print "[*] Adding: "+host.ipv4
        host_dict = dict()
        host_ports = ""
        for port, prot in host.get_open_ports():
            host_ports += str(port)+prot+" "
        host_dict[host.ipv4] = host_ports
        host_list.append(host_dict)

for host_data in host_list:
    for host_str, port_str in host_data.iteritems():
        print host_str+"\t"+port_str
