#!/usr/bin/env sh

sudo yum clean all
sudo yum update -y
sudo yum upgrade -y
echo "INFO: Checking for large files that can be removed..."
sudo find / -type f -size +300M -exec ls -lh {} \;

echo "ADMIN: You can now cleanup the files that you don't want."
echo ${date}
