# Verify before writing

The rule that produced this file: **the review is not a source.**

`review.html` is narrative written from the same data as `data.json`, and it
compresses. A compressed figure is not evidence. The assessment is the artifact
that checks claims, so it does not get to inherit them.

This is the trust seam from `engineering-cycle-model`, applied. It is not
optional care: the review's compression produces plausible wrong figures as a
matter of course, and they freeze into history looking exactly like correct ones.

## What to check against what

| Claim | Check against |
|---|---|
| Task and commit counts | `data.json` |
| Releases, version bumps | `git tag` with dates, filtered to the cycle window |
| Splits like "first half / second half" | `git log` grouped by day |
| What shipped | commit subjects, not the review's summary |
| What a commit *contains* | `git log --name-only`, not the subject |
| Per-project attribution | `data.json`'s `by_project`, not the narrative's grouping |

A subject describes the change its author chose to name. It is the right source
for *what shipped* and the wrong one for *what is in there* — a commit whose
subject names one thing routinely contains others the subject never mentions.

Trust the reconciled totals in `data.json` rather than re-deriving them; the
record reconciles itself before it is written. These numbers are about to freeze
into a history row.

## Failure shapes the review produces

These recur because each is a natural product of compressing a week into
narrative. Watch for them by name.

**1. The arc that the log does not support.**
Narrative wants a shape — "first half product, second half tooling", a build-up,
a turning point. Days rarely have one. Check any framed arc against the daily
`git log`; where the kinds of work ran together every day, cut the arc.

*Seen once:* a review framed a week as two halves of different character; the
commits showed both kinds every day. The claim was cut.

**2. "New" as a claim about history the review cannot see.**
The review sees one cycle. Any word asserting novelty — "new", "did not exist a
week earlier", "first time" — is a claim about the past, which only `git tag`/`git
log` outside the window can settle.

*Seen once:* a review called a component new; tags showed it had shipped 11 times
during the very week in question.

**3. A number correct *within the review's frame*, read as the total.**
The review often counts only what touched its subject. That figure is right
inside its frame and wrong the moment it leaves it. Re-count against the full
record before stating any total.

*Seen once:* a review named five releases — the ones touching one project. The
real count across all projects was 11.

## The standing rule

**A wrong number is worse than a missing one.** If a figure cannot be verified,
leave it out. An assessment with a gap is honest; an assessment with a plausible
wrong figure is not, and it freezes into history looking exactly like a correct
one.

This applies to anything drafted from the review, including any public post — it
is not specific to the assessment.
