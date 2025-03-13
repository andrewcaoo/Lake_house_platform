#!/bin/bash

# Navigate to the repository directory
cd ../../home/Lakehouse || exit

# Fetch all branches from the remote
git fetch origin

# Check if the branch exists
if git show-ref --verify --quiet refs/remotes/origin/main; then
    # If the branch exists, check it out
    git checkout main
else
    # If the branch does not exist, create it from the remote
    git checkout -b main origin/main
fi

# Pull the latest changes
git pull origin main

# Build and restart the Docker containers
docker-compose up -d --build