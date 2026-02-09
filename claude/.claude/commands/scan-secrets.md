---
description: Scan repository for accidentally committed secrets and API keys
---

Scan the current repository for secrets, API keys, tokens, and credentials that should not be committed.

**Usage**:
- Full scan: `/scan-secrets`
- Specific directory: `/scan-secrets path/to/dir`
- Dry run (report only, no fix suggestions): `/scan-secrets --dry-run`
- Deep scan (includes git history via gitleaks): `/scan-secrets --deep`

Flags can be combined: `/scan-secrets --deep --dry-run`

The arguments are provided as: $ARGUMENTS

---

## Phase 1: Parse Arguments

1. Check for flags in $ARGUMENTS:
   - `--dry-run`: Report findings only, skip fix suggestions
   - `--deep`: Also scan full git history using gitleaks
   - Path argument: limit scan to a specific directory

2. Default scope: entire repository working tree

3. Confirm: "Scanning {scope} for secrets..."

---

## Phase 2: Pattern Scan

Run Grep searches across the repository for known secret patterns. Run all searches in parallel for speed.

### 2a: Known Token Prefixes

Search for these known API key and token prefixes:

| Pattern | Service |
|---------|---------|
| `sk-ant-api` | Anthropic API key |
| `sk-ant-oat` | Anthropic OAuth token |
| `sk-ant-ort` | Anthropic OAuth refresh token |
| `sk-[a-zA-Z0-9]{20,}` | OpenAI API key |
| `ghp_[a-zA-Z0-9]{36}` | GitHub personal access token |
| `gho_[a-zA-Z0-9]{36}` | GitHub OAuth token |
| `github_pat_[a-zA-Z0-9_]{80,}` | GitHub fine-grained PAT |
| `ghr_[a-zA-Z0-9]{36}` | GitHub refresh token |
| `glpat-[a-zA-Z0-9\-_]{20,}` | GitLab personal access token |
| `xoxb-[0-9]{10,}` | Slack bot token |
| `xoxp-[0-9]{10,}` | Slack user token |
| `AIza[a-zA-Z0-9\-_]{35}` | Google API key |
| `AKIA[A-Z0-9]{16}` | AWS access key ID |
| `-----BEGIN (RSA\|DSA\|EC\|OPENSSH) PRIVATE KEY-----` | Private keys |

### 2b: Generic Secret Patterns

Search for assignments that look like they contain secrets:

| Pattern | What it catches |
|---------|----------------|
| `(?i)(api_?key\|apikey\|api_?secret)\s*[:=]\s*["'][^"']{8,}` | API key assignments |
| `(?i)(secret\|password\|passwd\|token)\s*[:=]\s*["'][^"']{8,}` | Secret/password assignments |
| `(?i)(access_?token\|auth_?token)\s*[:=]\s*["'][^"']{8,}` | Token assignments |

### 2c: File-Based Secrets

Use Glob to check if any of these files are tracked by git:

- `.env`, `.env.*` (except `.env.example`)
- `*.pem`, `*.key`, `*.p12`, `*.pfx`
- `credentials.json`, `*-credentials.json`
- `service-account*.json`
- `id_rsa`, `id_ed25519`, `id_ecdsa`

For each found file, check: `git ls-files {file}` — only flag if tracked.

---

## Phase 2d: Deep Scan (git history)

**Skip this phase unless `--deep` flag is set.**

### Check for gitleaks

1. Run `command -v gitleaks` to check if installed.
2. If **not installed**, display installation instructions and skip deep scan:

   ```
   gitleaks is not installed. Install it to enable --deep scanning:

     Linux (snap):    sudo snap install gitleaks
     Linux (binary):  https://github.com/gitleaks/gitleaks/releases
     macOS (brew):    brew install gitleaks
     Go install:      go install github.com/gitleaks/gitleaks/v8@latest
   ```

   Continue with the rest of the scan (Phases 3-5) without the deep results.

3. If **installed**, proceed with the scan.

### Run gitleaks

1. Determine the report file path using the current date:

   ```bash
   tmp/gitleaks-report-YYYY-MM-DD.json
   ```

