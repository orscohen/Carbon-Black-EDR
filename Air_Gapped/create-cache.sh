#!/bin/bash

# Install yum-utils if not already installed
if ! command -v yumdownloader &> /dev/null; then
    sudo yum install -y yum-utils
fi

# Create the cb temp directory if it doesn't exist
mkdir -p /tmp/cb

# CB Enterprise:
# Download the main package to /tmp/cb with --nogpgcheck
sudo yumdownloader --resolve --destdir=/tmp/cb --nogpgcheck --archlist=x86_64 cb-enterprise

# Download dependencies using repoquery to /tmp/cb with --nogpgcheck
for dep in $(repoquery --requires --resolve --archlist=x86_64 cb-enterprise); do
    sudo yumdownloader --resolve --destdir=/tmp/cb --nogpgcheck --archlist=x86_64 "$dep"
done
# Create /tmp/cb/createrepo directory if it doesn't exist
mkdir -p /tmp/cb/createrepo
# Download createrepo to /tmp/cb/createrepo
sudo yum install --downloadonly --downloaddir="/tmp/cb/createrepo" createrepo -y

# Create /tmp/cb/yum-utils directory if it doesn't exist
mkdir -p /tmp/cb/yum-utils
# Download yum-utils to /tmp/cb/yum-utils
sudo yum install --downloadonly --downloaddir="/tmp/cb/yum-utils" yum-utils -y

