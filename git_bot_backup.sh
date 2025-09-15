#!/bin/bash

# -----------------------------------
# Git Bot - Automated Push (Handles Remote Default README)
# -----------------------------------

# Step 1: Initialize Git repository if not already initialized
if [ ! -d ".git" ]; then
    echo "Initializing Git repository..."
    git init
fi

# Step 2: Add remote if it doesn't exist
if ! git remote get-url origin &>/dev/null; then
    read -p "Enter remote repository URL: " remote_url
    if [ -z "$remote_url" ]; then
        echo "Error: Remote URL cannot be empty."
        exit 1
    fi
    git remote add origin "$remote_url"
fi

# Step 3: Ensure branch is main
git branch -M main

# Step 4: Stage all files
git add .

# Step 5: Commit changes
read -p "Enter commit message: " commit_msg
if [ -z "$commit_msg" ]; then
    echo "Error: Commit message cannot be empty."
    exit 1
fi

if ! git commit -m "$commit_msg"; then
    echo "⚠️ Nothing to commit. Skipping commit."
fi

# Step 6: Fetch and merge remote changes to handle default README
echo "Fetching and merging remote changes..."
git fetch origin main
git merge origin/main --allow-unrelated-histories --no-edit || echo "Merge complete or nothing to merge"

# Step 7: Push to remote
echo "Pushing to remote..."
git push -u origin main

# Step 8: Done
echo "✅ All done! Changes pushed to remote."
