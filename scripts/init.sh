#!/bin/sh

# This should be run after cloning, it sets up the remote and creates hooks

set -e

mkdir public
cd public
git init
git remote add origin git@github.com:nchlswhttkr/nchlswhttkr.github.io.git
git pull origin master
git branch -u origin/master
cd ..

cp scripts/pre-commit.sh .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit

cp scripts/pre-push.sh .git/hooks/pre-push
chmod +x .git/hooks/pre-push
