---
description: Export chat summary to configured output directory
---

## Chat Export Command

Export a summary of the current chat session to the repository's chat log directory.

**Usage**: `/chat-export [topic]`

---

### Configuration

**Output directory**: Check the repository's CLAUDE.md for a "Default Paths" table with a "Chat logs" entry. If not found, default to `devlog/`.

**Filename format**: `YYYY-MM-DD-topic-description.txt`

---

### Process

#### Step 1: Resolve Output Directory

1. Check for `CLAUDE.md` in the repository root
2. Look for a "Default Paths" table with a "Chat logs" entry
3. If found, use that path as `{output_dir}`
4. If not found, use `devlog/` as the default

#### Step 2: Get Current Date

Use bash to get today's date:

```bash
date +%Y-%m-%d
```

#### Step 3: Determine Topic

If topic provided as argument, use it. Otherwise:

1. Analyze the conversation for main themes
2. Identify key activities performed
3. Generate a short (2-5 word) hyphen-separated summary

**Topic guidelines:**
- Use lowercase
- Separate words with hyphens
- Be specific but concise
- Examples: `complete-json-task-migration`, `review-ochs-proposal`, `debug-api-errors`

#### Step 4: Check for Existing File

```bash
ls {output_dir}/YYYY-MM-DD-*.txt
```

If a file with the same date and similar topic exists, either:
- Append a number suffix (e.g., `-2`)
- Ask user if they want to overwrite or rename

#### Step 5: Generate Summary Content

Create a structured summary document:

```markdown
# [Topic Title] - YYYY-MM-DD

## Session Summary

[1-2 sentence overview of what was accomplished]

## Work Completed

### [Category 1]
- Item
- Item

### [Category 2]
- Item
- Item

## Commits Made

[List any git commits made during session]

## Key Files

[List important files created or modified]

## Notes

[Any additional context, next steps, or observations]
```

#### Step 6: Write File

Write to: `{output_dir}/YYYY-MM-DD-topic-description.txt`

Create the output directory if it doesn't exist.

#### Step 7: Confirm

Report:
```
Chat exported to: {output_dir}/YYYY-MM-DD-topic-description.txt
```

---

### Examples

```
/chat-export
# Auto-detects topic, creates {output_dir}/2026-01-05-review-client-tasks.txt

/chat-export debug-login-flow
# Creates {output_dir}/2026-01-05-debug-login-flow.txt

/chat-export
# If topic unclear, asks: "What topic should I use for this export?"
```

Where `{output_dir}` is resolved from CLAUDE.md's "Default Paths" table or defaults to `devlog/`.

---

### Error Handling

- **No conversation context**: Report "No significant work to export"
- **Write failure**: Report error, suggest checking permissions
- **Duplicate filename**: Ask user how to proceed

---

### Design Notes

This command creates a human-readable summary, not a raw transcript. Focus on:
- What was accomplished
- Decisions made
- Files changed
- Next steps

The summary should be useful for future reference without requiring the full conversation context.
