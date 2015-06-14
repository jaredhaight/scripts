#!/bin/bash
mkdir ~/repos
cd ~/repos
svn checkout svn://svn.code.sf.net/p/laudanum/code/ laudanum-code
git clone https://github.com/LeonardoNve/sslstrip2
git clone https://github.com/danielmiessler/SecLists.git
git clone https://github.com/trustedsec/ptf