2. Run gitleaks against the full git history, writing the JSON report:

   ```bash
   gitleaks detect --source . --report-format json --report-path tmp/gitleaks-report-YYYY-MM-DD.json --verbose 2>&1
   ```

   Note: gitleaks exits with code 1 when leaks are found — this is expected,
   not an error.

3. If a path argument was provided, add `--log-opts -- {path}` to limit the
   scan scope.

### Parse results

1. Read the JSON report file.
2. Count total findings and group by:
   - Rule ID (e.g., `anthropic-api-key`, `generic-api-key`)
   - File path
   - Commit SHA
3. Identify the **top 10 findings** to display in the summary (prioritize
   by recency — most recent commits first).
4. Note any overlap with working tree findings from Phase 2a-2c
   (same file + same pattern = duplicate, mark as "also in history").

---

## Phase 3: Filter Results

Remove false positives:

1. **Skip placeholder values**: Lines containing `...`, `<token>`, `YOUR_`, `xxx`, `example`, `placeholder`, `changeme`, `FIXME`
2. **Skip comments and docs**: Lines that are clearly documentation (markdown code fence examples with truncated values)
3. **Skip gitignored files**: Only report files that are tracked or would be tracked by git
4. **Skip common non-secret matches**: `maxTokens`, `token_count`, `tokenizer`, and other code identifiers that match on the word "token"

---

## Phase 4: Report Findings

Present results grouped by severity:

```
Secret Scan Results
===================
Repository: {repo name}
Scope: {full repo | specific path}
Date: {current date}

🔴 HIGH - Active secrets found in tracked files:
  {file}:{line} - {service} key detected
  {file}:{line} - {description}

🟡 MEDIUM - Possible secrets (review manually):
  {file}:{line} - {pattern matched}

🟢 LOW - Secret-like patterns in safe contexts:
  {file}:{line} - {description} (gitignored / expired / placeholder)

Files scanned: {n}
Patterns checked: {n}
Issues found: {high} high, {medium} medium, {low} low
```

**If `--deep` was used and gitleaks ran**, append a deep scan section:

```
🔍 DEEP SCAN - Git history (gitleaks)
  Commits scanned: {n}
  Secrets found: {n} across {m} commits
  Report: tmp/gitleaks-report-YYYY-MM-DD.json

  Top findings (most recent first):
    {short_sha} ({date}) {file} - {rule_description}
    {short_sha} ({date}) {file} - {rule_description}
    ...

  By category:
    {rule_id}: {count} findings
    {rule_id}: {count} findings
    ...
```

If `--deep` was used but gitleaks is not installed:
```
🔍 DEEP SCAN - Skipped (gitleaks not installed)
  Install gitleaks to scan git history. See instructions above.
```

If `--deep` found no issues:
```
🔍 DEEP SCAN - Git history (gitleaks)
  ✓ No secrets detected in git history.
```

**Combined summary** (if no issues in either scan):
```
✓ No secrets detected in tracked files or git history.
```

---

## Phase 5: Fix Suggestions

**Skip this phase if `--dry-run`.**

If HIGH or MEDIUM findings exist, suggest remediation:

For each finding:
1. **If file should be gitignored**: Suggest adding to `.gitignore` and `git rm --cached`
2. **If secret is inline in code**: Suggest replacing with environment variable reference
3. **If secret is in config**: Suggest moving to a `.env` file

Then remind:
> **Important:** Removing a file from tracking does not remove it from git
> history. The secret is still in past commits. You should:
> 1. Rotate the exposed credential immediately
> 2. Run `/scan-secrets --deep` if you haven't already, to check git history
> 3. For public repos, consider `git filter-repo` to rewrite history

Ask:
> "Would you like me to apply any of these fixes?"
> Options: "Yes, apply all" / "Let me choose" / "No, just noting for now"

---

## Error Handling

- **Large repos**: If scan takes too long, suggest narrowing scope with a path argument
- **Binary files**: Skip binary files automatically
- **Permission errors**: Report and continue
