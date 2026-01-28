---
description: Lint markdown files using markdownlint-cli2
---

## Markdown Lint Command

Lint markdown files using markdownlint-cli2 with project configuration.

**Usage**: `/md-lint [file-or-glob] [options]`

Arguments provided: $ARGUMENTS

---

## Prerequisites

Requires `markdownlint-cli2` to be installed:
```bash
npm install -g markdownlint-cli2
```

If not installed, report error and provide install command.

---

## Arguments

| Argument | Description | Example |
|----------|-------------|---------|
| `file` | Single file path | `tasks.md`, `diary/2026-01-18.md` |
| `glob` | Pattern matching | `"diary/*.md"`, `"pages/**/*.md"` |
| `--fix` | Auto-fix issues where possible | `/md-lint tasks.md --fix` |
| `--strict` | Treat warnings as errors | `/md-lint --strict` |
| `--ignore` | Exclude files matching pattern | `/md-lint #notes --ignore "session-*.md"` |
| `--by-rule` | Group output by rule type | `/md-lint #all --by-rule` |

If no file/glob provided, prompt user with AskUserQuestion:
- Lint current file (if context available)
- Lint all markdown in current directory (`"*.md"`)
- Lint specific directory (`"pages/**/*.md"`, `"diary/*.md"`, etc.)
- Enter custom path or glob

---

## Workflow

### 1. Check Prerequisites

```bash
which markdownlint-cli2
```

If not found:
- Report: "markdownlint-cli2 not installed"
- Provide: `npm install -g markdownlint-cli2`
- Exit

### 2. Check Configuration

If `.markdownlint.json` does not exist:
- Notify: "No .markdownlint.json found. Using markdownlint defaults."
- Suggest: "Run `/md-lint-settings init` to create optimized config for this repo."

### 3. Determine Target

Parse $ARGUMENTS for file path or glob pattern.

If no target specified, use AskUserQuestion:

**Options**:
1. All markdown in root (`"*.md"`)
2. Diary files (`"diary/**/*.md"`)
3. Pages (`"pages/**/*.md"`)
4. Enter specific file or pattern

### 4. Run Linter

Execute markdownlint-cli2 with the target:

```bash
markdownlint-cli2 ":{filepath}"
```

Or for globs:
```bash
markdownlint-cli2 "{glob-pattern}"
```

Use `:` prefix for literal file paths (prevents glob interpretation).

If `--fix` flag provided:
```bash
markdownlint-cli2 --fix ":{filepath}"
```

### 5. Parse and Report Results

**If no errors**:
```
Lint passed: {target}
No issues found in {N} file(s).
```

**If errors found**:
```
Lint results: {target}
Found {N} issue(s) in {M} file(s):

{filename}:{line}:{col} {rule-id} {message}
...

Common fixes:
- MD013: Reduce line length or run with --fix
- MD009: Remove trailing spaces (--fix can help)
- MD032: Add blank lines around lists
```

Group errors by file for readability if multiple files.

**If `--by-rule` flag provided**, group output by rule instead of by file:
```
Lint results: {target}
Found {N} issue(s) across {M} file(s):

MD009 (trailing-spaces): 45 occurrences
  - notes/file1.md: lines 3, 15, 22
  - notes/file2.md: lines 8, 12

MD024 (duplicate-heading): 12 occurrences
  - notes/chat-log.md: lines 50, 120, 180
  ...
```

This makes it easier to decide whether to fix issues or disable rules.

---

## Ignore Patterns

The `--ignore` flag excludes files from linting:

```bash
/md-lint "notes/**/*.md" --ignore "session-*.md"
/md-lint #all --ignore "reconcile-*.md" --ignore "create-*.md"
```

For persistent ignores, create `.markdownlintignore` in repo root:
```
notes/session-*.md
notes/create-*.md
tmp/
```

---

## Common Patterns

| Pattern | Description |
|---------|-------------|
| `"*.md"` | All markdown in current directory |
| `"**/*.md"` | All markdown recursively |
| `"diary/*.md"` | All diary entries |
| `"pages/**/*.md"` | All pages recursively |
| `"clients/**/*.md"` | All client files |
| `"#diary"` | Shorthand for diary directory |

**Shortcuts** (expand these before running):
- `#diary` → `"diary/**/*.md"`
- `#pages` → `"pages/**/*.md"`
- `#clients` → `"clients/**/*.md"`
- `#projects` → `"projects/**/*.md"`
- `#all` → `"**/*.md"`

---

## Fix Mode

When `--fix` is specified:

1. Run with `--fix` flag
2. Report what was fixed:
   ```
   Fixed {N} issue(s) in {M} file(s):
   - tasks.md: 3 trailing spaces removed
   - diary/2026-01-18.md: 1 list spacing fixed
   ```
3. Report remaining unfixable issues (if any)

**Fixable rules include**:
- MD009: Trailing spaces
- MD010: Hard tabs
- MD012: Multiple consecutive blank lines
- MD023: Heading indentation
- MD030: List marker spacing
- MD037: Spaces inside emphasis markers
- MD038: Spaces inside code span elements
- MD047: File should end with newline

---

## Error Handling

- **Command not found**: Provide install instructions
- **File not found**: Report and suggest checking path
- **Invalid glob**: Report glob syntax error
- **Config parse error**: Suggest `/md-lint-settings reset`
- **Permission error**: Report with file path

---

## Examples

```
/md-lint tasks.md
/md-lint "diary/*.md"
/md-lint pages/index.md --fix
/md-lint #all --strict
/md-lint
```

The last example (no args) prompts for target selection.

---

## Integration Notes

- Uses `.markdownlint.json` if present (create with `/md-lint-settings`)
- Works with Obsidian's markdown flavor
- Respects `.markdownlintignore` if present (for excluding files)

---

## Phase 6: Completion and Feedback

After linting is complete:

1. **Offer configuration updates** (if errors were found):
   - "Would you like to update your lint settings with `/md-lint-settings`?"
   - Useful when errors reflect style preferences rather than actual issues

2. **Request feedback**:
   - Ask: "Would you like to suggest any improvements to the `/md-lint` command for future use?"
   - If suggestions provided, note them for future implementation
   - If no suggestions, thank the user and conclude
