#!/bin/sh

# This should be run after a fresh clone, it sets up git submodules and hooks

# Set the submodule to track the master branch, as opposed to the most recent
# commit, to avoid having to deal with a detached head
git submodule init
git submodule update
cd public
git checkout master
cd ..

# Copy over the pre-commit hook
cp scripts/pre-commit.sh .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit
