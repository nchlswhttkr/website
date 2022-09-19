#!/bin/bash

set -euo pipefail

git diff-tree --no-commit-id --name-status -r HEAD content/newsletter/ \
    | cut -f 2 \
    | sed -n "s;content/newsletter/\(....-..\)\.md;\1;p" \
    > new-newsletters.txt

while read -r NEWSLETTER < new-newsletters.txt; do
  echo "
    steps:
      - label: \":email: Preview newsletter #$NEWSLETTER\"
        key: preview-newsletter-$NEWSLETTER
        command: .buildkite/publish-newsletter.sh
        env:
          NEWSLETTER_ISSUE: $NEWSLETTER
          MAILING_LIST_ADDRESS: newsletter-preview@mailgun.nicholas.cloud
      - block: \"Publish newsletter #$NEWSLETTER?\"
        key: approve-newsletter-$NEWSLETTER
        depends_on: preview-newsletter-$NEWSLETTER
      - label: \":email: Publish newsletter #$NEWSLETTER\"
        key: publish-newsletter-$NEWSLETTER
        depends_on: approve-newsletter-$NEWSLETTER
        command: .buildkite/publish-newsletter.sh
        env:
          NEWSLETTER_ISSUE: $NEWSLETTER
          MAILING_LIST_ADDRESS: newsletter@mailgun.nicholas.cloud
  " | buildkite-agent pipeline upload
done
