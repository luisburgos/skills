---
name: writing-cycle-review
description: >
  Write the readable narrative of a cycle — charts and prose over the collected
  data, for the person who lived it.
---

# Writing cycle review

Interpretive. Turns `data.json` into `review.html` — the record of a cycle you
actually read.

Consult the `engineering-cycle-model` skill for the layout and the trust seam.

Two facts shape how much rigour this needs:

- **Nothing machine-readable consumes it.** The reader is the person whose cycle
  it was. Skipping it is normal and blocks nothing.
- **It never reads `goals.md`.** The narrative describes what happened, not what
  was meant to happen. Assessment does the comparing, and it reads `data.json`
  rather than this.

## 1. Read the primary record

Read `data.json` for the cycle. Absent → stop and point at
`collecting-cycle-data`. This skill derives nothing from git itself; a second
independent tally would be a second answer to a question that already has one.

**Done when** `data.json` is loaded and its cycle id matches the one requested.

## 2. Re-tally before narrating

Independently re-add the totals from the breakdowns: per-repo and per-day sums
against `commits.total`, per-project against `tasks.total`.

Divergence means a collection bug. **Stop and surface it** rather than narrating
around it — the numbers here are the ones that freeze at assessment, and a review
that quietly disagrees with the primary record is worse than no review.

**Done when** every total reconciles, or a mismatch is reported and the run
stops.

## 3. Find what the numbers alone miss

The insight is in the **gap** between attention and output — where the task
record and the commit record disagree:

- **High commits, low tasks** — a hidden heavy lifter. Real work nobody logged.
- **High tasks, near-zero commits** — a coordination thread. Real work that left
  no code.

Both are invisible in either record alone, which is why the gap is worth naming
explicitly rather than reporting two lists side by side.

Read commit subjects for texture. Subjects carry the shape of the work — version
bumps, refactors, a day spent on one stubborn thing — that counts flatten away.

**Done when** the largest gaps in both directions are identified, or their
absence is stated.

## 4. Write the review

Self-contained HTML, inline `<style>`, no external assets — matching the house
documentation style.

- **Figures come from `data.json`.** Never from your own recollection of the
  numbers, and never rounded into a claim the record does not support.
- **Prose comes from subjects and task titles.** Expand them honestly; a terse
  commit subject is a pointer, not a story, but inventing the story is worse than
  a thin one.
- Per-repo or per-project sections, a daily rhythm, the two gap callouts from
  step 3.
- **Project colors come from `data.json`'s `projects` block** when it carries
  one, so a chart uses the color the reader already recognizes the project by.
  Fall back to a neutral grey for any project the block does not name, and treat
  the block's absence as every project falling back — cycles frozen before the
  field existed have none, and they must still render.

Read the colors from the record, never from the source the record was collected
from. Looking them up live would repaint an old cycle in today's palette, which
is the same freeze this skill's figures obey.

Name the quiet weeks as quiet. A review that finds a triumphant narrative in
every cycle is one nobody will trust when it matters.

**Done when** `review.html` exists in the cycle directory, is self-contained, and
every figure in it appears in `data.json`.

## 5. Report

State the path and the headline finding. Offer the next command:

> `2026-W32` review written. Run `assessing-cycle-goals` to close the cycle.

**Done when** the path is confirmed and the next step named.
