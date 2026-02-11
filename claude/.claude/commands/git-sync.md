---
description: Smart git sync - pull, commit with descriptive messages, push
---

## Git Sync Command

This command performs a complete git synchronization with intelligent commit messages.

**CRITICAL: Always run `git status` first.** Do not assume the working tree state - verify it. This is the most common source of errors in this command.

### Mode Detection

Determine the execution mode:
- **Interactive** (default): User confirms commit messages before proceeding
- **Auto mode** (`--auto` flag): Non-interactive, single commit, no confirmations

```
--auto       Run in non-interactive mode (no prompts, no confirmations)
--no-scan    Skip the pre-commit secret scan
```

**Secret scan behavior:**
- **Interactive** (default): Runs a quick secret scan on changed files before committing
- **`--auto`**: Skips the scan (cannot prompt for remediation)
- **`--no-scan`**: Explicitly skips the scan

---

### Phase 1: Pre-flight Check

1. Run `date` to capture the current date/time for logging and timestamps
2. Run `git status` to check current state
3. Run `git fetch --prune` to see if remote has changes (prune removes stale tracking branches)
4. **Check for incoming changes**: Run `git log HEAD..origin/main --oneline --stat`
   to see what commits exist on remote that haven't been merged locally.
   - If incoming commits exist, report the commit count and which files they touch
   - If any incoming files overlap with locally modified files, warn about
     potential conflicts before proceeding
5. Report:
   - Current branch
   - Uncommitted local changes (if any)
   - Remote changes waiting to be pulled (if any)
   - Incoming commits and affected files (if any)
   - Conflict risk warning (if local and remote changes overlap)

---

### Phase 2: Pull with Rebase (if clean)

**If Phase 1 detected uncommitted changes**, skip the pull but **warn if remote commits are pending:**

> **Warning:** {n} remote commit(s) detected. These will be rebased after your commit.
> Potential conflicts may arise in Phase 5. Proceeding to commit local changes first.

Then proceed directly to Phase 3.

If working tree is clean:
1. Run `git pull --rebase`
2. **If conflict occurs**:
   - **Interactive**: Show conflict details, ask user how to proceed
   - **Auto mode**: Stop immediately, exit with error code 1, print:
     ```
     [git-sync] Conflict detected. Manual intervention required.
     ```
   - Do NOT proceed to commit phase

**Note:** After committing local changes (Phase 5), attempt pull again before push to ensure we're up to date with remote.

---

### Phase 3: Analyze Changes

If there are uncommitted changes:

