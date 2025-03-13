#!/bin/bash

# Define the repository URL and the local directory
REPO_URL="https://github.com/andrewcaoo/Lake_house_platform.git"  # Replace with your repository URL
REPO_DIR="../../home"  # Replace with the path where you want to clone the repo

# Check if the repository directory exists
if [ ! -d "$REPO_DIR" ]; then
    # If it doesn't exist, clone the repository
    git clone "$REPO_URL" "$REPO_DIR"
fi

# Navigate to the repository directory
cd "$REPO_DIR" || exit

# Fetch all branches from the remote
git fetch origin

# Check if the main branch exists on the remote
if git show-ref --verify --quiet refs/remotes/origin/main; then
    # If the branch exists, check it out
    git checkout main
else
    # If the branch does not exist, create it from the first available branch
    first_branch=$(git branch -r | grep -v '\->' | head -n 1 | sed 's/origin\///')
    if [ -n "$first_branch" ]; then
        git checkout -b main origin/$first_branch
    else
        echo "No branches available to create 'main' from."
        exit 1
    fi
fi

# Pull the latest changes
git pull origin main

# Build and restart the Docker containers
docker-compose up -d --build