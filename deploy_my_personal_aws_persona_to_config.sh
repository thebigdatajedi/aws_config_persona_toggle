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

# Sign in to your 1Password account
eval $(op signin my)

# Fetch the required items
profile=$(op get item "SYSP" | jq -r '.details.fields[] | select(.designation=="username").value')
sso_account_id=$(op get item "SYSP" 
sso_session=$(op get item "SYSP" | jq -r '.details.fields[] | select(.designation=="sso_session").value')
sso_account_id=$(op get item "SYSP" | jq -r '.details.fields[] | select(.designation=="sso_account_id").value')
sso_role_name=$(op get item "SYSP" | jq -r '.details.fields[] | select(.designation=="sso_role_name").value')
region=$(op get item "SYSP" | jq -r '.details.fields[] | select(.designation=="region").value')
output=$(op get item "SYSP" | jq -r '.details.fields[] | select(.designation=="output").value')

# Create config file and write configuration
echo "[$profile]
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