#!/bin/bash

set -eu

hugo --minify --cleanDestinationDir
sed -i 's/[a-z.* ]*{}//g' public/highlight.min.css
rsync --recursive --verbose --itemize-changes --checksum --delete $PWD/public/ /var/www/nicholas.cloud