#!/bin/bash

set -euo pipefail

CLOUDFLARE_API_TOKEN="$(vault kv get -mount=kv -field cloudflare_api_token buildkite/website)"
CLOUDFLARE_ZONE_ID="$(vault kv get -mount=kv -field cloudflare_zone_id buildkite/website)"

curl --silent --fail "https://api.cloudflare.com/client/v4/zones/$CLOUDFLARE_ZONE_ID/purge_cache" \
    -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
    -H "Content-Type: application/json" \
    --data '{"purge_everything": true}'
