#!/bin/bash

# $1 - Docker Compose version, for example "2.6.0"

set -euo pipefail

curl --fail --silent --location "https://github.com/docker/compose/releases/download/v$1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
