#!/bin/bash

# -----------------------------------
# Git Bot - Fully Automated Push
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

# Skip commit if nothing to commit
if ! git commit -m "$commit_msg"; then
    echo "⚠️ Nothing to commit. Skipping commit."
fi

# Step 6: Pull remote first (handle unrelated histories)
echo "Fetching remote changes..."
git pull origin main --allow-unrelated-histories 2>/dev/null || echo "No remote to pull from"

# Step 7: Push changes to remote
echo "Pushing to remote..."
git push -u origin main

# Step 8: Done
echo "✅ All done! Changes pushed to remote."
