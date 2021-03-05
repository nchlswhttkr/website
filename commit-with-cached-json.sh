#!/bin/bash

set -eu

# Run a normal build to ensure remote content is ready
hugo --quiet

# Clean up remote content cache
git stash push --all --quiet resources/json/

# Run new build and fill with responses from public cache
mv secrets/embed-proxy-secret.txt secrets/embed-proxy-secret.txt.ignore
hugo --quiet
git add --force -- resources/json/
git commit

# Restore old working environment
mv secrets/embed-proxy-secret.txt.ignore secrets/embed-proxy-secret.txt
git stash pop --quiet
git restore --staged .