#!/bin/bash

set -euo pipefail
REPO=$(pwd | cut -d '/' -f 5)
cd "../${REPO%%.git}"
stagit -u "https://nicholas.cloud/git/${REPO%%.git}/" "../$REPO"
stagit-index $(find /var/www/git -mindepth 1 -maxdepth 1 -name "*.git") > /var/www/git/index.html

# shellcheck disable=SC1009,SC1054,SC1056,SC1072,SC1073,SC1083
{% if item.mandarin_duck_enabled %}
source ~/.mandarin-duck/post-receive.sh
{% endif %}
