---
name: recap
description: >
  Close out a finished cycle's record — collect what happened into the primary
  record, then optionally write the readable review. A thin facade over
  collecting-cycle-data and writing-cycle-review.
disable-model-invocation: true
---

# Recap

Closes out a cycle's record. Two steps of the weekly cycle, run back to back:

```
collecting-cycle-data   → <cycle>/data.json     (mechanical, goal-blind)
writing-cycle-review    → <cycle>/review.html   (optional, narrative)
```

**This is a facade.** The doctrine — the trust seam, the freeze rules, the time
rules — lives in the `weekly-cycle-model` skill. Read it first. This file
owns only the orchestration: resolve the cycle, get the task export into place,
delegate, report.

Everything vault-specific is a **config pointer with a default**. A consumer that
names nothing gets the default behavior; a consumer that points `config.json` at
its own files gets those instead. The facade reads the pointer or falls back; the
global skills it delegates to never see the pointer, only the resolved input.

---

## 1. Resolve the cycle

Resolve the target cycle id from `config.json`'s `unit` and `timezone`. For
`unit: iso-week`, the id is `<ISO-year>-W<ISO-week>` in the configured timezone.

Default to **the cycle that just ended**, since recap closes a finished cycle.
Honour an explicit cycle when given. A bare period number (`32`) is shorthand —
resolve it to a full id (`2026-W32`) before delegating. Every global skill speaks
full cycle ids only.

All cycle and date math in the configured timezone, never UTC — UTC rolls the ISO
week early on Sunday evenings and files Sunday-night commits in the wrong cycle.

**Done when** the target cycle id is fixed and stated to the user.

## 2. Place the task export

Skip when no task source is configured: git alone is a complete run, just as a
task source alone is a complete run when there is no git.

`config.json`'s `task_source` names how records reach the drop folder. The
**default** is a hand-placed export already sitting in `task_source.path`: nothing
to do but confirm it is present and current. When `task_source.adapter_doc` points
at an adapter, **follow that document** to obtain and normalize the records into
the drop folder — the adapter absorbs whatever the source needs (a different
location, an access wall, native field names that must map onto the contract
roles) so the global never learns about it.

**If records cannot be obtained, stop and ask.** Never fabricate counts, and never
let collection run against a stale export from a previous cycle — that produces a
frozen cycle of plausible wrong numbers.

**Done when** the export sits in the drop folder for this cycle, or the run has
stopped and said why.

## 3. Collect

Invoke **`collecting-cycle-data`** for the resolved cycle id.

It reads `config.json` for the timezone, scan roots, excludes and author emails,
walks git, reads the drop folder, and writes `data.json` — the primary record. It
matches the task records against its own role contract and reconciles the totals
before writing.

**Do not hand-count commits, and do not write `data.json` yourself.** One writer
of the primary record, or the trust seam means nothing.

**Done when** `<cycle>/data.json` exists and its cycle id matches.

## 4. Write the review

The review is narrative and **optional** — skipping it blocks nothing, and nothing
machine-readable consumes it.

Invoke **`writing-cycle-review`** for the same cycle id. By default it renders its
own self-contained review from `data.json`. When `config.json` names a
`review.template` (with a `review.field_map` describing how `data.json` maps onto
that template), hand both to the global as the shape to fill instead — the way a
consumer imposes a fixed house style on the output.

The review never reads `goals.md`; the comparing is assessment's job. The insight
lives in the **gap** between attention (tasks) and output (commits): high commits
with low tasks is a hidden heavy lifter, high tasks with near-zero commits is a
coordination thread. Those two callouts are the review's spine.

**Done when** `<cycle>/review.html` exists, or the user chose to skip it.

## 5. Report and point onward

State the cycle id, the totals `collecting-cycle-data` reconciled, and where the
files landed.

> `2026-W32` collected — 47 commits across 4 repos, 18 tasks done.
> `data.json` and `review.html` written.
> Next: `recheck` to measure the cycle against the goals it started with.

**Done when** the totals are in chat and the next command is given.

---

## Rules

- **Recap writes the record; it does not judge it.** Both steps are blind to
  `goals.md`. Assessment does the comparing, and it reads `data.json`.
- **One writer of the primary record.** `collecting-cycle-data` owns `data.json`.
  A second tally in this facade would be a second answer to a settled question,
  which is why there is no verification step here — the writer reconciles its own
  output.
- **The review compresses; the record does not.** Quote no figure from
  `review.html` downstream without checking `data.json`. This is the trust seam,
  and `recheck` depends on it.
- **Derive fresh, then freeze.** Git is read live at collection time. A past
  cycle's figures must not change when repos move on.
- **All cycle and date math in the configured timezone.**
