#!/bin/bash

# Verifying dependencies before running.
if ! command -v bashdb &> /dev/null #user will use bashdb to debug the script if it fails
then
    echo "bashdb could not be found"
    exit
fi

if ! command -v op &> /dev/nullf #user will use op to fetch the required items from 1password
then
    echo "op could not be found"
    exit
fi

echo "Both bashdb and op are installed"
# Continue with the rest of your script:

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
#The name of the varables in the script will almost alway be the names of the categoreis in 1password.
profile=$(op read "op://VAULT_NAME/ITEM/CATEGORY1")
sso_account_id=$(op read "op://VAULT_NAME/ITEM/CATEGORY2")
sso_session=$(op read "op://VAULT_NAME/ITEM/CATEGORY3")
sso_role_name=$(op read "op://VAULT_NAME/ITEM/CATEGORY4")
region=$(op read "op://VAULT_NAME/ITEM/CATEGORY5")
output=$(op read "op://VAULT_NAME/ITEM/CATEGORY6")

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