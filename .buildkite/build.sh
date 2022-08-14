#!/bin/bash

set -eu

sed -i 's/[a-z.* ]*{ *}//g' assets/highlight.css

echo --- Running Hugo build
hugo --minify --cleanDestinationDir

echo --- Updating nicholas.cloud
rsync --recursive --verbose --itemize-changes --checksum --delete "$PWD/public/" --exclude "files" /var/www/nicholas.cloud
