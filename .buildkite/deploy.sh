#!/bin/bash

set -euo pipefail

echo --- Deploying nicholas.cloud
buildkite-agent artifact download website.tar.gz . --step build
tar -xz -f website.tar.gz
rsync --recursive --verbose --itemize-changes --checksum --delete "$PWD/public/" --exclude "files" -e "ssh -o StrictHostKeyChecking=no" nicholas@gandra-dee:/var/www/nicholas.cloud
