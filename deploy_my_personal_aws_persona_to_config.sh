#!/bin/bash

# Define source and target directories
src_dir="$HOME/.aws/"
target_dir="$HOME/.aws_bak/"

# Check if source directory exists
if [ -d "$src_dir" ]; then
    echo "Source directory exists. Preparing to copy its contents..."
else
    echo "Source directory does not exist. Exiting..."
    exit 1
fi

# Check if target directory exists
if [ -d "$target_dir" ]; then
    echo "Target directory exists. Preparing to copy the contents of source directory..."
else
    echo "Target directory does not exist. Creating it..."
    mkdir "$target_dir"
    if [ $? -ne 0 ]; then
        echo "Failed to create target directory. Exiting..."
        exit 1
    fi
fi

# Copy contents from source to target directory
cp -r "$src_dir" "$target_dir"
if [ $? -ne 0 ]; then
    echo "Failed to copy contents. Exiting..."
    exit 1
fi

# Define config file path
config_file="$HOME/.aws/config"

# Delete config file if it exists
if [ -f "$config_file" ]; then
    rm "$config_file"
fi

# Read authentication data from config file
if [ -f "auth.config" ]; then
    source "auth.config"
    echo "Authentication config has been loaded to memory."
else
    echo "Authentication config file not found. Exiting..."
    exit 1
fi

eval $(op signin --raw)

# Fetch the required items
profile=$(op read "op://SYSP/AWSP/username")
sso_account_id=$(op read "op://SYSP/AWSP/sso_account_id")
sso_session=$(op read "op://SYSP/AWSP/sso_session")
sso_role_name=$(op read "op://SYSP/AWSP/sso_role_name")
region=$(op read "op://SYSP/AWSP/region")
output=$(op read "op://SYSP/AWSP/output")

# Verify if variables are set
if [[ -z "$profile" || -z "$sso_session" || -z "$sso_account_id" || -z "$sso_role_name" || -z "$region" || -z "$output" ]]; then
    echo "One or more variables are empty. Exiting..."
    exit 1
else
    echo "All variables are set."
fi

# Create config file and write configuration
echo "$profile
sso_session = $sso_session
sso_account_id = $sso_account_id
sso_role_name = $sso_role_name
region = $region
output = $output" > "$config_file"

if [ $? -eq 0 ]; then
    echo "Configuration has been written to the config file."
    echo "Config file has been saved."
else
    echo "Failed to write configuration to the config file. Exiting..."
    exit 1
fi