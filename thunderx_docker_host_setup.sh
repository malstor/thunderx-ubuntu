#!/bin/bash
# notes from setup for legacy kernel distro w/ thunderx/armv8 docker host
sudo apt-mark hold linux-image-generic linux-headers-generic 
sudo apt update
sudo apt install python3.8 python3.8-distutils python3.8-dev libxml2-dev libxslt-dev
wget https://bootstrap.pypa.io/get-pip.py
sudo python3.8 get-pip.py
sudo pip3.8 install docker-compose
sudo cp cpt8x-mc-ae.out, cpt8x-mc-se.out /lib/firmware 
