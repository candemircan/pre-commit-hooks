#!/bin/bash

# This script is run by the pre-commit framework.
# It finds all directories within the specified target directory
# and adds a .gitkeep file if one doesn't exist and the directory is otherwise empty.

# Define the target directory.
# We'll hardcode it here, but you could also pass it as an argument
# if you configured 'args' in the .pre-commit-config.yaml
TARGET_DIR="data"

# Check if the target directory exists
if [ ! -d "$TARGET_DIR" ]; then
  echo "Directory '$TARGET_DIR' not found. Skipping .gitkeep creation."
  exit 0
fi

echo "Adding .gitkeep files to empty directories in '$TARGET_DIR'..."

# Find all directories within the target directory, excluding the target directory itself
find "$TARGET_DIR" -type d -not -path "$TARGET_DIR" -print0 | while IFS= read -r -d $'\0' dir; do
  # Check if the directory is empty (contains only .gitkeep or nothing)
  # We check if the number of items excluding .gitkeep is zero
  if [ "$(find "$dir" -mindepth 1 -maxdepth 1 ! -name '.gitkeep' -print | wc -l)" -eq 0 ]; then
    GITKEEP_FILE="$dir/.gitkeep"
    # Check if .gitkeep already exists
    if [ ! -f "$GITKEEP_FILE" ]; then
      echo "Creating $GITKEEP_FILE"
      touch "$GITKEEP_FILE"
      # Stage the new .gitkeep file so it's included in the commit
      git add "$GITKEEP_FILE"
    fi
  fi
done

echo ".gitkeep hook finished."

# Exit with status 0 to indicate success to pre-commit
exit 0

