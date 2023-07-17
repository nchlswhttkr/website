#!/bin/bash

set -euo pipefail

# Shoutout to the lack of nullglob support in Apple's release of Bash
find "$1" -name "*.jpg" -or -name "*.png" | while read -r IMAGE; do
    /Applications/ImageOptim.app/Contents/MacOS/ImageOptim "$IMAGE" >/dev/null 2>&1
done

git add "$1"
git add --interactive

TITLE=$(grep --max-count 1 "title" "$1/index.md" | sed "s/.*\"\(.\)\".*/\1/")
git commit --edit -m "Publish \"$TITLE\""
