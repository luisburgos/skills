---
name: reviewing-cycle-trends
description: >
  Read across many cycles for the patterns a single cycle cannot show — carried
  goals, estimate calibration, and gaps in the record.
disable-model-invocation: true
---

# Reviewing cycle trends

The loop's memory. Every other skill reads one cycle; this one reads the whole
history and reports. It writes nothing.

Consult the `engineering-cycle-model` skill for the history row shape and goal
identity.

Run it any time — it sits outside the closing sequence. It has little to say
before three or four cycles have accumulated, and that is expected: history
starts empty and fills honestly.

## 1. Read history

Read `history.jsonl`. Each line is one closed cycle.

Rows are the frozen record. Do not re-derive figures from git or from cycle
directories to "check" them — a re-derivation months later legitimately differs
(rebases, moved repos), and treating that difference as an error would relitigate
every closed cycle.

**Segment by `unit` before comparing anything.** A practice score of 70 means
different things at different cycle scales. Only `iso-week` exists today, so this
is one check, not a computation — but comparing across units silently is the
failure it prevents.

Honour amendment rows: a later row correcting an earlier one supersedes it.

**Done when** every row is parsed, segmented by unit, and amendments applied.

## 2. Carried goals

Group goals by **id** across rows. An id in several rows is a carried goal.

Text is not the key. The motivating failure was a goal reworded and expanded
every cycle, which no text match would catch — the id is what survives the
rewording.

**Flag at three.** Report: the id, its title in each cycle (the drift in wording
is itself the finding), the outcome each time, the practice score each time, and
any support promised.

The shape to name outright: carried three or more times, missed each time,
practice low each time. That is a goal being re-listed rather than decided, and
naming it is the entire reason this skill exists.

**Done when** every id appearing in more than one row is reported with its
per-cycle outcome and practice score.

## 3. Estimate calibration

Across all goals in all rows, ask whether the estimates predicted anything:

- **Practice low, missed** and **practice high, hit** → the estimate is working.
- **Practice high, missed** → the estimate missed a real risk. Cluster these and
  look for what they share.
- **Practice low, hit** → pessimistic, or support landed. Check whether support
  was recorded.

Report the counts in each quadrant. If high-practice goals miss as often as
low-practice ones, the estimate is noise, and that is a finding about the
instrument rather than about any goal.

**Done when** every scored goal is placed in a quadrant and the counts reported.

## 4. Cycle gaps

List the ISO weeks between the first and last row. Missing ids are gaps.

A gap is ambiguous by construction — a forgotten cycle and a deliberate skip look
identical on disk, since prior-cycle resolution deliberately steps over absences.
Report the gap; do not diagnose it.

Also report cycles with `goals.md` but no history row: cycles still open,
unassessed. One is normal. Several means the loop stopped closing.

**Done when** every missing and every unclosed cycle in the range is listed.

## 5. Open pass

The three checks above always run. Now read the history for anything else it
shows — trends the fixed checks were not built to see.

Two known candidates that need more data before they mean anything:

- **Chronic low practice with repeated support.** Support promised across several
  cycles and never resolving into a hit. Needs enough support fields to tell a
  pattern from a coincidence.
- **Effort-to-outcome drift.** Measured figures rising while goals keep missing.
  Needs several cycles of figures before drift is distinguishable from noise.

Say when the data is too thin rather than reporting a pattern from two rows. A
finding invented from insufficient history is worse than no finding: it will be
acted on.

**Done when** the open pass has either produced findings with the rows that
support them, or stated that the history is too thin.

## 6. Report

Fixed checks first, in order, so the report has the same shape every run. Open
findings after, clearly marked as such.

Lead with the carried-goal finding when there is one. It is the one that changes
what the user does next.

Recommend nothing beyond naming what the data shows. The decision about a carried
goal belongs to `setting-cycle-goals`, where the gate can actually force it.

**Done when** all three fixed checks are reported with their counts, including
the ones that found nothing, and any open findings cite the rows behind them.
