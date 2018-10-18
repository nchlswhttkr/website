#!/bin/sh

# Deploy the site when the superproject (dev branch) is pushed

set -e

cd public
git push
cd ..
