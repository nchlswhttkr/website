#!/bin/bash
# $1 - Buildkite agent version number, for example 3.33.3

set -euo pipefail

mkdir -p "$HOME/.buildkite-agent/hooks"
curl --silent --fail --location "https://github.com/buildkite/agent/releases/download/v$1/buildkite-agent-linux-amd64-$1.tar.gz" \
    | tar --gzip --extract --directory="$HOME/.buildkite-agent" "./buildkite-agent"
