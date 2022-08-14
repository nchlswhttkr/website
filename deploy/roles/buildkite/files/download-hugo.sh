#!/bin/bash
# $1 - Hugo version number, for example 0.92.0

set -euo pipefail

curl --silent --fail --location "https://github.com/gohugoio/hugo/releases/download/v$1/hugo_$1_Linux-64bit.tar.gz" \
    | tar --gzip --extract --directory="$HOME" hugo
