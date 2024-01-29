#!/bin/bash

#clean all yum repos
yum clean all

#Folder contains all the RPM's(the path is changeable):
REPO_PATH="/tmp/cb"
#Repo name:
REPO_CONFIG="/etc/yum.repos.d/cblocal.repo"
# Check if script is run with sudo
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script with sudo."
  exit 1
fi
# Check if createrepo is installed
if ! command -v createrepo &> /dev/null; then
    # Use find to locate the RPM file
    CREATEREPO_RPM=$(find "$REPO_PATH"/createrepo -type f -name 'createrepo*.rpm' -print -quit)

    if [ -n "$CREATEREPO_RPM" ]; then
        # Install createrepo and its dependencies from the RPMs
        sudo yum localinstall -y "$REPO_PATH"/createrepo/*.rpm
    else
        echo "Error: createrepo RPM file not found. Exiting."
        exit 1
    fi
fi
# Fix ownership and permissions for /tmp/cb
sudo chown -R root.root "$REPO_PATH"

# Create the repository if it doesn't exist
if [ ! -d "$REPO_CONFIG" ]; then
    sudo createrepo "$REPO_PATH"
fi

# Fix permissions for the repository
sudo chmod -R o-w+r "$REPO_PATH"


# Create a repository configuration file if it doesn't exist
if [ ! -f "$REPO_CONFIG" ]; then
    echo "[local]
name=CB Local Repo
baseurl=file://$REPO_PATH
enabled=1 
gpgcheck=0" | sudo tee "$REPO_CONFIG" > /dev/null
fi
#Remove duplicated rpm with OS – tested with Centos 7
mv "$REPO_PATH"/sysstat-10.1.5-19.el7.x86_64.rpm /tmp
mv "$REPO_PATH"/openssl-1.0.2k-22.el7_9.x86_64.rpm /tmp
# Install your package from the local repository,and disable all live repos to work with the offline repo
sudo yum --disablerepo=* --enablerepo=local install /tmp/cb/*.rpm
