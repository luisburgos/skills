---
name: reaim
description: >
  Set the coming cycle's goals — draft 3 to 5 goals with theory and practice
  confidence estimates, carry or drop what did not land, and force a decision on
  anything unlikely to actually happen. A thin facade over setting-cycle-goals.
disable-model-invocation: true
---

# Reaim

Points the coming cycle at 3 to 5 goals, informed by the gap the assessment just
named.

```
setting-cycle-goals   → <cycle>/goals.md
```

**This is a facade.** The doctrine — the estimate axes, goal identity, the gates —
lives in the `weekly-cycle-model` skill. Read it first. This file owns the
drafting discipline and the orchestration.

**Aiming, not resetting.** The `re-` is the point: the cycle is not starting from
nothing, it is correcting from where it last pointed. That correction is mechanical
in the model — a carried goal keeps its id, so it stays recognisable however its
wording changes.

Everything vault-specific is a **config pointer with a default**. The drafting
constraints below are the default; a consumer points `goals.constraints` at its
own file to override. The note shape is the global's own unless `goals.format`
names one.

**The default method is GPS**, documented in `reference/interrogation.md`: how to
ask for a `why`, `anti_goals`, `plan`, `crystal_ball`, `remedies` and `system`,
and how to tell when an answer is hollow. Only `plan` is in the global contract,
because without it the estimate has no subject. The rest belong to the method, so
a consumer that wants different fields points `goals.format` at its own shape and
`goals.constraints` at its own discipline, and this facade runs unchanged.

---

## 1. Resolve the cycle

Resolve the target cycle id from `config.json`'s `unit` and `timezone`. Default to
**the cycle starting now**. Resolve a bare period number to a full id before
delegating.

**Done when** the target cycle id is fixed and stated.

## 2. Expect the refusal, and do not work around it

`setting-cycle-goals` **refuses** when the prior cycle has `goals.md` but no
`assessment.md`.

That refusal is correct and this facade does not offer an escape hatch. Setting
fresh goals over an unassessed cycle makes anything carried over invisible, which
is the exact failure the family exists to catch. The remedy is one command:

> The prior cycle has goals but was never assessed. Run `recheck` for it first.

Assessment is cheap and the cycle stays open until it runs. Abandoning a cycle
still means assessing it — an abandoned cycle honestly closed is a real outcome; a
skipped one is a hole in the record.

**A true cold start is not a refusal.** No prior `goals.md` anywhere means nothing
was promised, so nothing carries over.

**Done when** the prior cycle is identified and its state is cold start, normal, or
the refusal has been issued.

## 3. Read the inputs

1. **The prior `assessment.md`** — outcomes and calibration. Its closing section
   names what did not happen and why. Strongest single input.
2. **`history.jsonl`** — carry counts. A goal id appearing across several rows is a
   carried goal, and its count is the number that matters.
3. **The user's own planning** — whatever they say in this session.

**The assessment says what is unfinished. It does not say what matters next.** Only
the user does. Weight their planning above the record.

**Done when** every unmet goal is listed with its outcome and its carry count.

## 4. Draft

Invoke **`setting-cycle-goals`** for the resolved cycle id. Give it the drafting
constraints — `reference/constraints.md` by default, or the file `goals.constraints`
names — and, when `config.json` names a `goals.format`, that too.

Give it **`reference/interrogation.md`** as well, unless `goals.format` names a
shape of its own. It carries the questions behind each field and the failure each
one hides, which is what the global skill cannot supply: the contract can say a
field must be present, not whether the answer in it is real.

It handles carry-or-drop with id preservation, the plan, the estimate interview,
the gate, and writes `goals.md` with machine-readable frontmatter.

Hold the constraints throughout — they govern how the draft is produced, not what
it contains, so the global skill cannot enforce them. The interrogation guide is
the same kind of material: a conversation discipline, not an artifact rule.

**Done when** `goals.md` exists, its frontmatter parses, every goal carries an id,
and carried goals kept their original ids.

## 5. Hand it over

Present the draft and stop. The user approves, edits, or rejects.

State the goals with their estimates, what was cut or shrunk, and any support
commitments made.

> `2026-W33` set — 3 goals. `g-3d8f` carried from W32, shrunk to the first slice,
> practice now 85. Support: Tuesday 9-12 blocked, phone in a drawer.

**Done when** the goals and every gate decision are in chat.

---

## Notes on the estimate

The gate is the model's, not this facade's, but two things are worth restating
because they are easy to soften in conversation:

**Ask theory and practice separately, and let them diverge.** Collapsing them into
one confidence score hides the diagnosis. A goal can score 95 on theory and 20 on
practice, and every cycle spent sharpening the plan is aimed at the number that
was already fine.

**A written justification is not one of the three remedies.** Practice below 80
forces cut, shrink, or concrete support. Well-written reasons are exactly what a
soft gate produces. "Make time for it" is not support; "Tuesday 9-12 blocked,
phone in a drawer" is.
