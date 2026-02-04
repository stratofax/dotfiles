#!/usr/bin/env bash
set -euo pipefail

input=$(cat)
file_path=$(echo "$input" | jq -r '.tool_input.file_path')

# Only lint bash scripts
if [[ "$file_path" == *.sh ]]; then
    if ! shellcheck "$file_path" 2>&1; then
        echo "shellcheck found issues in $file_path" >&2
        exit 2  # exit 2 blocks and gives Claude feedback
    fi
fi

exit 0

