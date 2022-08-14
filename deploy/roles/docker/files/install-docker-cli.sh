#!/bin/bash

# $1 - Ubuntu release short name, for example "jammy"
# $2 - Docker version, for example "20.10.17"

set -euo pipefail

curl --fail --silent \
    "https://download.docker.com/linux/ubuntu/dists/$1/pool/stable/amd64/docker-ce-cli_$2~3-0~ubuntu-$1_amd64.deb" \
    > /tmp/docker-cli.deb
dpkg -i /tmp/docker-cli.deb
