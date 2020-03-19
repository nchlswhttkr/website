#!/bin/bash

# $1    - The receiving mailing list address

set -euo pipefail

curl --fail "https://nicholas.cloud/newsletter/$NEWSLETTER_ISSUE/" > email.html
curl --fail "https://templates.mailchimp.com/services/html-to-text/" --data-urlencode html@email.html > email.text

curl --fail "https://api.eu.mailgun.net/v3/mailgun.nicholas.cloud/messages" \
    --user "api:$MAILGUN_API_KEY" \
    --data-urlencode to=$1 \
    --data-urlencode "from=Nicholas <noreply@mailgun.nicholas.cloud>" \
    --data-urlencode "subject=Newsletter #$NEWSLETTER_ISSUE from nicholas.cloud" \
    --data-urlencode html@email.html \
    --data-urlencode text@email.text