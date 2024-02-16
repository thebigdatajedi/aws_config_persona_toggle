#!/bin/bash

# Verify if ~/.aws_backup_reservoir exists
if [ -d ~/.aws_backup_reservoir ]; then
    # Verify if ~/.aws exists
    if [ -d ~/.aws ]; then
        # Copy all files from ~/.aws_backup_reservoir to ~/.aws
        cp -R ~/.aws_backup_reservoir/* ~/.aws
        echo "Restored ~/.aws from backup."
    else
        # Create ~/.aws directory and copy files from ~/.aws_backup_reservoir
        mkdir ~/.aws
        cp -R ~/.aws_backup_reservoir/* ~/.aws
        echo "Restored ~/.aws from backup. However, ~/.aws was missing and has been created."
    fi
else
    echo "You did not initially backup your .aws files. Restoring .aws is not possible."
fi