1. **Check for Git Commit Conventions in CLAUDE.md**

   Look for a "Git Commit Conventions" section in CLAUDE.md that defines file categories and commit message templates.

   **If not found**, prompt the user:
   > "This repository's CLAUDE.md doesn't have a 'Git Commit Conventions' section.
   > This section tells me how to categorize files and generate commit messages.
   >
   > Would you like me to:
   > 1. Add a default Git Commit Conventions section to CLAUDE.md (I'll ask about your directory structure)
   > 2. Skip smart categorization and use generic commit messages for now
   > 3. Cancel git-sync so you can add it manually"

   If user chooses option 1, ask about their repository structure and create an appropriate conventions table.

2. Run `git status --porcelain` to get changed files

3. **Categorize changes** according to the directory mappings in CLAUDE.md's Git Commit Conventions table. Files not matching any defined category should be grouped as "Other".

4. **Interactive mode**: Present the changes and ask:
   > "I found {n} changed files:
   > - {category}: {files}
   > - {category}: {files}
   >
   > Would you like to:
   > 1. Commit all together with a summary message
   > 2. Group into logical commits (diary, tasks, pages, etc.)
   > 3. Review each file and decide"

5. **Auto mode**: Skip prompts, always group all changes into a single commit

---

### Phase 3.5: Quick Secret Scan

**Skip this phase if `--auto` or `--no-scan` is set.**

Scan only the changed files (from `git status --porcelain` in Phase 3) for
secrets before they enter git history. This is a lightweight check — not a
full repo scan.

1. **Extract changed file paths** from the porcelain output (both staged and
   unstaged).

2. **Run known-prefix pattern checks** against only those files. Use Grep
   scoped to each changed file for these patterns:

   | Pattern | Service |
   |---------|---------|
   | `sk-ant-api` | Anthropic API key |
   | `sk-ant-oat` | Anthropic OAuth token |
   | `sk-ant-ort` | Anthropic OAuth refresh token |
   | `sk-[a-zA-Z0-9]{20,}` | OpenAI API key |
   | `ghp_[a-zA-Z0-9]{36}` | GitHub personal access token |
   | `AKIA[A-Z0-9]{16}` | AWS access key ID |
   | `-----BEGIN .* PRIVATE KEY-----` | Private keys |

3. **Run generic secret pattern checks** against only those files:

   | Pattern | What it catches |
   |---------|----------------|
   | `(?i)(api_?key\|apikey\|api_?secret)\s*[:=]\s*["'][^"']{8,}` | API key assignments |
   | `(?i)(secret\|password\|passwd)\s*[:=]\s*["'][^"']{8,}` | Secret/password assignments |

4. **Filter false positives**: Skip lines containing `...`, `<token>`,
   `YOUR_`, `xxx`, `example`, `placeholder`, `changeme`, `FIXME`,
   `[REDACTED]`. Also skip `maxTokens`, `token_count`, `tokenizer` and
   similar code identifiers.

5. **Report results:**

   - **No findings**: Print `Secret scan: clean` and proceed to Phase 4.
   - **Findings detected**: Display each finding with file, line, and
     pattern matched. Then ask:

     > "Secret scan found {n} potential secret(s) in changed files.
     > Would you like to:
     > 1. Review and fix before committing
     > 2. Skip these findings and commit anyway
     > 3. Cancel git-sync"

     If user chooses option 1, suggest fixes per `/scan-secrets` Phase 5
     logic, then restart from Phase 3 after changes are made.

     If user chooses option 3, abort the entire git-sync.

---

### Phase 4: Generate and Review Commit Messages

Create descriptive commit messages based on what changed:

**Use the message templates from CLAUDE.md's Git Commit Conventions table.** The table defines:
- Directory-to-category mappings
- New file message format per category
- Modified file message format per category

**For mixed commits:** Follow the convention in CLAUDE.md (typically: start with primary category, summarize others)

**If no Git Commit Conventions found:** Use generic messages:
- New file: "Add {filename}"
- Modified: "Update {filename}"
- Multiple files: "Update {n} files: {brief list}"

**Interactive mode - Review step:**

After generating the commit message, present it to the user:

> **Proposed commit message:**
> ```
> {generated message}
>
> 🤖 Generated with [Claude Code](https://claude.com/claude-code)
>
> Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>
> ```
>
> Options:
> 1. Approve and commit
> 2. Edit message (provide new message)
> 3. Cancel

Wait for user approval before proceeding to Phase 5.

**Auto mode**: Skip review, commit directly with generated message.

---

### Phase 5: Commit and Push

**Only proceed after user approval in interactive mode. Auto mode proceeds without confirmation.**

1. Stage appropriate files (`git add`)
2. Create commit(s) with approved messages using **multiple `-m` flags** (not heredocs):
   ```bash
   git commit -m "feat: main message" \
     -m "- Detail line 1" \
     -m "- Detail line 2" \
     -m "" \
     -m "🤖 Generated with [Claude Code](https://claude.com/claude-code)" \
     -m "" \
     -m "Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>"
   ```
   **Why multiple `-m` flags:** Heredocs (`<<EOF`) require temp file creation, which fails in sandboxed environments. Multiple `-m` flags work universally.
3. Run `git pull --rebase` (now that working tree is clean)
   - If conflicts occur, handle per Phase 2 conflict rules
4. Run `git push`
5. Report success or failure

---

### Phase 6: Summary and Improvement

After completion, provide a summary:

```
Git Sync Complete
-----------------
- Pulled: {n} commits from remote
- Committed: {n} files in {n} commit(s)
- Pushed: {n} commit(s) to remote
```

**Interactive mode only** - Ask for workflow feedback:

> "How did this git sync work for you?
> - Were the commit messages accurate and helpful?
> - Would you prefer different grouping of files?
> - Any friction points in the process?
>
> Your feedback helps improve this command for next time."

If user provides feedback, save it to the repository's notes directory (check "Default Paths" in CLAUDE.md for "Chat logs" path, defaults to `.claude/notes/`).

---

### Error Handling

- **Network errors**: Retry once, then report failure
- **Auth errors**: Report and suggest checking credentials
- **Conflicts**: Never auto-resolve; always stop and alert
- **Empty commits**: Skip commit phase, report "nothing to commit"

**Exit codes (for scripting with `--auto`):**

| Code | Meaning |
|------|---------|
| 0 | Success |
| 1 | Failure (conflict, push error, network error) |

---

### Future Enhancements (tracked in roadmap)

- Alert routing (email, Telegram) on conflicts or failures in `--auto` mode
- Integration with `/process-tasks` for post-workflow commits
- Separate `/git-pull`, `/git-commit`, `/git-push` commands if needed
- Secret scan in `--auto` mode: log warnings instead of blocking
