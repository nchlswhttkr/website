#!/bin/bash
set -euo pipefail

echo --- Setting secrets

if [[ "$BUILDKITE_PIPELINE_SLUG" == "website" ]]; then
    export MAILGUN_API_KEY="{{ mailgun_api_key }}"
fi
