#!/bin/bash

# -----------------------------------
# Git Bot - Automated Push (Handles Remote Default README)
# -----------------------------------

# Step 1: Initialize Git repository if not already initialized

# If user calls with subcommand (manual mode)
if [[ $# -gt 0 ]]; then
  case "$1" in
    ensure-readme) ensure_readme; exit 0 ;;
    tag) tag; exit 0 ;;
  esac
fi

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

# Add README.md 
# --- Extra helpers ---

ensure_readme() {
  if [ ! -f README.md ]; then
    cat > README.md <<'EOF'
# Project Title

Describe your project here.

## Setup

Explain installation / usage.

## License

Add license details here.
EOF

    echo "README.md created. Opening in nvim so you can edit..."
    nvim README.md

    git add README.md
    git commit -m "chore: add README.md (auto-generated and edited)" || true
    echo "README.md added and committed"
  else
    echo "README.md already exists"
  fi
}

tag() {
  local latest newtag
  latest=$(git describe --tags --abbrev=0 2>/dev/null || echo "v0.0.0")
  IFS='.' read -r major minor patch <<< "${latest#v}"
  patch=$((patch+1))
  newtag="v$major.$minor.$patch"

  git tag -a "$newtag" -m "release: $newtag — recommended update"
  git push origin "$newtag"
  echo "Tagged and pushed $newtag"
}

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

# greeting 
echo "Hello from the feature-update branch!"
