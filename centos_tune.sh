#!/usr/bin/env sh

sudo yum clean all
sudo yum update -y
sudo yum upgrade -y
echo -e "\INFO:  Cleaning old kernels and unnecessary packages on system...\n"

sudo package-cleanup -q --leaves | xargs -r -l1 yum -y remove
sudo package-cleanup --oldkernel --count=2

echo -e "\nINFO: Checking for large files that can be removed...\n"
sudo find / -type f -size +300M -exec ls -lh {} \;

echo "ADMIN: You can now cleanup the files that you don't want."
echo $(date)
