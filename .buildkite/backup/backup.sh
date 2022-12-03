#!/bin/bash

set -euo pipefail

pip3 install --quiet --requirement .venv/requirements.txt
ansible-galaxy collection install --requirement .venv/ansible-requirements.yml

cd deploy
ansible-playbook --inventory hosts.yml backup.yml --extra-vars "date='$(date -u "+%Y-%m-%d %H:%M:%S")'"