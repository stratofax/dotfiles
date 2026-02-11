---
description: Run a health check on all dotfiles stow packages
---

## Dotfiles Health Check

Validate that all stow packages are correctly symlinked, shell configs pass linting, no hardcoded paths or artifacts exist, and platform portability is maintained.

**Usage**:
- Full check: `/dotfiles-health`
- Single package: `/dotfiles-health --package bash`
- JSON only (no table): `/dotfiles-health --json-only`
- Verbose output: `/dotfiles-health --verbose`

Flags can be combined: `/dotfiles-health --package bash --verbose`

The arguments are provided as: $ARGUMENTS

---

## Phase 1: Parse Arguments & Enumerate Packages

1. Check for flags in $ARGUMENTS:
   - `--package <name>`: Run checks for a single package only
   - `--json-only`: Skip the summary table, only write the JSON report
   - `--verbose`: Show detailed per-check output as agents complete

2. Determine the dotfiles path: `~/dotfiles`

3. Enumerate stow packages by listing directories in the dotfiles path.
   **Include only these packages:** `bash`, `zsh`, `vim`, `tmux`, `fzf`, `git`, `claude`, `.config`
   **Exclude:** `devlog`, `tmp`, `.git`, `.claude` (project-specific), and any non-directory files.

   If `--package <name>` was specified, filter to just that one package. Error if it's not in the valid list.

4. Capture metadata:
   - Timestamp: current ISO-8601 date/time
   - Hostname: output of `hostname`
   - Dotfiles path: absolute path to the dotfiles directory

5. Confirm: "Running health check on {n} package(s)..."

---

## Phase 2: Spawn Per-Package Agents (Parallel)

For each package, launch a **Task agent** (subagent_type: `general-purpose`) that performs 5 checks and returns a JSON object. Launch all package agents in parallel using a single message with multiple Task tool calls.

Each agent prompt must include:
- The package name
- The dotfiles path
- Instructions for all 5 checks below
- The expected JSON output format

Tell each agent to return ONLY a JSON code block with its results — no other commentary.

### Check a) Symlinks

Verify expected symlinks exist and point to the correct targets.

**Use Bash to run `readlink -f` or `ls -la` to verify each symlink.**

Expected symlink mappings per package:

| Package | Expected symlinks |
|---------|-------------------|
| bash | `~/.bashrc`, `~/.bash_aliases`, `~/.bash_prompt`, `~/.profile` — each → `dotfiles/bash/<file>` |
| zsh | `~/.zshrc` → `dotfiles/zsh/.zshrc` |
| vim | `~/.vimrc`, `~/.gvimrc` — each → `dotfiles/vim/<file>` |
| tmux | `~/.tmux.conf` → `dotfiles/tmux/.tmux.conf` |
| fzf | `~/.fzf.bash`, `~/.fzf.zsh` — each → `dotfiles/fzf/<file>` |
| git | `~/.gitconfig`, `~/.gitmodules` — each → `dotfiles/git/<file>` |
| claude | `~/.claude/CLAUDE.md`, `~/.claude/commands`, `~/.claude/agents`, `~/.claude/skills`, `~/.claude/statusline-command.sh`, `~/.claude/hooks` — each → `../dotfiles/claude/.claude/<item>` |
| .config | `~/.config/nvim`, `~/.config/fish`, `~/.config/omf` — each → `../dotfiles/.config/<subdir>` |

For each expected symlink:
- **exists and points correctly** → count as "found"
- **exists but points elsewhere** → add to "broken" list
- **does not exist** → add to "missing" list

Status: "pass" if all found, "warn" if any broken, "fail" if any missing.

### Check b) Hardcoded Paths

Use Grep to search all files in the package directory for `/home/neil` or `/Users/neil`.

**Skip:** `.md` documentation files and `.gitconfig` (which legitimately contains user paths).

For each match:
- If the line is inside a platform-conditional block (`case "$(uname -s)"`, `if [[ "$OSTYPE" == ...`, or similar), mark as **"warn"** with context noting it's platform-guarded.
- If the line is outside any platform guard, mark as **"fail"**.

Status: "pass" if no findings, "warn" if all findings are guarded, "fail" if any unguarded.

### Check c) ShellCheck

Run `shellcheck` on applicable shell files. First check if shellcheck is installed with `command -v shellcheck`.

If shellcheck is not installed, set status to "skip" with message "shellcheck not installed".

Files to check per package:

| Package | Files | Notes |
|---------|-------|-------|
| bash | `.bashrc`, `.bash_aliases`, `.bash_prompt`, `.profile` | Standard shellcheck |
| zsh | `.zshrc` | Use `--shell=bash` approximation |
| fzf | `.fzf.bash`, `.fzf.zsh` | `.fzf.zsh` with `--shell=bash` |
| claude | `statusline-command.sh`, `hooks/lint-bash.sh` | Standard shellcheck |

**Skip entirely** for these packages (not shell scripts): `vim`, `git`, `tmux`, `.config`
Set status to "skip" with message "no shell files" for skipped packages.

Run shellcheck with `--severity=warning` to avoid excessive info-level noise.

For each finding, capture: file, line, code, severity, message.

Status: "pass" if no warnings/errors, "warn" if only warnings, "fail" if any errors.

### Check d) Platform Portability

Search the package directory for platform-detection patterns and check for one-sided guards:

