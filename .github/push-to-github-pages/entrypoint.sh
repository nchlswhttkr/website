#!/bin/bash

set -euo pipefail

cd /github/workspace/public
git config --global user.name "Nicholas Whittaker"
git config --global user.email "26531118+nchlswhttkr@users.noreply.github.com"
git init
git add .
git commit -m "Deploy"
git push --force https://nchlswhttkr:$PERSONAL_ACCESS_TOKEN@github.com/nchlswhttkr/$REPOSITORY.git master:$BRANCH
