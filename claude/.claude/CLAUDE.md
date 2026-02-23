# Global Claude Code Instructions

## Git Commit Conventions

Use Conventional Commits format for all commit messages.

### Commit Types

| Type | Description |
|------|-------------|
| `feat` | New feature or functionality |
| `fix` | Bug fix |
| `docs` | Documentation changes |
| `style` | Code style changes (formatting, whitespace) |
| `refactor` | Code refactoring without feature/fix |
| `test` | Adding or updating tests |
| `chore` | Maintenance tasks, config changes |

### Message Format

```
<type>: <short description>

[optional body with more detail]
```

### Examples

- New file: `feat: add git-sync command for automated commits`
- Modified file: `fix: correct numbering in git-sync phases`
- Config change: `chore: update shell configuration`
- Documentation: `docs: add usage instructions to README`

### Multiple Files

When committing multiple related files, use a summary message:
- `feat: add chat export and rename commands`
- `chore: update claude command configurations`

## Interaction Preferences

### Confirmation Style

- **Yes/no questions**: Use y/n format so the user can answer with a single character
  - Example: `Looks good? (y/n)` or `Commit and push? (y/n)`
- **Multiple-choice questions**: Present a numbered list of options so the user can reply with a single number
  - Example:
    ```
    How should we handle this?
    1. Option A — brief description
    2. Option B — brief description
    3. Option C — brief description
    ```
- Keep confirmations concise — present the relevant context, then ask

## Tool Usage Safety

### Read Before Edit/Write

Always use the `Read` tool before modifying any existing file. This is mandatory for:
- Configuration files (`.zshrc`, `.bashrc`, `.profile`, etc.)
- Dotfiles (any file in `~/dotfiles/` or `~/.config/`)
- Any file you didn't create in the current session

### Write vs Edit Tool Selection

| Tool | When to Use | Examples |
|------|-------------|----------|
| `Write` | **New files only** | Creating a new config, adding a new script |
| `Edit` | **Modifying existing files** | Appending to `.zshrc`, updating settings, fixing typos |

**Never use `Write` on existing files** — it overwrites the entire file, destroying all existing data.

### Configuration File Safety Protocol

For dotfiles and configuration files:

1. **Read first**: Use `Read` to see current contents
2. **Identify location**: Where should the new content go?
3. **Use Edit**: Make surgical changes with `old_string` and `new_string`
4. **Verify**: After editing, confirm the file didn't shrink unexpectedly

**If a file modification would reduce file size by >50% or delete more than 10 lines**, present the diff and get explicit approval before proceeding.
