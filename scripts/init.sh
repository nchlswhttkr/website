#!/bin/sh

# This should be run after a fresh clone, it sets up git submodules and hooks

set -e

# Create the build directory, and initialise git
mkdir public
cd public
git init
git remote add origin git@github.com:nchlswhttkr/nchlswhttkr.github.io.git
git pull origin master
git branch -u origin/master
cd ..

# pre-commit
echo "#!/bin/sh
sh scripts/pre-commit.sh
" > .git/hooks/pre-commit
chmod +x .git/hooks/pre-commit

# pre-push
echo "#!/bin/sh
sh scripts/pre-push.sh
" > .git/hooks/pre-push
chmod +x .git/hooks/pre-push
