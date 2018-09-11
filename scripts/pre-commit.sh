#!/bin/sh

# This will build and commit build artifacts

set -e

# Stash unstaged changes
git stash -k -u

# Build
hugo

cd public
git add .
git commit -m "published site changes"
cd ..

git stash pop
