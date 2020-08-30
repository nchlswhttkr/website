#!/bin/bash

set -eu

git diff-tree --no-commit-id --name-status -r HEAD | grep "^[AM]\tcontent/newsletter/....-..\.md"  | cut -f 2 | sed -n "s;content/newsletter/\(....-..\)\.md;\1;p" > new-newsletters.txt

while read NEWSLETTER; do
  echo "
    steps:
      - label: \":email: Preview\"
        key: preview-newsletter-$NEWSLETTER
        command: .buildkite/publish-newsletter.sh
        agents:
          deploy-personal-website: true
        env:
          NEWSLETTER_ISSUE: $NEWSLETTER
          MAILING_LIST_ADDRESS: newsletter-preview@mailgun.nicholas.cloud
      - block: \"Publish newsletter #$NEWSLETTER?\"
        key: approve-newsletter-$NEWSLETTER
        depends_on: preview-newsletter-$NEWSLETTER
      - label: \":email: Publish\"
        depends_on: approve-newsletter-$NEWSLETTER
        command: .buildkite/publish-newsletter.sh
        agents:
          deploy-personal-website: true
        env:
          NEWSLETTER_ISSUE: $NEWSLETTER
          MAILING_LIST_ADDRESS: newsletter@mailgun.nicholas.cloud
  " | buildkite-agent pipeline upload
done < new-newsletters.txt
