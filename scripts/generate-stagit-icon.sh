#!/bin/bash

set -eu

magick assets/favicon.png -resize "96x96" -background "#B00B69" -flatten droplet-config/git/icon.png
