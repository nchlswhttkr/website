#!/bin/bash

set -euo pipefail

if [ $# == "0" ]; then
    echo -e "\033[31mExpected a title for the blip\033[0m"
    exit 1;
fi

TITLE="$*"
# Could probably be a fancy AWK script or something but this works for now
NAME="$(echo "${TITLE// /-}" | tr "[:upper:]" "[:lower:]" | sed "s/[^a-z0-9-]//g")"
YEAR="$(date "+%Y")"

if [[ ! -d "content/blog/$YEAR/$NAME" ]]; then
    hugo new --kind blog "blog/$YEAR/$NAME/index.md"
    sed -i '' "2 s/.*/title: \"$TITLE\"/" "content/blog/$YEAR/$NAME/index.md"
fi

code "content/blog/$YEAR/$NAME/index.md"
open "content/blog/$YEAR/$NAME"
