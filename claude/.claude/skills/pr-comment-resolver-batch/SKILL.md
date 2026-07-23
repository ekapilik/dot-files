---
name: pr-comment-resolver-batch
description: Sequentially resolve every Pending row in a PR review-comment tracker (as produced by pr-comment-tracker) by chaining /pr-comment-resolver runs, one fresh subagent per row. Suggests the next row and waits for confirmation before each one; approval gates (push, GitHub reply) still prompt the user in real time inside that row's subagent. Use when the user wants to work through an entire tracker instead of one row at a time, or says "resolve all the pending comments", "chain through the tracker", "batch resolve PR comments".
---

Runs `/pr-comment-resolver` across every `Pending` row in a tracker, one row per fresh subagent so context never accumulates across rows — the only thing that persists between rows is the tracker file itself.

No preamble — run the steps.

## Steps

### 1. Resolve tracker file

Same resolution rule as `pr-comment-resolver`: args are `<pr-id-or-tracker-path>`. Bare number → `~/dev/notes/pr/pr<id>_review_tracker.md`. Path-like arg (`/` or `.md`) → use directly. Neither → ask. Missing file → say so and stop rather than guessing a different filename.

### 2. Loop over Pending rows

Repeat until no `Pending` row remains:

a. Read the tracker fresh (the previous row's subagent may have just changed it) and find the lowest-numbered row whose Status is a bare `Pending` — not `Done (...)` or `Skipped — ...`.

b. If none remain: this is the natural end, not a pause — go to step 3.

c. Show the row to the user — number, `file:line`, tag, description — as "Next up: #N — ..." and ask whether to proceed, skip it, or stop the chain here. Do not spawn anything without this confirmation; it's the checkpoint between rows.

d. On "proceed": spawn one **foreground** `Agent` (`subagent_type: "general-purpose"`, `run_in_background: false`) with a self-contained prompt telling it to invoke the `pr-comment-resolver` skill for `<tracker-path> <N>` and run it to completion — ponytail pass, verify, lint, commit, and its own push/reply confirmations. The prompt must explicitly tell the agent to use `AskUserQuestion` for those confirmations itself, exactly as `pr-comment-resolver` already specifies — never pre-approve push or the GitHub reply on its behalf from this loop.

e. On "skip": spawn the same way, but the prompt says to mark the row `Skipped — <reason the user gives>` per the skill's own step 11, instead of resolving it.

f. On "stop": end the loop here. No further rows.

g. Wait for the agent to finish (it's foreground — this loop can't pick the next row without seeing the result), report its outcome (commit hash, or skip reason) in one line, and return to (a).

### 3. Why fresh subagents

Each row's code reading, test writing, and lint output lives entirely inside that row's subagent — it never enters this conversation's context. Only the tracker file (small, structured) and a one-line outcome per row persist here, so a 20-row tracker costs this conversation ~20 short summaries, not 20 rows of exploration and back-and-forth.

### 4. Final report

When the loop ends (tracker exhausted or user stopped it), show the tracker's current Status column in full. No further summary needed.
