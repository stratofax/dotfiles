---
description: Create or update .markdownlint.json configuration
---

## Markdown Lint Settings Command

Create or update the `.markdownlint.json` configuration file for markdownlint-cli2.

**Usage**: `/md-lint-settings [action]`

Arguments provided: $ARGUMENTS

---

## Actions

If no action specified, show current settings and offer options.

| Action | Description |
|--------|-------------|
| `init` | Create default config (error if exists) |
| `reset` | Reset to defaults (overwrites existing) |
| `show` | Display current configuration |
| `edit` | Interactively adjust settings |

---

## Default Configuration

When creating `.markdownlint.json`, use these defaults optimized for a prose-heavy slipbox/notes repository:

```json
{
  "default": true,
  "MD013": {
    "line_length": 120,
    "heading_line_length": 80,
    "code_block_line_length": 120,
    "tables": false
  },
  "MD024": {
    "siblings_only": true
  },
  "MD033": {
    "allowed_elements": ["br", "details", "summary", "kbd", "sup", "sub"]
  },
  "MD034": false,
  "MD036": false,
  "MD041": false
}
```

**Rule explanations**:

| Rule | Setting | Reason |
|------|---------|--------|
| MD013 | 120 chars | 80 is too strict for prose; disable for tables |
| MD024 | siblings_only | Allow duplicate headings in different sections |
| MD033 | allow some HTML | Useful elements for notes |
| MD034 | disabled | Bare URLs are fine in notes |
| MD036 | disabled | Emphasis as headers is sometimes useful |
| MD041 | disabled | Files don't always need H1 first |

---

## Workflow

### Action: `init` (default if no config exists)

1. Check if `.markdownlint.json` exists
2. If exists: Report "Config already exists. Use `reset` to overwrite or `edit` to modify."
3. If not exists: Create with default configuration
4. Report: "Created .markdownlint.json with slipbox-optimized defaults"

### Action: `reset`

1. Overwrite `.markdownlint.json` with default configuration
2. Report: "Reset .markdownlint.json to defaults"

### Action: `show`

1. Read and display current `.markdownlint.json`
2. Explain each enabled/disabled rule
3. If no config exists, show what defaults would be

### Action: `edit`

1. Read current config (or use defaults if none)
2. Use AskUserQuestion to offer common adjustments:
   - Line length (80, 100, 120, disable)
   - Bare URLs (allow/disallow)
   - Inline HTML (strict/permissive/disable check)
   - First line H1 requirement (on/off)
3. Update config based on selections
4. Write updated `.markdownlint.json`
5. Report changes made

---

## Common Rule Adjustments

When user requests `edit`, offer these options:

**Line Length (MD013)**:
- Strict (80) - Traditional terminal width
- Moderate (100) - Good balance
- Relaxed (120) - Recommended for prose
- Disabled - No line length checking

**Trailing Punctuation in Headings (MD026)**:
- Enabled - Flag headings ending in punctuation
- Disabled - Allow question marks, etc. in headings

**Inline HTML (MD033)**:
- Strict - No HTML allowed
- Permissive - Allow common elements (br, details, kbd, etc.)
- Disabled - All HTML allowed

**Blank Lines Around Lists (MD032)**:
- Enabled - Require blank lines
- Disabled - Allow lists without surrounding blanks

---

## Output

After any action, summarize:

```
Markdown lint configuration: .markdownlint.json

Current settings:
- Line length: 120 (tables exempt)
- Bare URLs: allowed
- Inline HTML: permissive (br, details, summary, kbd, sup, sub)
- First line H1: not required
- Duplicate headings: allowed in different sections

Run `/md-lint` to lint files with these settings.
```

---

## Error Handling

- **Config parse error**: Report JSON syntax issue, offer to reset
- **Unknown action**: List valid actions
- **Write failure**: Report error with details
