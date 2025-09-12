#!/bin/bash

# Initialize git repository if not already initialized
if [ ! -d ".git" ]; then
    git init
    read -p "Enter remote repository URL: " remote_url

    # Make sure a remote URL was provided
    if [ -z "$remote_url" ]; then
        echo "Error: Remote URL cannot be empty."
        exit 1
    fi

    git remote add origin "$remote_url"
    git branch -M main
fi

# Stage all files
git add .

# Commit changes
read -p "Enter commit message: " commit_msg

# Check if commit message is empty
if [ -z "$commit_msg" ]; then
    echo "Error: Commit message cannot be empty."
    exit 1
fi

# Try to commit, but skip if nothing new
if ! git commit -m "$commit_msg"; then
    echo "⚠️ Nothing to commit. Skipping commit."
fi

# Push to remote
git push -u origin main

echo "✅ All done! Changes pushed to remote."
