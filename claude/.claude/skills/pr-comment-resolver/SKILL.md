---
name: pr-comment-resolver
description: Pick one entry from a PR review-comment tracker note (as produced by pr-comment-tracker) and resolve it end-to-end — ponytail-lazy implementation, /tdd or a direct edit depending on the comment's tag, verify, commit, push, reply on GitHub, and update the tracker row with the resolving commit hash. Takes just a PR number and looks the tracker up in ~/dev/notes/pr/ automatically. Use when the user wants to work a tracker entry, address/resolve a PR review comment from a tracker note, or says "do item N from the tracker".
---

Works one tracker row at a time end-to-end, so a PR's review feedback gets closed out with a real commit trail instead of a checkbox. Every implementation decision runs through ponytail — the row states what's wrong, not how much code to write.

No preamble — run the steps.

## Steps

### 1. Load ponytail

Invoke the `ponytail` skill (full intensity unless the user names a different one) before touching any code. It stays active for the rest of this run — every fix below goes through its ladder, not just the obvious COVERAGE ones.

### 2. Resolve tracker file and entry

Args are `<pr-id-or-tracker-path> [entry-number]`. If the first arg is a bare number (a PR id), resolve it to `~/dev/notes/pr/pr<id>_review_tracker.md` — that's where `pr-comment-tracker` writes it. If it's a path (contains `/` or ends in `.md`), use it directly instead. If neither a PR id nor a path is given, ask for it. If the resolved file doesn't exist, say so and stop rather than guessing at a different filename. If `entry-number` is omitted, pick the lowest-numbered row whose Status is `Pending` (a bare `Pending`, not `Done (...)` or `Skipped — ...`).

Read the row: comment ID/link, `file:line`, Tag, Description. Parse owner/repo/PR number from any `github.com/.../pull/<num>` URL in the file — don't assume a fixed header format, trackers vary.

Read the file only through read-tools — never touch or reformat rows other than the one being resolved.

### 3. Surface triage notes before acting

If the tracker has a "Triage notes" (or similar) section commenting on this row — "judgment call", "may not be worth it", "needs generic typing to do cleanly" — surface that note to the user and confirm how to proceed instead of silently building the full version. Ponytail's "no unrequested abstractions" rule bites hardest here: a comment asking to dedup or refactor is not license to invent a new interface.

### 4. Read the code at file:line

Understand what the comment actually points at before picking an approach — the tag names a category, not the fix.

### 5. Pick the approach by tag

| Tag | Approach |
|---|---|
| COVERAGE | If the code under test already exists and works, write the test directly against it — this is verifying existing behavior, not building new behavior, so full red-green-refactor is theater. Reach for `/tdd` only when the comment implies the underlying fix itself is unverified or incomplete (a bug fix with no guard) — then the missing test IS the red step. |
| STYLE | Direct edit (rename, formatting). No skill needed. |
| DOC / DOC_SYNC | Direct edit to the docstring/README/doc file, matching sibling examples already in the codebase. |
| DUPLICATION | If consolidating is same-shape and needs no new abstraction, do it directly. If it needs a new interface/generic type to do cleanly, that's a judgment call — flag it per step 3 rather than building it unasked. |
| anything else / unclear | Ask the user which skill or approach applies before writing code. |

### 6. Verify

Run the repo's actual test/build command for the touched file — check `pixi.toml` tasks or existing CI config, don't guess a command. Show pass/fail before moving on. A tag whose fix has no runnable check (pure doc/style) skips this step.

### 7. Lint

Run the repo's lint task against the changed files only — `pixi run lint-changed` (this repo's `pixi.toml` wraps `pre-commit run`, scoped to what's staged/changed) — not the full-repo `lint` task, which would surface unrelated pre-existing violations. Fix anything it flags in the files this row touched; if it flags files outside this row's scope, leave those alone. Re-stage and re-run after any auto-fix until clean.

### 8. Commit

One commit scoped to this row only. Message: imperative summary of the change, plus a line naming the comment tag/id it addresses. Don't fold in unrelated diffs.

### 9. Push — confirm first

Pushing updates a shared PR branch. State the branch and commit hash, and get explicit confirmation before `git push`.

### 10. Reply on GitHub — confirm first

Draft the exact reply text, referencing the resolving commit hash (`git rev-parse --short HEAD`). Show the drafted text and get explicit approval before posting — this repo's CLAUDE.md requires it for every GitHub write, no exceptions for a routine-looking reply.

```bash
gh api repos/<owner>/<repo>/pulls/<num>/comments/<comment_id>/replies -f body="..."
```

### 11. Update the tracker row

Set Status to `Done (<short-sha>)` — the actual resolving commit, never the bare word "Done". If step 3 led to skipping or deferring the row, record why instead: `Skipped — <reason>`.

### 12. Confirm

Show the updated tracker row and the commit hash. No further summary needed.
