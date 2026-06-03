#!/bin/bash

set -euo pipefail

echo --- Downloading build artifacts
buildkite-agent artifact download website.tar.gz . --step build
tar -xz -f website.tar.gz

echo --- Syncing to Cloudflare R2
CLOUDFLARE_ACCOUNT_ID="$(vault kv get -field cloudflare_account_id buildkite/website)"
AWS_ACCESS_KEY_ID="$(vault kv get -field cloudflare_api_token_id buildkite/website)"
export AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY="$(vault kv get -field cloudflare_api_token buildkite/website | sha256sum | awk '{ print $1 }')"
export AWS_SECRET_ACCESS_KEY

aws s3 sync --endpoint-url "https://$CLOUDFLARE_ACCOUNT_ID.r2.cloudflarestorage.com" --delete "$PWD/public" s3://blog/
