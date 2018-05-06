#!/bin/bash

curl -o packer.zip https://releases.hashicorp.com/packer/1.2.3/packer_1.2.3_linux_amd64.zip
unzip packer.zip
mv packer /usr/local/bin
packer version