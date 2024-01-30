#!/bin/bash

# Folder containing all the RPMs (the path is changeable):
REPO_PATH="/tmp/cb"

# Repo name:
REPO_CONFIG="/etc/yum.repos.d/cblocal.repo"

# Check if script is run with sudo
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script with sudo."
  exit 1
fi

# Check if createrepo is installed
if which createrepo >/dev/null; then
echo 'package create repo already installed'
else
        rpm -ivh "$REPO_PATH"/createrepo/*.rpm
fi

# Fix ownership and permissions for REPO_PATH
chown -R root.root "$REPO_PATH"

# Check if sudo yum-config-manager is available
if which yum-config-manager >/dev/null; then
    echo "yum-config-manager is available."
else
    echo "yum-config-manager is not available. Installing yum-utils..."
     rpm -ivh "$REPO_PATH"/yum-utils/*.rpm
fi

#Disable all repos
sudo yum-config-manager --disable '*'


# Create the repository if it doesn't exist
if [ ! -d "$REPO_PATH/repodata" ]; then
    createrepo "$REPO_PATH"
fi

# Fix permissions for the repository
chmod -R o-w+r "$REPO_PATH"
REPO_CONFIG="/etc/yum.repos.d/cblocal.repo"

# Check if the repository configuration file exists
if [ ! -f "$REPO_CONFIG" ]; then
    # Create the repository configuration file
    echo "[local]
name=CB Local Repo
baseurl=file:///$REPO_PATH
enabled=1
gpgcheck=0
module_hotfixes=true"| tee "$REPO_CONFIG" > /dev/null
else
    # Check if 'enabled' is set to 0, change it to 1
    if grep -q '^enabled=0$' "$REPO_CONFIG"; then
        sed -i 's/^enabled=0/enabled=1/' "$REPO_CONFIG"
    fi
fi

# Enable just the local repo
sudo yum-config-manager --enable local

# Install from cache
sudo yum makecache
sudo yum -C install cb-enterprise

#revert to all repo in enable  and disable the local repo
#sudo yum-config-manager --disable local --enable \*
