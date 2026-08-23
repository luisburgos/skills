# The four drafting constraints

What makes drafting goals worth doing at all. Breaking any of these produces a
list that looks like goals and is not.

These are **procedural** — they govern how the draft is produced. The global
gate in `setting-cycle-goals` is **quantitative**: it fires on a number below 80
and offers a closed set of remedies. The two do not overlap, and neither
substitutes for the other.

## 1. Ask before inventing

Every goal traces to something the user wrote or said. If something seems to
belong that they have not named, **raise it as a question** — never slip it into
the list.

A goal the agent added is a goal nobody committed to. The next assessment then
grades the cycle against the agent's guess, and the resulting history row is
indistinguishable from an honest one.

## 2. Challenge anything carried forward twice

A goal that has appeared two cycles running without moving needs a decision:
commit to it, or drop it. Silently re-listing it a third time is how a goals list
turns into noise.

Say which items are in this position, **with the count**, before asking:

> `g-3d8f` has been carried twice and missed both times. A third listing without
> something changing is the pattern that ate four weeks last time.

The global skill surfaces carry counts as *information*. This constraint demands
a *decision*. Carry counts come from `history.jsonl` by goal id, which is why
carrying preserves the id — text matching fails on exactly the goal that gets
reworded every cycle while never being started.

## 3. Never resolve a tension on the user's behalf

If the cycle's priorities conflict — two "must-do" projects, or a non-negotiable
that has already lost twice — **name the conflict and let them choose.**

That choice is the entire value of the step. A draft that quietly sequences the
conflict away has made the user's decision for them, and made it invisible.

This is the constraint with no equivalent anywhere in the global family, and the
easiest to break, because resolving the tension produces a tidier draft. The tidy
draft is the failure.

## 4. Drafting is not deciding

The agent writes the note; the user sets the goals.

A goal the user did not agree to is not a goal, and the next assessment measuring
against it is grading the agent's guess. Present the draft and stop.

---

## Why these sit in the facade, not the global

`setting-cycle-goals` is about the *artifact* — ids, estimates, the gate, the
frontmatter contract — and it runs against any repo with a `cycles/config.json`.

These four are about the *conversation* that produces the artifact, so they live
with the facade that runs that conversation rather than the portable writer. They
are the default drafting discipline; a vault that wants different procedural rules
points `goals.constraints` at its own file, and this one is what applies when it
does not.

Each encodes a real failure these rules exist to prevent: goals that appeared
without being chosen, a goal carried several cycles unchanged, and drafts that
sequenced away a conflict the user needed to see. Keep the evidence attached — a
constraint that names what it prevents is followed; a bare rule is negotiated
away.
