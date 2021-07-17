#!/bin/bash

set -euo pipefail
REPO=$(pwd | cut -d '/' -f 5)
cd "../${REPO%%.git}"
stagit -u "https://nicholas.cloud/git/${REPO%%.git}/" "../$REPO"
# shellcheck disable=SC2046
stagit-index $(find /var/www/git -mindepth 1 -maxdepth 1 -name '*.git') > /var/www/git/index.html

# Only trigger a build if repo is registered to mandarin-duck
if jq --exit-status ".projects[\"$PWD\"]" ~/.mandarin-duck/mandarin-duck.cfg > /dev/null; then
    source ~/.mandarin-duck/post-receive.sh
fi
