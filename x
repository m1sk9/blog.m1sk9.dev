#!/bin/bash

if [ "$1" == "create" ]; then
  if [ -z "$2" ]; then
    echo "Error: No name provided."
    echo "Usage: x create <name>"
    exit 1
  fi

  name=$2

  hugo new --kind default ./content/posts/"$name".md

  if [ $? -eq 0 ]; then
    echo "Post '$name' created successfully."
  else
    echo "Error: Failed to create post '$name'."
  fi
else
  echo "Error: Invalid command."
  echo "Usage: x create <name>"
  exit 1
fi
