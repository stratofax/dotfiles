# Git Sync: Simplified --auto Option

This document specifies a simplified `--auto` option for the `/git-sync` command.

## Overview

**Purpose:** Enable non-interactive git-sync for automation (cron jobs, hooks, scripts).

**Design principle:** Keep it simple. Auto mode always creates a single commit with a descriptive message. No complex grouping logic.

## Specification

### Flag

```
--auto    Run in non-interactive mode (no prompts, no confirmations)
```

### Behavior Changes by Phase

**Phase 2 (Pull with Rebase):**
- If conflict occurs: stop immediately, exit with error code 1, print:
  ```
  [git-sync] Conflict detected. Manual intervention required.
  ```

**Phase 3 (Analyze Changes):**
- Skip user prompts
- Always group all changes into a single commit

**Phase 4 (Generate Commit Messages):**
- Generate message automatically based on CLAUDE.md conventions
- Skip review step entirely

**Phase 5 (Commit and Push):**
- Proceed without confirmation
- If push fails, exit with error code 1

**Phase 6 (Summary):**
- Print summary to stdout (for logging)
- Skip feedback prompt

### Exit Codes

| Code | Meaning |
|------|---------|
| 0 | Success |
| 1 | Failure (conflict, push error, network error) |

### Example Usage

```bash
# Manual automation
/git-sync --auto

# Cron job (daily sync)
0 9 * * * cd ~/notes && claude --skill git-sync --auto >> /var/log/git-sync.log 2>&1
```

## What This Does NOT Include

- **Commit grouping logic**: Always single commit. Simpler, predictable.
- **Alert routing**: Future enhancement (email/Telegram on failure).
- **PR creation**: Out of scope. Use `gh pr create` separately.

## Implementation Notes

Update the Mode Detection section in the git-sync command:

```markdown
### Mode Detection

Determine the execution mode:
- **Auto mode** (`--auto` flag): Non-interactive, single commit, no confirmations
- **Interactive** (default): User confirms commit messages before proceeding
```

Add to each phase: "**Auto mode:** [specific behavior]" where it differs from interactive.
