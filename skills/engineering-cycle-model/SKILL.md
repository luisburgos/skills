---
name: engineering-cycle-model
description: >
  The shared model of the engineering cycle — the sequence, the artifact
  contract, and the rules every cycle skill obeys. Read before running any of
  them.
---

# Engineering cycle model

A **cycle** is one ISO week of work, measured against goals written before it
started. The loop closes because the goals set at the end of one cycle are what
the next cycle is graded against.

This is doctrine, not commands. The six action skills run the steps; this holds
what they agree on.

## The loop

```
CLOSING cycle N-1
  1. collecting-cycle-data     → data.json        (mechanical, goal-blind)
  2. writing-cycle-review      → review.html      (optional)
  3. assessing-cycle-goals     → assessment.md    (closes the cycle)

POINTING cycle N
  4. setting-cycle-goals       → goals.md

  reviewing-cycle-trends       → report           (any time, reads history)
```

Step 1 is fixed first: everything downstream verifies against `data.json`. Step 2
is optional and nothing machine-readable consumes it. Step 3 needs `data.json`,
not the narrative.

## Layout

One directory is one cycle:

```
<root>/config.json
<root>/history.jsonl
<root>/raw-data/            ← hand-placed task exports
<root>/2026-W32/
    goals.md                ← written at the END of 2026-W31
    data.json
    review.html
    assessment.md
```

`<root>` comes from config. **No skill hardcodes a path.**

**Cycle id** is the ISO week: `2026-W32`. It sorts lexicographically in
chronological order, so cycle ordering is a directory listing and a sort — never
date arithmetic.

**The prior cycle is the highest existing id below the current one**, not the
arithmetic predecessor. A skipped week is absent, and the loop closes against the
last cycle that actually happened. Arithmetic resolution would block the loop
forever after one missed week.

Absence is therefore ambiguous — a forgotten cycle looks like a deliberate skip.
`reviewing-cycle-trends` owns surfacing gaps.

## The trust seam

`data.json` is the **primary record**. Every figure that reaches any other
artifact traces back to it.

`review.html` is narrative. It compresses, and a compressed figure is not
evidence — quote nothing from it without checking `data.json`.

Both are written **blind to the goals**. Neither reads `goals.md`, so the facts
cannot be bent toward the plan.

## Freeze on assessment

A cycle stays **open** — its artifacts rewritable, its figures re-derivable —
until `assessing-cycle-goals` runs. That act **closes** it and freezes its
outcomes into history.

Closing is an event, not a date. Assessing a cycle late is normal.

Two things freeze at different moments, because they are different in kind:

- **Estimates freeze at set-time.** A theory/practice pair of 95/20 was a
  judgment made on a Monday. No later pass over git reconstructs it. Storing it
  is the only option; rewriting it is a lie.
- **Outcomes freeze at assessment.** They are measurements, so re-derivable in
  principle — but git mutates under rebase, force-push, and moved repos. A
  re-derivation months later can silently produce a different number.

Correcting a closed cycle is an **explicit amendment row**, never a silent
rebuild.

## History

`history.jsonl` is the freeze target, one row per cycle:

```json
{
  "cycle": "2026-W32",
  "unit": "iso-week",
  "goals": [
    {
      "id": "g-7f3a",
      "title": "…",
      "estimate": { "theory": 95, "practice": 20 },
      "outcome": "missed",
      "carried_from": "2026-W31"
    }
  ],
  "measured": { "commits": 34, "repos": 3, "tasks_done": 12 }
}
```

Rows are **appended**, never edited.

## Goal identity

Every goal carries a **stable id**. Carrying a goal into a new cycle copies its
id; a new goal gets a new one.

This exists because the failure that motivated the whole family involved a goal
that was reworded and expanded every cycle while never being started. Text
matching fails on exactly that case. An id keeps its identity while its text
changes.

## The confidence estimate

Every goal carries two numbers, set when the goal is written:

- **Theory** — will these steps produce the result? A question about the world.
- **Practice** — will I actually do them? A question about the person.

Below 80 on either axis means stop and fix **that** axis. Sharpening a plan that
already scores 95 on theory is effort aimed at the number that was never the
problem.

A practice score below 80 forces a choice from a **closed set** — cut the goal,
shrink its scope until practice clears 80, or name concrete support (time
blocked, a dependency removed, a person asked). Support is recorded as a field on
the goal so it travels with the id and becomes countable.

## The gates

The loop only closes if neither end can be skipped:

- `assessing-cycle-goals` **refuses** without goals for the cycle. It never
  reconstructs them — a cycle graded against a description written afterward is
  graded against itself.
- `setting-cycle-goals` **refuses** when the prior cycle has goals but no
  assessment. Dodging assessment makes carry-over invisible, which is the failure
  this family exists to catch.

A true cold start — no prior `goals.md` anywhere — is not a refusal. Nothing was
promised, so nothing carries over.

## Time

The cycle unit is the **ISO week**, Monday to Sunday, in the timezone from
config. It is recorded in config and in every history row.

Commits belong to a cycle by **author date**, converted to the configured
timezone, then reduced to an ISO week. Author date survives rebase; committer
date does not, so a rebase in a later cycle would otherwise drag earlier work
forward and change a frozen figure.

Never compute weeks in UTC. UTC runs ahead of the Americas and rolls the ISO week
early on Sunday evenings, putting Sunday-night commits in the wrong cycle.

## Sources

**Git is required.** Config lists *roots to scan*, not individual repos, so a new
repo is picked up without the config going stale. An exclude list covers archives
and vendored clones. Commits are filtered to the configured authors — a list, so
one person's several git identities across repos all count — merges excluded.

**A task source is optional enrichment.** It is a seam, not a fixed file:
collection asks for "tasks completed in this window". Today that is a hand-placed
export in `<root>/raw-data/`; a different source later is a config change, not a
redesign.
