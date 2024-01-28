# Carbon Black EDR Offline Air-Gapped Server Installation Guide

This guide is intended for users who were unable to successfully install Carbon Black EDR using the standard online installation method. 

The instructions have been tested on CentOS 7 (version 2009).
### Please use the same OS for the cache server & Air gapped:
that will break the installation.

## Environment
- EDR Server: 7.x+
- Linux: All Supported Versions

## Objective
Install the EDR server on air-gapped Linux servers that lack internet access.

## Resolution
The installation involves two servers: the caching server and the air-gapped server.

### Caching Server Setup:

1. Install the appropriate OS on the caching server.
2.Download the scripts:
    ```bash
    git clone https://github.com/orscohen/Carbon-Black-EDR/tree/main/Air_Gapped
    ```

3. Install the Carbon Black EDR License RPM:

    ```bash
    rpm -ivh <license-rpm-file>
    ```

4. Download and execute the script on the caching server:

    ```bash
    chmod +x create-cache.sh
    sudo ./create-cache.sh
    ```

   The script will generate all RPMs in the `/tmp/cb` directory.

### Transfer Files:
Transfer the entire `/tmp/cb` directory (containing the downloaded RPM files) to the air-gapped machine. Use a USB drive, network transfer, or any other secure method.

### Air-Gapped Server Installation:

1. Execute the installation script on the air-gapped server:

    ```bash
    chmod +x air-gapped.sh
    sudo ./air-gapped.sh
    ```

2. **Note:** If you encounter a "Protected multilib versions" error, remove the older RPM version. For example:

    ```bash
    rm /tmp/cb/sysstat-10.1.5-19.el7.x86_64.rpm
    ```

    Repeat the process for any other duplicated versions, such as `openssl-1.0.2k-22.el7_9.x86_64.rpm`.
   ## OS Updates
Do not install any other software & Make an update to the cache server - 

it is supposed to be exactly like the air-gapped server

you can use the following on the Cache server:


```bash
mkdir -p /tmp/updates
sudo yum update --downloadonly --downloaddir="/tmp/updates"
```  
Move all the updates to the air-gapped server

 in folder /tmp/updates,
 
 then install them with:
 
```bash
rpm -ivh /tmp/updates/*.rpm
```



**Important:** These steps are for new installations only. Using these instructions for updating EDR can result in the loss of all data, configurations, and certificates.

**Refer to the [official Carbon Black Community Knowledge Base](https://community.carbonblack.com/t5/Knowledge-Base/EDR-How-to-Perform-an-Offline-Air-Gapped-Server-Installation/ta-p/92493) for additional details.**
