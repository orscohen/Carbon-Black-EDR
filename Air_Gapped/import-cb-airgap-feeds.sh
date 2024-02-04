#!/bin/bash

#Offical documentation https://github.com/carbonblack/cb-airgap-feed
echo "please review the official documentation at https://github.com/carbonblack/cb-airgap-feed"
#If the server is not registered yet please use '/usr/share/cb/cbinit'
#If the services are down, please use 'systemctl start cb-enterprise'
#Export all the intelligence JSON files from the **caching server**
#Using /usr/share/cb/cbfeed_airgap export

# Set the path to the directory containing JSON files
json_directory="/tmp/feeds/"

# Change to the JSON directory
cd "$json_directory" || exit

# Loop through each JSON file to avoid errors when choosing all of them at the same time.
# Can also work with  '/usr/share/cb/cbfeed_airgap import -f <file-name>.json'
for json_file in *.json; do
    echo "Importing $json_file..."
    /usr/share/cb/cbfeed_airgap import -f "$json_file"
done
