#!/bin/bash

set -euo pipefail

DEV_CACHE_BACKUP=dev-cache.tar

# Run a normal build to ensure remote content is ready
hugo --quiet

# Save a copy of the development cache
git clean -nx resources/json | cut -d ' ' -f 3 | tar -cf $DEV_CACHE_BACKUP --files-from -

# Run new build and fill with responses from public cache
mv secrets/embed-proxy-secret.txt secrets/embed-proxy-secret.txt.ignore
hugo --quiet --gc
git add --force -- resources/json/

# Restore old working environment
mv secrets/embed-proxy-secret.txt.ignore secrets/embed-proxy-secret.txt
tar -xf $DEV_CACHE_BACKUP
rm $DEV_CACHE_BACKUP
