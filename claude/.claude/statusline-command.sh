#!/bin/bash

# Read JSON input from stdin
input=$(cat)

# Extract basic info
user=$(whoami)
host=$(hostname -s)
cwd=$(echo "$input" | jq -r '.workspace.current_dir')

# Get git branch (skip locks)
git_branch=$(cd "$cwd" 2>/dev/null && git -c core.useBuiltinFSMonitor=false rev-parse --abbrev-ref HEAD 2>/dev/null)

# Start building the prompt
printf '\033[38;5;39m%s@%s\033[0m in \033[33m%s\033[0m' "$user" "$host" "$cwd"

# Add git branch if available
if [ -n "$git_branch" ]; then
  printf ' \033[36m(%s)\033[0m' "$git_branch"
fi

# Add context usage information
context_size=$(echo "$input" | jq -r '.context_window.context_window_size // empty')
input_tokens=$(echo "$input" | jq -r '.context_window.current_usage.input_tokens // 0')
cache_creation=$(echo "$input" | jq -r '.context_window.current_usage.cache_creation_input_tokens // 0')
cache_read=$(echo "$input" | jq -r '.context_window.current_usage.cache_read_input_tokens // 0')

if [ -n "$context_size" ] && [ "$context_size" != "null" ]; then
  total_tokens=$((input_tokens + cache_creation + cache_read))
  pct=$((total_tokens * 100 / context_size))

  # Format with thousands separator for readability
  formatted_tokens=$(printf "%'d" $total_tokens 2>/dev/null || echo $total_tokens)
  formatted_size=$(printf "%'d" $context_size 2>/dev/null || echo $context_size)

  printf ' \033[35m[%s/%s tokens, %d%% ctx]\033[0m' "$formatted_tokens" "$formatted_size" "$pct"
fi
