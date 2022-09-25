#!/bin/bash
set -euo pipefail

echo --- Setting secrets

if [[ "$BUILDKITE_PIPELINE_SLUG" == "website" ]]; then
    export MAILGUN_API_KEY="{{ mailgun_api_key }}"
    export CLOUDFLARE_ZONE_ID="{{ cloudflare_zone_id }}"
    export CLOUDFLARE_API_TOKEN="{{ cloudflare_api_token }}"
    export GIT_SSH_COMMAND="ssh -i /home/{{ ansible_user }}/.ssh/id_ed25519_website"
fi
