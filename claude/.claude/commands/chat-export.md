---
description: Export chat summary to configured output directory
---

## Chat Export Command

Export the current chat session to the repository's chat log directory—either as a structured summary or the full conversation.

**Usage**: `/chat-export [topic]`

---

### Configuration

**Output directory**: Check the repository's CLAUDE.md for a "Default Paths" table with a "Chat logs" entry. If not found, default to `devlog/`.

**Filename format**:
- Summary: `YYYY-MM-DD-topic-description.md`
- Full chat: `YYYY-MM-DD-topic-description.txt`

---

### Process

#### Step 1: Ask Export Type

Ask the user which export type they want:
- **Summary** - A structured markdown summary of what was accomplished
- **Full chat** - The complete conversation transcript

#### Step 2: Resolve Output Directory

1. Check for `CLAUDE.md` in the repository root
2. Look for a "Default Paths" table with a "Chat logs" entry
3. If found, use that path as `{output_dir}`
4. If not found, use `devlog/` as the default

#### Step 3: Get Current Date

Use bash to get today's date:

```bash
date +%Y-%m-%d
```

#### Step 4: Determine Topic

If topic provided as argument, use it. Otherwise:

1. Analyze the conversation for main themes
2. Identify key activities performed
3. Generate a short (2-5 word) hyphen-separated summary

**Topic guidelines:**
- Use lowercase
- Separate words with hyphens
- Be specific but concise
- Examples: `complete-json-task-migration`, `review-ochs-proposal`, `debug-api-errors`

#### Step 5: Check for Existing File

```bash
ls {output_dir}/YYYY-MM-DD-*.*
```

If a file with the same date and similar topic exists, either:
- Append a number suffix (e.g., `-2`)
- Ask user if they want to overwrite or rename

#### Step 6: Export (Branching)

**If Full Chat:**

1. Create the output directory if it doesn't exist
2. Generate the export command for the user to run:
   ```
   /export {output_dir}/YYYY-MM-DD-topic-description.txt
   ```
3. Present the command to the user and instruct them to run it
4. Skip to Step 7 (confirmation will come from the /export command itself)

**If Summary:**

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

Write to: `{output_dir}/YYYY-MM-DD-topic-description.md`

Create the output directory if it doesn't exist.

#### Step 7: Confirm

**For Summary:**
```
Chat exported to: {output_dir}/YYYY-MM-DD-topic-description.md
```

Then ask the user if they want to run `/git-sync` to commit and push the exported summary.

**For Full Chat:**
The `/export` command will confirm when the user runs it. Remind the user that they can run `/git-sync` afterward to commit and push the export.

---

### Examples

```
/chat-export
# Asks: "Summary or full chat?"
# If summary: creates {output_dir}/2026-01-05-review-client-tasks.md
#             then asks: "Run /git-sync to commit and push?"
# If full chat: outputs "/export {output_dir}/2026-01-05-review-client-tasks.txt" for user to run
#               and reminds: "Run /git-sync afterward to commit and push"

/chat-export debug-login-flow
# Asks: "Summary or full chat?"
# Then creates file or generates command with provided topic
# (Summary also offers /git-sync afterward)

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

This command offers two export modes:

**Summary mode** creates a human-readable summary focusing on:
- What was accomplished
- Decisions made
- Files changed
- Next steps

The summary should be useful for future reference without requiring the full conversation context. After writing the summary, offer to run `/git-sync` to commit and push the changes—this streamlines the workflow of documenting and saving work.

**Full chat mode** generates the `/export` command with the resolved path for the user to run. The value is in determining the output directory, date, and topic—the user then runs the command to complete the export. A reminder is shown to run `/git-sync` afterward since the export hasn't happened yet at the time of the reminder.
