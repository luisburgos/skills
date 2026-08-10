---
name: setting-cycle-goals
description: >
  Draft the next cycle's goals with theory and practice confidence estimates,
  and force a decision on any goal you are unlikely to actually do.
---

# Setting cycle goals

Writes `goals.md` for the cycle about to start. Owns the goals format, the
confidence estimate, and the gate that fires when a goal is unlikely to happen.

Consult the `engineering-cycle-model` skill for the estimate axes, goal identity,
and the gates.

This is where the loop is armed. Everything downstream measures against what gets
written here.

## 1. Resolve the prior cycle and its state

Find the **highest existing cycle id below** the target cycle — the last cycle
that actually happened, not the arithmetic predecessor. A skipped week is absent,
and closing against it is correct.

Three states, and they are not interchangeable:

- **No prior `goals.md` anywhere** → cold start. Nothing was promised, so nothing
  carries over. Go to step 2.
- **Prior cycle has `goals.md` and `assessment.md`** → normal. Go to step 2.
- **Prior cycle has `goals.md` but no `assessment.md`** → **refuse.**

> `2026-W31` has goals but was never assessed. Setting fresh goals now would make
> anything carried over invisible — which is the failure this loop exists to
> catch. Run `assessing-cycle-goals` for `2026-W31` first.

Assessment is cheap and the cycle is still open, so the refusal costs one command.
Abandoning a cycle still means assessing it.

**Done when** the prior cycle is identified and its state is one of the three,
with the refusal issued if that is the state.

## 2. Read what came before

On a cold start, skip to step 3 — there is nothing to read.

Otherwise read the prior `assessment.md` for outcomes and calibration, and
`history.jsonl` for carry counts. A goal id appearing in several rows is a
carried goal, and its count is the number that matters.

**Done when** every unmet goal from the prior cycle is listed with its outcome
and its carry count.

## 3. Decide what carries over

Per unmet goal, the user chooses: carry it, or drop it.

**Carrying copies the goal's id.** This is what makes a reworded goal still
recognisable as the same goal three cycles later — the motivating failure was a
goal re-listed with more detail each time, which no text match would have caught.

Set `carried_from` to the prior cycle id.

Where a goal has already been carried twice, say so plainly before asking:

> `g-7f3a` has been carried twice and missed both times, practice 20 both times.
> A third listing without something changing is the pattern that ate four weeks
> last time.

**Done when** every unmet goal is carried with its id preserved or explicitly
dropped.

## 4. Draft the goals

New goals get a fresh id. Keep the set small enough that the practice estimate in
step 5 can be honest — a long list is a practice score problem wearing a
planning costume.

Each goal needs a title concrete enough that step 3 of `assessing-cycle-goals`
can decide hit or missed from git and tasks. "Improve the codebase" cannot be
assessed; "extract the shared cycle-id resolver" can.

**Done when** every goal has an id, a title an assessor could rule on, and
carried goals kept their original ids.

## 5. Estimate theory and practice

Ask for both, per goal, 0 to 100:

- **Theory** — will these steps produce the result? A question about the world.
- **Practice** — will I actually do them? A question about the person.

Ask them separately and let the numbers diverge. Collapsing them into one
confidence score is what hides the diagnosis: the goal that ate four cycles
scored 95 and 20, and every cycle spent sharpening the plan was aimed at the
number that was already fine.

**Done when** every goal carries two independent numbers the user stated.

## 6. Run the gate

**Theory below 80** → the plan is the problem. Work the plan until it clears, or
drop the goal. A vague plan is a theory failure, not a motivation failure.

**Practice below 80** → the gate fires, and the user picks from a **closed set**:

- **Cut** — drop the goal from this cycle. Not a failure; a scarce cycle honestly
  allocated.
- **Shrink** — reduce scope until practice clears 80. The first slice of a large
  goal usually scores far higher than the whole.
- **Support** — keep it at scope and name the concrete backing: time blocked, a
  dependency removed, a person asked. Recorded as a `support` field on the goal,
  so it travels with the id and the next assessment resolves whether it landed.

A written justification is not one of the three. Three cycles of well-written
reasons is exactly what the record shows when this gate is soft.

Support named vaguely is a note wearing the costume of a decision. "Make time for
it" is not support; "Tuesday 9-12 blocked, phone in a drawer" is.

**Done when** every goal clears 80 on both axes, or carries a cut, a shrink, or a
concrete support that names a specific commitment.

## 7. Write `goals.md`

```markdown
---
cycle: 2026-W33
unit: iso-week
goals:
  - id: g-7f3a
    title: Extract the shared cycle-id resolver
    estimate: { theory: 95, practice: 85 }
    carried_from: 2026-W32
    support: "Tuesday 9-12 blocked, phone in a drawer"
  - id: g-c41d
    title: Draft the newsletter for W32
    estimate: { theory: 90, practice: 90 }
---

# Goals — 2026-W33

Prose context, why these, what was dropped and why.
```

Machine-readable frontmatter, because `assessing-cycle-goals` and
`reviewing-cycle-trends` both read these fields. Prose below for the reasoning
that does not fit a field.

**The estimates freeze here.** They are judgments made now, and no later pass
reconstructs them. Once written, they are not revised in light of how the cycle
went — that is the anti-backfill rule, and it is what makes calibration scoring
mean anything.

**Done when** `goals.md` exists in the target cycle directory, its frontmatter
parses, and every goal carries an id and both estimates.

## 8. Report

State the goals with their estimates, what was cut or shrunk, and any support
commitments made.

> `2026-W33` set — 3 goals. `g-7f3a` carried from W32, shrunk to the first slice,
> practice now 85. Support: Tuesday 9-12 blocked.

**Done when** the goals and every gate decision are in chat.
