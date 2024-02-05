#!/bin/bash
#
#   ___          ___      _                
#  /___\_ __    / __\___ | |__   ___ _ __  
# //  // '__|  / /  / _ \| '_ \ / _ \ '_ \ 
#/ \_//| |    / /__| (_) | | | |  __/ | | |
#\___/ |_|    \____/\___/|_| |_|\___|_| |_|
#
# Script Name: create-cache.sh
# Description: Script for setting up a caching server with internet connectivity.
# Author: Or Cohen
# Role: SE in EMEA for Carbon Black

#yum-utils
# Create /tmp/cb/yum-utils directory if it doesn't exist
mkdir -p /tmp/cb/yum-utils

# Install yum-utils if not already installed
if ! command -v yumdownloader &> /dev/null; then
# Download yum-utils to /tmp/cb/yum-utils
# Specify the download directory
sudo yum install --downloadonly --downloaddir="/tmp/cb/yum-utils" yum-utils -y
rpm -ivh /tmp/cb/yum-utils/*.rpm
fi
#createrepo
# Create /tmp/cb/createrepo directory if it doesn't exist
mkdir -p /tmp/cb/createrepo
# Download createrepo to /tmp/cb/createrepo
sudo yum install --downloadonly --downloaddir="/tmp/cb/createrepo" createrepo -y

# CB Enterprise:
# Download the main package to /tmp/cb with --nogpgcheck
sudo yumdownloader --resolve --destdir=/tmp/cb --nogpgcheck --archlist=x86_64 cb-enterprise

# Download dependencies using repoquery to /tmp/cb with --nogpgcheck
for dep in $(repoquery --requires --resolve --archlist=x86_64 cb-enterprise); do
    sudo yumdownloader --resolve --destdir=/tmp/cb --nogpgcheck --archlist=x86_64 "$dep"
done
echo "Throughout the script, you'll notice many packages are skipped or already downloaded. That's completely fine."

