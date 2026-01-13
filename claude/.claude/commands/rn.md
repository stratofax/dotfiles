---
description: Rename files to follow the naming conventions for this repo
---

Rename files to follow the repository's kebab-case naming convention, updating all internal links.

**Usage**:
- Single file: `/rn path/to/file.md`
- Bulk rename: `/rn --dir path/to/folder`
- Preview only: `/rn --dry-run path/to/file.md` or `/rn --dry-run --dir path/to/folder`

The arguments are provided as: $ARGUMENTS

---

## Naming Convention: kebab-case

**Rule:** `all-lowercase-words-separated-by-hyphens.md`

**Transformations:**
| From | To | Example |
|------|-----|---------|
| Spaces | Hyphens | `My File.md` → `my-file.md` |
| Underscores | Hyphens | `my_file.md` → `my-file.md` |
| TitleCase | Lowercase + hyphens | `MyFileName.md` → `my-file-name.md` |
| ALL CAPS | Lowercase | `brad.md` → `brad.md` |
| Acronyms | Lowercase + hyphens | `APIReference.md` → `api-reference.md` |
| Numbers adjacent to words | Hyphenate | `Project2024.md` → `project-2024.md` |
| Multiple hyphens/spaces | Single hyphen | `my--file.md` → `my-file.md` |

**Exceptions (do not rename):**
- `CLAUDE.md` - special file, keep as-is
- Files matching `YYYY-MM-DD.md` date format - already compliant

---

## Phase 1: Parse Arguments

1. Check for flags in $ARGUMENTS:
   - `--dry-run`: Preview changes without executing
   - `--dir`: Bulk rename all markdown files in a directory

2. Extract the path (file or directory)

3. Validate:
   - If no path provided: error "Please provide a path: `/rn path/to/file.md` or `/rn --dir path/to/folder`"
   - If path doesn't exist: error "Path not found: {path}"
   - If single file mode and not `.md`: error "Only markdown files are supported"

---

## Phase 2: Build Rename List

**Single file mode:**
1. Add the file to the rename list

**Directory mode (`--dir`):**
1. Find all `.md` files in the directory (non-recursive by default)
2. Add each file to the rename list
3. Report: "Found {n} markdown files in {directory}"

---

## Phase 3: Generate New Filenames

For each file in the rename list:

1. Extract filename (without path)
2. Check exceptions:
   - If `CLAUDE.md`: skip
   - If already matches `YYYY-MM-DD.md` date format: skip

3. Apply kebab-case transformation:
   ```
   Algorithm:
   a. Remove .md extension
   b. Insert hyphen before uppercase letters (for TitleCase): "MyFile" → "My-File"
   c. Replace spaces and underscores with hyphens
   d. Convert to lowercase
   e. Replace multiple consecutive hyphens with single hyphen
   f. Remove leading/trailing hyphens
   g. Re-add .md extension
   ```

4. Compare old and new:
   - If identical: mark as "already compliant", skip
   - If different: add to changes list

5. Check for conflicts:
   - If new filename already exists: mark as "conflict", report error

---

## Phase 4: Find Affected Links

For each file being renamed:

1. Search entire repository for links to this file
2. Search patterns:
   - `[text](path/to/oldname.md)`
   - `[text](oldname.md)`
   - `[text](../oldname.md)`
   - Case-insensitive search (links may have different casing)

3. Build a map: `{old_filename: [list of files containing links]}`

---

## Phase 5: Preview Changes

Display a summary:

```
Rename Preview
==============
Mode: {single file | directory}
Path: {path}
Dry run: {yes | no}

Files to rename: {n}
  {old1.md} → {new1.md} ({m} links to update)
  {old2.md} → {new2.md} ({m} links to update)
  ...

Already compliant: {n} files
  {file1.md}
  {file2.md}
  ...

Conflicts (will skip): {n}
  {old.md} → {new.md} (already exists)

Total links to update: {n} across {m} files
```

**If `--dry-run`:** Stop here, do not proceed to execution.

**If not dry-run:** Use AskUserQuestion:
- "Proceed with {n} renames and {m} link updates?"
- Options: "Yes, rename all" / "No, cancel"

---

## Phase 6: Execute Renames

For each file (in order to avoid broken links):

1. **Rename the file:**
   - Use `git mv "{old_path}" "{new_path}"`
   - Handle spaces in paths with proper quoting

2. **Update all links pointing to this file:**
   - For each file containing links:
     - Read the file
     - Replace old filename with new filename (preserve link text)
     - Handle both exact matches and path variations
     - Write updated content

3. **Track progress:**
   - Report each rename as it completes
   - Continue on individual failures, report at end

---

## Phase 7: Report Results

```
Rename Complete
===============
Renamed: {n} files
Links updated: {n} across {m} files

Renamed files:
  {old1.md} → {new1.md}
  {old2.md} → {new2.md}
  ...

Files with updated links:
  {file1.md} ({n} links)
  {file2.md} ({n} links)
  ...

{Errors if any}

Note: Changes are staged but not committed. Use /git-sync to commit.
```

---

## Error Handling

- **File not found**: Skip and report
- **Permission denied**: Skip and report
- **Naming conflict**: Skip and report (don't overwrite existing files)
- **Link update failed**: Report which files failed, continue with others
- **Partial failure**: Complete what's possible, report all failures at end
