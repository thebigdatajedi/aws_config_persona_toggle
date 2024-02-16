#!/bin/bash

# Define source and target directories
src_dir="$HOME/.aws_bak/"
target_dir="$HOME/.aws/"

# Check if source directory exists
if [ -d "$src_dir" ]; then
    echo "Source directory exists. Preparing to copy its contents..."
else
    echo "Source directory does not exist. Exiting..."
    exit 1
fi

# Check if target directory exists
if [ -d "$target_dir" ]; then
    echo "Target directory exists. Preparing to overwrite its contents..."
else
    echo "Target directory does not exist. Creating it..."
    mkdir "$target_dir"
    if [ $? -ne 0 ]; then
        echo "Failed to create target directory. Exiting..."
        exit 1
    fi
fi

# Inform user about the forced copy
echo "Forcing copy to overwrite existing files in target directory..."

# Copy contents from source to target directory
cp -rf "$src_dir" "$target_dir"
if [ $? -ne 0 ]; then
    echo "Failed to copy contents. Exiting..."
    exit 1
else
    echo "Files have been successfully copied and overwritten."
fi