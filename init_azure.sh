#!/bin/bash

#https://github.com/Zenika/terraform-azure-cli
#docker container run -it --rm --mount type=bind,source="$PWD",target=/workspace zenika/terraform-azure-cli:latest ./init_azure.sh

# Check if jq is installed, if not install it for parsing JSON
echo "Installing dependencies ......"
dpkg -l | grep -qw jq || apt-get update > /dev/null && apt-get install -y jq > /dev/null
az login
cd ./infrastructure/azure && ./init_terraform.sh