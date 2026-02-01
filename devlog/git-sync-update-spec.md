# Git Sync Command Update Specification

This document describes updates to the global `/git-sync` command.

## New Options

### `--auto` Option

**Purpose:** Non-interactive mode for automation and scripts.

**Behavior:**
- Automatically decides whether to make one commit or group into logical commits based on file categories
- Proceeds without user confirmation
- Uses generated commit messages without review
- Suitable for cron jobs, hooks, or scripted workflows

**Decision logic for commit grouping:**
- If all changes are in the same category (e.g., all diary files): single commit
- If changes span 2+ categories with 3+ files each: group into separate commits by category
- Otherwise: single commit with summary message

**Incompatibilities:**
- Cannot be used with `--pr` (PR creation requires interactive input)

**Example usage:**
```bash
/git-sync --auto
```

### `--pr` Option

**Purpose:** Create a pull request after committing and pushing changes.

**Behavior:**
1. Complete normal git-sync workflow (commit and push)
2. Prompt user for PR details:
   - Target branch (default: main)
   - PR title (suggest based on commit message)
   - PR description (offer to generate from commit messages)
3. Create PR using `gh pr create`
4. Report PR URL on success

**Requirements:**
- GitHub CLI (`gh`) must be installed and authenticated
- Interactive mode only (user must confirm PR details)

**Incompatibilities:**
- Cannot be used with `--auto` (requires user interaction)

**Example usage:**
```bash
/git-sync --pr
```

## Updated Mode Detection

Replace the current mode detection with:

```
### Mode Detection

Determine the execution mode from flags:
- **Auto mode** (`--auto`): Non-interactive, auto-decides grouping, no confirmations
- **PR mode** (`--pr`): Interactive with PR creation at end
- **Interactive** (default): User confirms commit messages before proceeding

**Flag validation:**
- `--auto` and `--pr` are mutually exclusive
- If both provided, error: "Cannot use --auto and --pr together. PR creation requires interactive mode."
```

## Changes to Existing Phases

### Phase 3: Analyze Changes

Add after step 4 (Interactive mode presentation):

```
5. **Auto mode**: Analyze file categories and decide grouping:
   - Count files per category
   - If single category OR total files <= 3: single commit
   - If 2+ categories with 3+ files each: group by category
   - Proceed directly to commit without user input
```

### Phase 4: Generate and Review Commit Messages

Update the review section:

```
**Interactive mode - Review step:** (unchanged)

**Auto mode**: Skip review, commit directly with generated message.

**PR mode**: Same as interactive, but remind user: "After commit, you'll be prompted for PR details."
```

### Phase 5: Commit and Push

Add new step 6 for PR mode:

```
6. **PR mode only**: After successful push:
   a. Check if `gh` CLI is available
   b. Prompt for target branch (default: main or master)
   c. Suggest PR title based on commit message(s)
   d. Ask if user wants auto-generated description or custom
   e. Run `gh pr create --title "..." --body "..."`
   f. Report PR URL or error
```

### Phase 6: Summary

Update summary to include PR info when applicable:

```
Git Sync Complete
-----------------
- Pulled: {n} commits from remote
- Committed: {n} files in {n} commit(s)
- Pushed: {n} commit(s) to remote
- PR: {url} (if --pr used)
```

## Error Handling Additions

Add to error handling section:

```
- **--auto + --pr conflict**: Error immediately, do not proceed
- **gh not installed** (PR mode): Error after push, suggest installing gh CLI
- **gh not authenticated** (PR mode): Error after push, suggest `gh auth login`
- **PR creation fails**: Report error, but commit/push already succeeded
```
