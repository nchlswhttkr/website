#!/bin/bash

set -eu

git diff-tree --no-commit-id --name-status -r HEAD | cut -f 2 | grep "^content/newsletter/....-..\.md" | sed -n 's;content/newsletter/\(....-..\)\.md;\1;p' > new-newsletters.txt

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
          - block: Publish?
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
