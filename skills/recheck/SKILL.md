---
name: recheck
description: >
  Close a finished cycle against the goals it started with — judge each goal,
  score the estimates, write the assessment, and freeze the cycle into history.
  A thin facade over assessing-cycle-goals.
disable-model-invocation: true
---

# Recheck

**Closes** a cycle. Judges each goal against the record, scores how well the
estimates predicted reality, writes `assessment.md`, and appends the frozen row to
`history.jsonl`.

```
assessing-cycle-goals   → <cycle>/assessment.md
                        → one appended line in history.jsonl
```

**This is a facade.** The doctrine — the freeze rules, the history row shape, the
estimate axes — lives in the `weekly-cycle-model` skill. Read it first. This
file owns the verify discipline and the orchestration.

Closing is irreversible in practice. The appended row is what every trend reads,
and correcting it later is an explicit amendment, never a rerun.

Everything vault-specific is a **config pointer with a default**. The verify
discipline below is the default; a consumer that wants a different one points
`assessment.verify` at its own file. The note shape is the global's own unless
`assessment.format` names one.

---

## 1. Resolve the cycle

Resolve the target cycle id from `config.json`'s `unit` and `timezone`. Default to
**the cycle that just ended**. Resolve a bare period number to a full id before
delegating.

**Done when** the target cycle id is fixed and stated.

## 2. Check the preconditions

Stop and say so rather than working around any of these:

- **No `goals.md` for the cycle** → nothing to measure. `assessing-cycle-goals`
  refuses here and does not reconstruct. Do not infer goals from `data.json` or
  the review; a cycle graded against a description written afterward is grading
  itself.
- **No `data.json`** → collection has not run for this cycle. Offer to run
  `recap`.
- **`assessment.md` already exists** → the cycle is closed. Ask before
  overwriting, and note that a correction to a closed cycle is an amendment
  recorded inside `assessment.md`, naming what changed, what it said before and
  who directed it. It is never a silent rewrite of what the document claimed.

**Done when** all three hold, or the run has stopped and said why.

## 3. Read in the right order

1. `<cycle>/goals.md` — what was promised
2. `<cycle>/data.json` — the primary record
3. `<cycle>/review.html` — narrative only, if it exists

**Goals come first**, so the assessment is framed by what was promised rather than
by what the review chose to emphasize.

**Done when** goals and the record are loaded.

## 4. Verify before drafting

Follow the verify discipline — `reference/verify.md` by default, or the file
`config.json`'s `assessment.verify` names. The short form:

**The review is not a source.** It is narrative written from the same data, and it
compresses. Every figure and framing is checked against `data.json`, `git tag`, or
`git log` before it enters a sentence.

A wrong number is worse than a missing one. If a figure cannot be verified, leave
it out.

**Done when** every figure that will appear has been checked against the primary
record.

## 5. Assess

Invoke **`assessing-cycle-goals`** for the resolved cycle id. When `config.json`
names an `assessment.format`, hand it as the shape for the prose body.

It judges each goal hit/partial/missed with cited evidence, scores the estimates
against outcomes, writes `assessment.md`, and appends the history row.

Two things to carry into that run:

**Estimates may be absent.** Cycles predating the theory/practice pair have
nothing to score; the estimate-scoring step is skipped rather than fed invented
inputs. The history row still carries `"estimate": null` explicitly on every goal.

**A goal with no trace at all is `missed`**, and it is the most informative
outcome in the family. Reserve `partial` for work genuinely begun, not as a
softened `missed`.

**Done when** `assessment.md` exists, every goal from `goals.md` appears in it, and
exactly one valid line was appended to `history.jsonl`.

## 6. Report and point onward

State each goal's outcome, the calibration finding, and that the cycle is closed.

Surface any carried-goal pattern here even though `reviewing-cycle-trends` owns it
formally. The user is about to set goals, and this is the last moment the finding
can still change what they write.

> `2026-W32` closed. 2 hit, 1 missed. `g-3d8f` missed for the third cycle running.
> Next: `reaim` to set the coming cycle.

**Done when** the outcomes are in chat, any carried pattern is named, and the next
command is given.

---

## Working with the user

**Expect rewrites.** Draft a section, show it, take the edit. A section the user
rewrites is the spec learning something — offer to fold a general pattern into the
format file when it looks general rather than one-off.

**Never take a framing from the review because it reads well.** If it cannot be
checked, cut it.

**Ask where the record is silent.** Non-code work often leaves no trace in git or
tasks. Ask the user rather than inferring an outcome from absence.
