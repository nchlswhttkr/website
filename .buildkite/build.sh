#!/bin/bash

set -euo pipefail

echo "Running pre-build checks"
DUPLICATE_BLOG_POSTS=$(
    find content/blog -mindepth 2 -maxdepth 2 -type d \
        | cut -d / -f 4 \
        | sort \
        | uniq --repeated \
        | sed "s;^;\t;"
)
if [[ "$DUPLICATE_BLOG_POSTS" != "" ]]; then
    echo -e "\033[31mFound duplicate blog posts:\n$DUPLICATE_BLOG_POSTS\033[0m"
    exit 1;
fi

echo --- Running Hugo build
sed -i 's/[a-z.* ]*{ *}//g' assets/highlight.css # Remove empty CSS rules
make
tar -cz -f website.tar.gz public/
