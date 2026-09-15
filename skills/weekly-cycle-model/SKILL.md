---
name: weekly-cycle-model
description: >
  The shared model of the weekly cycle — the sequence, the artifact contract,
  and the rules every cycle skill obeys. Read before running any of them.
---

# Weekly cycle model

A **cycle** is one ISO week of work, measured against goals written before it
started. The loop closes because the goals set at the end of one cycle are what
the next cycle is graded against.

The week is not a parameter. The cycle id **is** the ISO week, it sorts
chronologically because it sorts lexicographically, and prior-cycle resolution
is a directory listing rather than date arithmetic. That is why the unit is in
the name.

**The cycle is domain-agnostic.** Nothing here knows what kind of work a goal
is. A goal can be a refactor, a portfolio sale, a job application or a health
habit, and the machinery treats them identically: an id, a plan, two estimates,
an outcome. Git is required as file version control for the artifacts, not as a
claim that the work is engineering. A commit count therefore measures only the
goals that happen to produce commits.

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

## Facades and overrides

The four step skills above are the portable machinery. Three **facades** wrap them
into the commands a person actually runs, each user-invoked:

```
recap     → collecting-cycle-data + writing-cycle-review   (close the record)
recheck   → assessing-cycle-goals                          (close the cycle)
reaim     → setting-cycle-goals                             (point the next)
```

A facade owns only orchestration: resolve the cycle id, get inputs into place,
delegate, report. It holds no tally or judgment logic — that lives in the step
skills, which own and reconcile their own output.

**What varies between one consumer and the next is a config pointer with a
default.** A facade reads the pointer or falls back to its shipped default; the
step skills it delegates to never see the pointer, only the resolved input. This
keeps the steps presentation-agnostic and the source-specific parts out of the
portable machinery.

The optional pointers, all under `config.json`:

| Pointer | Overrides | Default when absent |
|---|---|---|
| `task_source.adapter_doc` | how records reach the drop folder | a hand-placed export already in `task_source.path` |
| `review.template` + `review.field_map` | the review's output shape | `writing-cycle-review` renders its own self-contained HTML |
| `assessment.format` | the assessment note's prose shape | the global's own structure |
| `assessment.verify` | the verify discipline recheck follows | `recheck`'s shipped `reference/verify.md` |
| `goals.format` | the goals note's prose shape | the global's own structure |
| `goals.constraints` | the drafting discipline reaim holds | `reaim`'s shipped `reference/constraints.md` |

A consumer that names nothing gets a working loop with default behavior. A
consumer with a house style, a branded review, or a source behind an access wall
names the files that encode those, and the same facades run against them
unchanged. The source-specific and style-specific material lives with that
consumer, never in the shipped skills.
