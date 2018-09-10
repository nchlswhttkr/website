#!/bin/sh

# This should be run as a git-hook before commits to dev, and will rebuild the
# site with any changes that are staged.

# PRE BUILD
git stash push -k -u
cd public
git reset --hard HEAD^1
git clean -df
git pull origin master
cd ..

# BUILD
hugo

# POST BUILD
git stash pop

# DEPLOY
cd public
git add .
git commit -m "published site changes"
git push origin master
cd ..
