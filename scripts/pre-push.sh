#!/bin/sh

# Deploy the site when the superproject is pushed

set -e

cd public
git push
cd ..
