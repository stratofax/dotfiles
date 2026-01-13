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
