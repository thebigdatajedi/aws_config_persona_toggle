#!/bin/bash

backup_reservoir=~/.aws_backup_reservoir

if [ -d "$backup_reservoir" ]; then
  echo "The backup reservoir already exists. Ready to deploy alternate AWS persona."
else
  mkdir "$backup_reservoir"
  cp -r ~/.aws/* "$backup_reservoir"
  echo "Backup created successfully. Ready to deploy alternate AWS persona."
fi
