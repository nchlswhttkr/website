#!/bin/bash

set -eu

sed -i 's/[a-z.* ]*{ *}//g' assets/highlight.css
hugo --minify --cleanDestinationDir
rsync --recursive --verbose --itemize-changes --checksum --delete $PWD/public/ /var/www/nicholas.cloud
