#!/bin/bash

# My apologies to anyone who may stumble across this mess

set -euo pipefail

if [ $# == "0" ]; then
    echo -e "\033[31mExpected a title for the blip\033[0m"
    exit 1;
fi

TITLE="$*"
NAME=$(
    # Could probably be a fancy AWK script or something but this works for now
    echo "${TITLE// /-}" | tr "[:upper:]" "[:lower:]" | sed "s/[^a-z0-9-]//g"
)

if [[ ! -d "content/blips/$NAME" ]]; then
    hugo new "blips/$NAME.md"
    mkdir "content/blips/$NAME"
    mv "content/blips/$NAME.md" "content/blips/$NAME/index.md"
    sed -i '' "s/$NAME/$TITLE/" "content/blips/$NAME/index.md"
    code --wait "content/blips/$NAME/index.md"
else
    echo -e "\033[33mFound existing blip $NAME, skipping...\033[0m"
fi


IMAGE_COUNTER=$(($(find "content/blips/$NAME/" -mindepth 1 -maxdepth 1 | wc -l) - 1 ))
if grep "^! .*$" "content/blips/$NAME/index.md" > /tmp/images; then
    exec 3</tmp/images
    while read -ru 3 IMAGE; do
        echo "${IMAGE/! /}"
        read -erp    "Where is this image?        > " IMAGE_PATH
        read -rp     "What is its extension?      > $((++IMAGE_COUNTER))." IMAGE_EXTENSION
        magick "${IMAGE_PATH//\\/}" -resize "1280x>" -strip "content/blips/$NAME/$IMAGE_COUNTER.$IMAGE_EXTENSION"
        LINE_NUMBER=$(grep --fixed-strings --line-regexp --line-number --max-count=1 "$IMAGE" "content/blips/$NAME/index.md" | cut -d ":" -f 1)
        sed -i '' "$LINE_NUMBER s/.*/![${IMAGE/! /}](.\/$IMAGE_COUNTER.$IMAGE_EXTENSION)/" "content/blips/$NAME/index.md"
    done
fi


head -n 3 "content/blips/$NAME/index.md" > "content/blips/$NAME/index.md.tmp"
if (( IMAGE_COUNTER > 0 )); then
    COVER_IMAGE=$(cd "content/blips/$NAME" && read -erp "Use which image as a cover? ")
    if [[ $COVER_IMAGE != '' ]]; then
        grep --max-count=1 "$COVER_IMAGE" "content/blips/$NAME/index.md" | sed "s/^!\[\(.*\)\].*/coveralt: \"\1\"/" >> "content/blips/$NAME/index.md.tmp"
        echo "cover: $COVER_IMAGE" >> "content/blips/$NAME/index.md.tmp"

    fi
fi
read -erp "Any tags for this blip?     > " TAGS
if [[ $TAGS != '' ]]; then
    echo "tags:" >> "content/blips/$NAME/index.md.tmp"
    echo "$TAGS" | tr ' ' '\n' | while read -r TAG; do
        echo "    - $TAG" >> "content/blips/$NAME/index.md.tmp"
    done;
fi
tail -n +4 "content/blips/$NAME/index.md" >> "content/blips/$NAME/index.md.tmp"
mv "content/blips/$NAME/index.md.tmp" "content/blips/$NAME/index.md"


# Shoutout to the lack of nullglob support in Apple's release of Bash
find "content/blips/$NAME" -name "*.jpg" -or -name "*.png" | while read -r IMAGE; do
    /Applications/ImageOptim.app/Contents/MacOS/ImageOptim "$IMAGE" >/dev/null 2>&1
done

git add "content/blips/$NAME/"

git add --interactive

git commit --edit -m "Publish \"$TITLE\""
