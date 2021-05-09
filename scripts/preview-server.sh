#!/usr/bin/env bash

set -eu

hugo server --baseURL https://tunnel.nicholas.cloud/ \
    --port 9999 \
    --liveReloadPort 443 \
    --appendPort=false \
    --navigateToChanged &
HUGO_SERVER_PID=$!

cloudflared tunnel run --url localhost:9999 preview 2> /dev/null

wait $HUGO_SERVER_PID
