# Shellcheck Hook and Stow - 2026-02-04

## Session Summary

Added a Claude Code hook for automatic shellcheck linting and stowed the claude package to activate it.

## Work Completed

### Claude Code Hooks
- Added `lint-bash.sh` hook that runs shellcheck on `.sh` files
- Hook blocks writes if shellcheck finds issues (exit code 2)

### Stow Operations
- Stowed the `claude` package to symlink hooks to `~/.claude/hooks/`
- Verified symlink creation

## Commits Made

- `feat: add shellcheck hook for bash script linting` (0eb4b84)

## Key Files

- `claude/.claude/hooks/lint-bash.sh` - New shellcheck hook script

## Notes

The shellcheck hook is now active for all Claude Code sessions. It will automatically lint any `.sh` files before they are written, catching common bash scripting issues early.
