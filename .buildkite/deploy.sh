#!/bin/bash

set -euo pipefail

echo --- Deploying nicholas.cloud
buildkite-agent artifact download website.tar.gz . --step build
tar -xz -f website.tar.gz
tailscale status --json | jq '.Peer.[] | select(.Tags // [] | any(. == "tag:project-blog")) | .DNSName' | while read -r HOST; do
    rsync --recursive --verbose --itemize-changes --checksum --delete "$PWD/public/" --exclude "files" -e "ssh -o StrictHostKeyChecking=no" "blog@$HOST:/var/www/nicholas.cloud"
done;
