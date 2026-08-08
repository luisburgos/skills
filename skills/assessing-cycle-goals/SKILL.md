---
name: assessing-cycle-goals
description: >
  Measure a cycle against the goals it started with, score the estimates that
  were made, and close the cycle by appending to history.
disable-model-invocation: true
---

# Assessing cycle goals

The skill that **closes** a cycle. It compares `goals.md` against `data.json`,
scores how well the estimates predicted reality, writes `assessment.md`, and
appends a frozen row to `history.jsonl`.

Consult the `engineering-cycle-model` skill for the freeze rules, the history
row shape, and the estimate axes.

Closing is irreversible in practice: the row it appends is what every trend
reads, and correcting it later is an explicit amendment, not a rerun. Take the
legwork seriously.

## 1. Refuse without goals

Read `goals.md` for the cycle. **Absent → stop.**

Do not reconstruct the goals from what happened, and do not offer to. A cycle
graded against a description written afterward is graded against itself, and the
resulting row is indistinguishable from an honest one once it is in history.

> `2026-W32` has no `goals.md`. A cycle can only be assessed against goals
> written before it — reconstructing them now would grade the cycle against
> itself. This cycle stays unassessed.

An unassessed cycle is a real state the loop handles. `setting-cycle-goals` will
refuse to move past it, which is the pressure that keeps the loop closed.

**Done when** `goals.md` is loaded, or the run has stopped and said why.

## 2. Read the record

Read `data.json`. Absent → stop and point at `collecting-cycle-data`.

Read `data.json`, not `review.html`. The narrative compresses, and a compressed
figure is not evidence.

Re-add the totals from their breakdowns before using them. These numbers are
about to freeze.

**Done when** both files are loaded and every total reconciles.

## 3. Judge each goal

For each goal in `goals.md`, decide **hit**, **partial**, or **missed**, and cite
the evidence from `data.json` that decides it — commits in the relevant repo,
tasks in the relevant project, or their absence.

Two judgments need care:

- **A goal with no trace at all.** Zero commits, zero tasks. That is `missed`,
  and it is the most informative outcome in the family — the motivating failure
  was a goal that scored `missed` with no trace three cycles running while every
  assessment reported it correctly.
- **A goal whose evidence is real but thin.** `partial` is the honest answer, not
  a softened `missed`. Reserve it for work genuinely begun.

Where the record cannot decide, ask the user rather than inferring. Non-code work
often leaves no trace in either source.

**Done when** every goal in `goals.md` has an outcome and the evidence that
decided it, with none inferred where the record was silent.

## 4. Score the estimates

Each goal carried **theory** and **practice** scores set before the cycle. Now
compare them against what happened:

- Practice was low and the goal missed → the estimate **worked**. It named the
  risk. The question is why the gate's remedy did not fire.
- Practice was high and the goal missed → the estimate was **wrong**, and that is
  the finding worth writing down. Something predicted the miss and was not
  captured.
- Practice was low and the goal hit → the estimate was **pessimistic**, or
  support did land.

Score calibration per goal, not as an aggregate. An aggregate hides the case that
matters.

Where a goal carries a **support** field, check whether the support actually
materialised. Support promised and not delivered is the pattern that makes a
carried goal look decided when it was only re-listed.

**Done when** every goal's estimate is scored against its outcome, and every
support field is resolved as delivered or not.

## 5. Write `assessment.md`

Per goal: id, title, estimate, outcome, the evidence, the calibration judgment,
and support resolution where present.

Then the cycle-level reading — what the pattern across goals says. Carried goals
deserve explicit attention: a goal appearing for the third time with practice
still low is the exact shape the family exists to catch, and burying it in a
per-goal list is how it survived three cycles before.

**Done when** `assessment.md` exists in the cycle directory and every goal from
`goals.md` appears in it.

## 6. Append the history row and close

Append **one line** to `history.jsonl` — the row shape is in
`engineering-cycle-model`. It carries goal ids, titles, estimates, outcomes,
`carried_from` where set, and the measured figures from `data.json`.

Append only. Never edit an existing row. If a past row is wrong, append an
amendment row that says so explicitly — a silent rebuild makes every earlier
trend report unreproducible.

Verify before writing: the row is valid JSON on a single line, its goal ids match
`goals.md`, and its measured figures match `data.json`.

Appending closes the cycle. Its artifacts stop being rewritable, and its figures
are now what every trend reads.

**Done when** exactly one line is appended, it parses, and its ids and figures
match the two source files.

## 7. Report and point onward

State each goal's outcome, the calibration finding, and that the cycle is closed.

> `2026-W32` closed. 2 hit, 1 missed. `g-7f3a` missed for the third cycle running
> with practice at 20 — the estimate called it every time.
> Run `setting-cycle-goals` for the next cycle.

Surface a carried-goal pattern here even though `reviewing-cycle-trends` owns it
formally. The user is about to set goals, and this is the moment the finding can
still change what they write.

**Done when** the outcomes are in chat, any carried-goal pattern is named, and
the next command is given.