1. Look for `case "$(uname -s)"` or `case "$(uname)"` blocks — check if they handle both `Darwin` and `Linux` cases
2. Look for `$OSTYPE` checks — verify both `darwin*` and `linux-gnu*` are handled
3. Look for unguarded platform-specific paths: `/usr/local/bin` (macOS homebrew), `/opt/homebrew` (Apple Silicon), `/snap/` (Linux snap)

For each one-sided or unguarded pattern found, note the file and line.

**Skip entirely** for packages with no shell scripts: `vim`, `git`, `tmux`
Set status to "skip" with message "no shell files" for skipped packages.

Status: "pass" if all guards are two-sided, "warn" if one-sided guards found, "fail" if unguarded platform paths found.

### Check e) Artifacts

Use Glob to search the package directory for files that don't belong:

Patterns to check: `*.bak`, `*.swp`, `*.swo`, `*~`, `.DS_Store`, `__pycache__/`, `*.pyc`, `.env`, `node_modules/`, `*.log`, `.directory`

For each found artifact, note the file path.

Status: "pass" if none found, "fail" if any found.

### Agent Output Format

Each agent MUST return exactly this JSON structure inside a code block:

```json
{
  "package": "<name>",
  "status": "pass|warn|fail",
  "checks": {
    "symlinks": {
      "status": "pass|warn|fail",
      "expected": 0,
      "found": 0,
      "missing": [],
      "broken": []
    },
    "hardcoded_paths": {
      "status": "pass|warn|fail",
      "findings": [
        { "file": "...", "line": 0, "content": "...", "guarded": true }
      ]
    },
    "shellcheck": {
      "status": "pass|warn|fail|skip",
      "files_checked": 0,
      "findings": [
        { "file": "...", "line": 0, "code": "SC...", "severity": "...", "message": "..." }
      ]
    },
    "platform_portability": {
      "status": "pass|warn|fail|skip",
      "findings": [
        { "file": "...", "line": 0, "issue": "...", "detail": "..." }
      ]
    },
    "artifacts": {
      "status": "pass|fail",
      "findings": []
    }
  }
}
```

---

## Phase 3: Aggregate Results

After all agents complete, collect their JSON outputs.

1. Parse the JSON from each agent's response (extract from the code block).
2. Compute the overall status for each package:
   - **pass**: all checks are pass or skip
   - **warn**: any check is warn, but none are fail
   - **fail**: any check is fail
3. Compute the summary:
   - `total_packages`: number of packages checked
   - `passed`: count of packages with status "pass"
   - `warned`: count of packages with status "warn"
   - `failed`: count of packages with status "fail"
   - `total_issues`: sum of all findings across all checks and packages

---

## Phase 4: Output Summary Table

**Skip this phase if `--json-only` flag is set.**

Print a summary table like this:

```
Dotfiles Health Check
=====================
Host: {hostname}
Date: {timestamp}
Path: {dotfiles_path}

Package   Symlinks  Paths  ShellCheck  Platform  Artifacts  Status
--------  --------  -----  ----------  --------  ---------  ------
bash      4/4       OK     1 warn      OK        OK         PASS
zsh       1/1       OK     OK          OK        OK         PASS
vim       2/2       OK     skip        skip      OK         PASS
tmux      1/1       OK     skip        skip      OK         PASS
fzf       2/2       OK     OK          OK        OK         PASS
git       2/2       OK     skip        skip      OK         PASS
claude    6/6       OK     OK          OK        OK         PASS
.config   3/3       OK     skip        skip      OK         PASS

Summary: {passed} passed, {warned} warned, {failed} failed ({total_issues} issues)
```

Column formatting rules:
- **Symlinks**: `{found}/{expected}` — show count
- **Paths / ShellCheck / Platform / Artifacts**: `OK` if pass, `skip` if skip, `{n} warn` if warn, `{n} FAIL` if fail
- **Status**: `PASS`, `WARN`, or `FAIL`

If `--verbose` is set, also print the detailed findings for any check that is not pass/skip, showing the specific files and issues found.

---

## Phase 5: Write JSON Report

1. Create the report directory: `mkdir -p ~/.local/share/dotfiles-health`

2. Build the full JSON report:

```json
{
  "version": "1.0",
  "timestamp": "<ISO-8601>",
  "hostname": "<hostname>",
  "dotfiles_path": "/home/neil/dotfiles",
  "summary": {
    "total_packages": 8,
    "passed": 0,
    "warned": 0,
    "failed": 0,
    "total_issues": 0
  },
  "packages": {
    "<name>": {
      "status": "pass|warn|fail",
      "checks": {
        "symlinks": { "status": "...", "expected": 0, "found": 0, "missing": [], "broken": [] },
        "hardcoded_paths": { "status": "...", "findings": [] },
        "shellcheck": { "status": "...", "files_checked": 0, "findings": [] },
        "platform_portability": { "status": "...", "findings": [] },
        "artifacts": { "status": "...", "findings": [] }
      }
    }
  }
}
```

3. Write the report to `~/.local/share/dotfiles-health/report.json` using the Write tool.

4. Print: "Report written to ~/.local/share/dotfiles-health/report.json"

5. Final status message:
   - If any packages failed: "Health check completed with failures." (indicate exit code 1)
   - If any packages warned: "Health check completed with warnings."
   - If all passed: "Health check passed — all packages healthy."

---

## Error Handling

- **Agent failures**: If a package agent fails or returns invalid JSON, mark that package as "fail" with an error message in the report.
- **Missing tools**: If shellcheck is not installed, skip shellcheck checks (status: "skip") — do not fail.
- **Permission errors**: Report and continue with other checks.
- **Invalid package name**: If `--package` specifies an unknown package, list valid packages and stop.
