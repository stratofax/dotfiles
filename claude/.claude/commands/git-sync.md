---
description: Smart git sync - pull, commit with descriptive messages, push
---

## Git Sync Command

This command performs a complete git synchronization with intelligent commit messages.

**CRITICAL: Always run `git status` first.** Do not assume the working tree state - verify it. This is the most common source of errors in this command.

### Mode Detection

Determine the execution mode:
- **Interactive**: User triggered this command directly
- **Unattended**: Running as part of automation (check for `--unattended` flag or environment)

---

### Phase 1: Pre-flight Check

1. Run `date` to capture the current date/time for logging and timestamps
2. Run `git status` to check current state
3. Run `git fetch --prune` to see if remote has changes (prune removes stale tracking branches)
4. Report:
   - Current branch
   - Uncommitted local changes (if any)
   - Remote changes waiting to be pulled (if any)

---

### Phase 2: Pull with Rebase (if clean)

**Skip this phase if Phase 1 detected uncommitted changes** - `git pull --rebase` requires a clean working tree. Proceed directly to Phase 3 to commit local changes first.

If working tree is clean:
1. Run `git pull --rebase`
2. **If conflict occurs**:
   - **Interactive**: Show conflict details, ask user how to proceed
   - **Unattended**: Stop immediately, log the conflict, generate alert message:
     ```
     [Git Sync Alert] Conflict detected in {repo} at {timestamp}
     Files with conflicts: {list}
     Manual intervention required.
     ```
     (Future: send via email/Telegram)
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

5. **Unattended mode**: Commit all together with a descriptive message

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

**Unattended mode**: Skip review, commit directly with generated message.

---

### Phase 5: Commit and Push

**Only proceed after user approval in interactive mode.**

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

---

### Future Enhancements (tracked in roadmap)

- `--unattended` flag for cron execution
- Alert routing (email, Telegram) on conflicts or failures
- Integration with `/process-tasks` for post-workflow commits
- Separate `/git-pull`, `/git-commit`, `/git-push` commands if needed
