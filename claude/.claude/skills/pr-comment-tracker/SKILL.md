---
name: pr-comment-tracker
description: Pull all review comments off a GitHub PR and write a triage tracker note (index, comment link, author, file:line, description, status) to ~/dev/notes/pr/. Use when processing PR/MR review feedback comment-by-comment, or when asked to track/triage comments from Copilot, CodeRabbit, or other bots on a PR.
---

Build a persistent triage note for a PR's review comments, so they can be worked through one at a time in a later conversation without re-fetching from GitHub each time. Read-only — this skill never replies to or resolves comments; it only produces the tracker. Posting replies is a separate, explicitly-confirmed action (see repo's CLAUDE.md GitHub rules).

No preamble — run the steps and show the resulting file.

## Steps

### 1. Resolve PR number and repo

PR number comes from the skill arg or the user's message. If missing, ask for it.

Repo defaults to the current directory's origin:

```bash
gh repo view --json nameWithOwner -q .nameWithOwner
```

If the user names a different repo/PR explicitly, use that instead.

### 2. Fetch PR metadata

```bash
gh pr view <num> --repo <owner>/<repo> --json title,url,headRefName,state
```

### 3. Fetch inline review comments

```bash
gh api repos/<owner>/<repo>/pulls/<num>/comments --paginate
```

Each element has: `id`, `in_reply_to_id` (present only on replies), `user.login`, `path`, `line` or `original_line`, `body`.

### 4. Fetch review-level (non-inline) comments

```bash
gh api repos/<owner>/<repo>/pulls/<num>/reviews --paginate
```

Keep only reviews with a non-empty `body` — these are overview/summary comments (e.g. a bot's "Pull request overview"), not per-line feedback. List them in a short separate section if any exist; don't give them table rows.

### 5. Build the table rows

Only top-level comments become rows — skip any comment whose `in_reply_to_id` is set (that's a reply, not a new finding). For each top-level comment:

- **Author** — `user.login` (keep bot suffixes like `[bot]` as-is; this is how you tell automated reviewers apart from humans later)
- **Tag** — if the body starts with a bracketed marker like `[COVERAGE]`, `[DOC]`, `[3]`, extract it verbatim; otherwise `-`
- **Description** — the body with any leading tag stripped, collapsed to one line, truncated to ~150 chars (end on a word boundary, no mid-word cuts)
- **Status** — `Replied` if any other comment in the payload has `in_reply_to_id` equal to this comment's `id`; otherwise `Pending`

Sort rows by `path`, then `line`, so related comments on the same file cluster together. Number them `#1, #2, ...` in that sorted order — the index is positional, not the comment ID.

### 6. Write the file

Path: `~/dev/notes/pr/pr<num>_review_tracker.md` (create the `pr/` dir if missing). This is keyed on PR number alone — `pr-comment-resolver` looks it up by PR id, so don't change the naming scheme without updating that skill too. If a file already exists at that path, read it first — carry forward any `Status` or note text a human already edited in for a comment ID that still appears, rather than clobbering it back to `Pending`.

Format:

```markdown
# PR <num> — <title>

<url> · <state> · branch `<headRefName>`

| # | Comment | Author | File:Line | Tag | Description | Status |
|---|---------|--------|-----------|-----|--------------|--------|
| 1 | [<id>](<url>#discussion_r<id>) | <login> | `<path>:<line>` | <tag> | <description> | <status> |
...

## Review-level comments
(only if step 4 found any — one bullet per review: author, one-line gist, link)

## Reply cheat-sheet

Reply in-thread (requires explicit confirmation of the exact text before posting, per this repo's GitHub rules):

\`\`\`bash
gh api repos/<owner>/<repo>/pulls/<num>/comments/<comment_id>/replies -f body="..."
\`\`\`
```

### 7. Confirm

Print the path written and show the file contents.
