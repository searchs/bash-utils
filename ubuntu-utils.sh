#! usr/bin/bash

echo "Machine running machines"
sudo apt update -y
sudo apt upgrade -y

sudo apt autoremove -y
echo  "Checking for LARGE files"
du -cha --max-depth=1 /var/ | grep -E "M|G"
du -cha --max-depth=1 / | grep -E "M|G"


df -h

echo "Utils done"
