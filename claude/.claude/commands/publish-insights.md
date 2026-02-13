---
description: Date-stamp insights report and update browsable archive
---

## Publish Insights

Preserve the latest `/insights` report as a dated snapshot and maintain a browsable index page served via the LAN HTTP server.

**Prerequisites:**

- `~/.claude/usage-data/` directory exists (served by `claude-insights.service` on port 8080)
- User has run `/insights` to generate `report.html`

---

### Phase 1: Verify Report

1. Ask the user: "Have you already run `/insights` this session, or should I wait while you do?"
2. Wait for confirmation
3. Check that `~/.claude/usage-data/report.html` exists
4. Verify it was modified today (`date +%Y-%m-%d` matches file mtime date)
5. If file is missing or stale, report the issue and stop

**Output:** "Report: ~/.claude/usage-data/report.html verified (modified today)"

---

### Phase 2: Date-Stamp the Report

1. Get today's date: `date +%Y-%m-%d`
2. Set target: `~/.claude/usage-data/{date}-report.html`
3. Copy `report.html` to `{date}-report.html` (overwrite if exists — one per day)
4. Remove `report.html` (it's now date-stamped)

**Output:** "Published: {date}-report.html"

---

### Phase 3: Update Index

Generate or regenerate `~/.claude/usage-data/index.html`:

1. Scan `~/.claude/usage-data/` for all files matching `*-report.html`
2. Sort reverse-chronologically (newest first)
3. Get current timestamp: `date '+%Y-%m-%d %H:%M'`
4. Write `index.html` with the following structure:

```html
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>Claude Code Insights Archive</title>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body {
      font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
      background: #f8fafc; color: #334155; line-height: 1.65;
      padding: 48px 24px;
    }
    .container { max-width: 800px; margin: 0 auto; }
    h1 { font-size: 32px; font-weight: 700; color: #0f172a; margin-bottom: 8px; }
    .subtitle { color: #64748b; font-size: 15px; margin-bottom: 32px; }
    .report-list { display: flex; flex-direction: column; gap: 12px; }
    .report-card {
      background: white; border: 1px solid #e2e8f0; border-radius: 8px;
      padding: 16px 20px;
      text-decoration: none; color: inherit;
      transition: border-color 0.15s, box-shadow 0.15s;
      display: block;
    }
    .report-card:hover {
      border-color: #94a3b8;
      box-shadow: 0 1px 3px rgba(0,0,0,0.08);
    }
    .report-date {
      font-size: 18px; font-weight: 600; color: #0f172a;
    }
    .report-file {
      font-size: 13px; color: #64748b; margin-top: 4px;
      font-family: monospace;
    }
  </style>
</head>
<body>
  <div class="container">
    <h1>Claude Code Insights Archive</h1>
    <p class="subtitle">Generated {timestamp} &mdash; {count} reports</p>
    <div class="report-list">
      <!-- For each report file, newest first: -->
      <a class="report-card" href="{filename}">
        <div class="report-date">{YYYY-MM-DD}</div>
        <div class="report-file">{filename}</div>
      </a>
      <!-- ... -->
    </div>
  </div>
</body>
</html>
```

5. The HTML template above is the reference design. Generate the full file with all report entries populated.

**Output:** "Index: Updated with {count} reports"

---

### Output Format

```text
Publish Insights

Report: ~/.claude/usage-data/report.html verified (modified today)
Published: {date}-report.html
Index: Updated with {count} reports

Browse: http://192.168.52.21:8080/
```

---

### Error Handling

- **report.html missing**: "No report.html found. Run /insights first, then try again."
- **report.html stale**: "report.html last modified {date}. Run /insights to generate a fresh report."
- **No *-report.html files found**: Should not happen (we just created one), but handle gracefully
