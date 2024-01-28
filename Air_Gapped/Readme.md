use only if https://community.carbonblack.com/t5/Knowledge-Base/EDR-How-to-Perform-an-Offline-Air-Gapped-Server-Installation/ta-p/92493 did not work for you
tested on Centos 7 2009

EDR: How to Perform an Offline Air-Gapped Server Installation 
Environment
•	EDR Server: 7.x+
•	Linux: All Supported Versions

Objective
To install EDR server onto Air-Gapped Linux servers that do not have access to the public internet. 
Resolution
The caching server is a Linux server that connects to the Internet to collect the RPM packages necessary to perform an EDR install.  It does not need to meet the Operating Environment Requirements (OER).
The air-gapped server is the production Linux server that does not connect to the Internet.  It must meet OER sizing guides.
Note: The caching server needs to match the OS and kernel version of the air-gapped server.
Note: These steps are for a new installation only.  Using these instructions for updating EDR can result in the loss of all data, configurations, and certificates.
Configure the Caching Server:


**caching server:**
1.	Install the appropriate OS on the caching server.
2.	Install the Carbon Black EDR License RPM.  
rpm -ivh <carbon-black-release-file>

**download and use the following script on the cache server:**
chmod +x create-cache.sh
sudo ./create-cache.sh

after running the script you will see all RPMs created in the /tmp/cb

**Transfer Files:**
•	Transfer the entire /tmp/cb directory, which contains the downloaded RPM files, to the air-gapped machine. You can use a USB drive, network transfer, or any other secure method.

**Air gapped server:**
chmod +x air-gapped.sh
sudo ./air-gapped.sh

NOTE:if you are receiving an error about- 
Protected multilib versions: sysstat-10.1.5-19.el7.x86_64 != sysstat-10.1.5-20.el7_9.x86_64”
remove the older rpm version for example rm /tmp/cb/sysstat-10.1.519.el7.x86_64.rpm”
same for openssl-1.0.2k-22.el7_9.x86_64.rpm or any other duplicated versions.
