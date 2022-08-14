#!/bin/bash

# $1 - Ubuntu release short name, for example "jammy"
# $2 - Containerd version, for example "1.6.7"

set -euo pipefail

curl --fail --silent \
    "https://download.docker.com/linux/ubuntu/dists/$1/pool/stable/amd64/containerd.io_$2-1_amd64.deb" \
    > /tmp/containerd.deb
dpkg -i /tmp/containerd.deb
