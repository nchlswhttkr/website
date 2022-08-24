#!/bin/bash

# Confirm that the Python virtual environment (venv in this case) is activated

set -euo pipefail

if [[ -z "${VIRTUAL_ENV:-}" ]]; then
    echo -e "\033[31mNot running inside a virtual environment\033[0m"
    echo -n ". .venv/bin/activate" | pbcopy
    exit 1;
fi
