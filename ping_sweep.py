#!/usr/bin/python

import os

base_ip_work = os.popen('ifconfig eth0 | grep "inet addr"').read()
base1, base2, base3, base4 = base_ip_work.split(":")[1].split(".")
base_ip = base1+"."+base2+"."+base3+"."

i=1

while (i < 255):
    os.system("ping -c 1 "+base_ip+str(i))
    i=i+1
