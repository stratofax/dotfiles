---
description: Fetch, report, and optionally sync multiple git repos in batch
---

## Check All Repos Command

This command scans multiple git repositories, reports their status, and optionally syncs them.

**Flags:**
- `--auto` — Sync all actionable repos without prompting
- `--dry-run` — Report status only, no changes

```
--auto       Sync all without prompting (implies commit + push)
--dry-run    Report only, make no changes
```

---

### Phase 1: Load Repo List

1. Run `date` to capture the current date for timestamps.
2. Check if `~/.claude/repos.txt` exists. Read it with the Read tool.

**If `repos.txt` exists:**
- Parse lines: one absolute path per line
- Skip blank lines and lines starting with `#`
- Validate each path: check that the directory exists and contains a `.git/` subdirectory
- Report: "Loaded N repos (M valid, K invalid)"
- If any paths are invalid, list them with warnings

**If `repos.txt` is missing:**
- Scan `~/Repos/` two levels deep for directories containing `.git/`:
  ```bash
  find ~/Repos -maxdepth 2 -name .git -type d 2>/dev/null | sed 's|/.git$||' | sort
  ```
- Present the discovered list to the user
- Ask if they'd like to save it to `~/.claude/repos.txt`
- If yes, write the file (one path per line, with a header comment)
- If no, use the discovered list for this run only

**Example `repos.txt` format:**
```
# Git repositories to check — one absolute path per line
# Edit this file to add/remove repos
/Users/neil/Repos/stratofax/slipbox
/Users/neil/Repos/stratofax/dotfiles
/Users/neil/Repos/stratofax/bplan
```

---

### Phase 2: Dry-Run Scan

For each valid repo, gather status using `git -C {path}` (never `cd`):

1. `git -C {path} fetch --prune` — fetch latest, prune stale branches
2. `git -C {path} branch --show-current` — get current branch name
3. `git -C {path} status --porcelain` — count local changes (dirty files)
4. `git -C {path} log HEAD..origin/{branch} --oneline` — incoming commits (behind)
5. `git -C {path} log origin/{branch}..HEAD --oneline` — outgoing commits (ahead)

**Classify each repo into one status:**

| Status | Meaning |
|--------|---------|
| `clean` | No local changes, up to date with remote |
| `dirty` | Uncommitted local changes |
| `behind` | Remote has commits not yet pulled |
| `ahead` | Local has commits not yet pushed |
| `diverged` | Both ahead and behind remote |
| `no-upstream` | Current branch has no upstream tracking branch |
| `error` | Fetch or status command failed |

**A repo can be both dirty AND behind/ahead.** Use compound statuses like `dirty+behind` when applicable.

**Error handling per repo:**
- If `git fetch` fails (network error, auth error): retry once, then classify as `error`
- If branch has no upstream: classify as `no-upstream`, still report local changes
- Never let one repo's failure stop processing of others

---

### Phase 3: Summary & Selection

Display a status table. Use the **directory name** (last path component) as the repo label. Example:

```
#  Repo        Branch  Status        Local     Incoming    Outgoing
1  slipbox     main    dirty         3 files   2 commits   0
2  dotfiles    main    clean         -         0           0
3  bplan       main    behind        -         5 commits   0
4  website     main    dirty+ahead   2 files   0           1 commit
5  old-proj    main    error         -         -           -
```

**Mode-dependent behavior:**

- **`--dry-run`**: Display the table and stop. Do not proceed to Phase 4.
- **`--auto`**: Select all repos that are dirty, behind, ahead, or diverged. Proceed directly to Phase 4.
- **Interactive** (default): Display the table, then ask:

  > "What would you like to do?
  > 1. Sync all actionable repos
  > 2. Pick specific repos to sync (enter numbers)
  > 3. Skip — just wanted the status report"

  If user picks option 2, ask which repo numbers to sync.

---

### Phase 4: Sync Selected Repos

For each selected repo, perform the appropriate sync operation based on status.

**IMPORTANT:** Use `git -C {path}` for all commands. Never `cd` into the repo.

**Sync actions by status:**

| Status | Action |
|--------|--------|
| `dirty` | Stage → Commit → Pull --rebase → Push |
| `behind` | Pull --rebase |
| `ahead` | Push |
| `diverged` | Pull --rebase → Push |
| `dirty+behind` | Stage → Commit → Pull --rebase → Push |
| `dirty+ahead` | Stage → Commit → Push |
| `dirty+diverged` | Stage → Commit → Pull --rebase → Push |
| `clean` | Skip |
| `error` | Skip |
| `no-upstream` | Stage if dirty → Commit if dirty → Attempt push (may fail) |

**Commit format for dirty repos:**

Use multiple `-m` flags (not heredocs — heredocs fail in sandboxed environments):

```bash
git -C {path} add -A
git -C {path} commit -m "chore: automated sync 2026-02-14" -m "" -m "Co-Authored-By: Claude Opus 4.6 <noreply@anthropic.com>"
```

Use the actual current date from the `date` command captured in Phase 1.

**Pull with rebase:**
```bash
git -C {path} pull --rebase
```

**Conflict handling:**
- If `git pull --rebase` fails with conflicts:
  1. Run `git -C {path} rebase --abort` immediately
  2. Mark this repo as `conflict` in the results
  3. Report: "Conflict in {repo} — rebase aborted, manual resolution needed"
  4. Continue to next repo — never stop the batch for one conflict

**Push:**
```bash
git -C {path} push
```

- If push fails, mark as `push-failed`, report error, continue to next repo.

**Progress reporting:**
- Print a status line for each repo as it's processed:
  ```
  [1/5] slipbox: committing 3 files... pulling... pushing... done
  [2/5] dotfiles: clean, skipping
  [3/5] bplan: pulling 5 commits... done
  ```

---

### Phase 5: Final Summary

Display a completion summary:

```
Check All Repos — 2026-02-14
─────────────────────────────
  Synced:    3 repos (slipbox, bplan, website)
  Skipped:   1 repo  (dotfiles — clean)
  Errors:    1 repo  (old-proj — fetch failed)
  Conflicts: 0
```

If any repos had errors or conflicts, list them with details:
```
  Errors:
    old-proj: git fetch failed (network timeout)
  Conflicts:
    (none)
```

---

### Error Handling Summary

| Error | Action |
|-------|--------|
| Missing `repos.txt` | Offer to auto-generate from `~/Repos/` |
| Invalid path in list | Skip, include in final summary |
| `git fetch` fails | Retry once, then mark as `error`, continue |
| Auth/SSH error | Mark as `error`, report, continue |
| Rebase conflict | `git rebase --abort`, mark as `conflict`, continue |
| Push fails | Mark as `push-failed`, report, continue |
| No upstream branch | Report in summary, attempt push (may fail gracefully) |
| Empty working tree | Skip commit, proceed with pull/push if needed |
