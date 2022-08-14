#!/bin/bash

set -euo pipefail

# Perhaps I should have not have written this script, but oh well!

read -rp "Roll key for which user? (remote-user/github-actions/octopus) > " USER

case $USER in
    remote-user)
        COMMENT="Remote access for machines hosting nicholas.cloud"
        PUBLIC_KEY_DESTINATION="droplet-config/terraform/remote-user.pub"
    ;;
    *)
        echo -e "\033[31mInvalid user\033[0m"
        exit 1
    ;;
esac

ssh-keygen -N "" -f "$USER" -t ed25519 -C "$COMMENT"
mv "$USER.pub" "$PUBLIC_KEY_DESTINATION"
pass insert --multiline "website/$USER.pem" < "$USER"
rm "$USER"
