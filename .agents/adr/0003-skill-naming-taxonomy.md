# 0003 — Skill names follow an action/reference taxonomy

**Status:** Accepted

## Context

A skill's name is what the model matches a request against, what a human types,
and what other skills cite. A convention was needed before the first skill
landed, and it had to come from observed practice rather than preference.

**posthog** (130 skills, a mature public Claude Code plugin) is the source
analyzed. Its names are not uniform, and the pattern in the variation is the
finding:

- **85 of 130 are gerund-led**, across a wide verb set — `exploring` (15),
  `diagnosing` (7), `managing` (5), `investigating` (5), `creating` (5),
  `auditing` (4), `authoring` (3), and more. These are skills that *do*
  something.
- The rest are **noun phrases** (`skills-store`, `signals`, `feature-usage-feed`)
  or a prefixed family (`signals-scout-*`, `review-hog-*`, `instrument-*`). These
  are material consulted, or sets sharing an owner.

Read as "gerund or not", that looks like a 65/35 split with no rule. Read as
**what the skill is**, it resolves: the gerunds are actions, the noun phrases are
reference.

Not one of the 130 is named for an actor — no `-writer`, `-helper`, `-manager`,
`-generator`.

## Decision

Name by **what the skill is**, not by a uniform part of speech:

- **Action** (performs ordered steps) → `<gerund>-<object>`
- **Reference** (consulted, not run) → `<noun-phrase>`

The gerund is the **default**, since most skills do something. A noun phrase is
the narrower case: the skill holds knowledge rather than performing work.

One licensed exception: a **user-invoked** skill may take a short imperative
(`ship`, `build-app`). You type it, so brevity wins and no model matches against
it. Model-invoked skills always take the gerund or noun-phrase shape.

**Never name a skill for an actor** — no `-writer`, `-helper`, `-manager`,
`-generator`, `-assistant`. An actor noun names a thing that does the work; this
taxonomy names the work.

The rules themselves, and the procedures for naming and auditing against them,
live in the [`naming-skills`](../../skills/naming-skills/SKILL.md) skill — so
they are reachable by invocation rather than sitting in a document someone must
be told to read. This ADR records *why that taxonomy*; the skill is the single
source of truth for *what it says*.

## Delivery: one skill, two branches

Naming and auditing ship as a **single** `naming-skills` skill, not as
`naming-skills` plus `auditing-skill-names`.

The default reading of the authoring discipline argues the other way. The two
are **branches**, not a sequence — you do one or the other, and their triggers
differ ("what do I call this?" vs "check these names"). Distinct branches with
distinct triggers are the textbook case for splitting by invocation.

They stay together because **both branches consult the identical rule set**: the
action/reference split, the actor prohibition, object concreteness, and the
user-invoked exception. Naming applies those rules forward to a name that does
not exist yet; auditing applies them backward to names that do. A split would
either duplicate the rule set across two skills — the failure mode the
discipline names outright — or leave one skill invoking the other to borrow its
rules, which couples them anyway while paying for a second always-loaded
description.

That is the trade: independent reach for the audit, bought with a second
description and a shared-rules problem. At four steps, the audit does not repay
it.

## Revisit the delivery when

The audit grows its own report format, its own reference material, or completion
criteria that diverge from naming's. Any of those means the shared rule set is no
longer what binds the two branches, and the seam is then obvious and correctly
placed.

Running the audit against a real tree is what surfaces this — the same trigger as
the taxonomy's own revisit condition below.

## Confidence, and what would strengthen it

One analyzed source is a narrow base. The taxonomy is adopted because the
pattern within posthog is strong and internally consistent, and because it
matches how the authoring discipline this repo follows
(`writing-great-skills`) already separates **steps** from **reference** — the
naming rule is that distinction surfaced into the name.

`reflutter` is a second sample consistent with the split — its gerunds are
actions (`auditing-train-hygiene`, `verifying-candidate-integrity`) and its noun
phrases reference (`release-model`, `project-structure`, `core-auth`) — and its
short imperatives are all user-invoked, which is where the exception above comes
from. It is a private, in-development project rather than settled practice, so it
corroborates rather than carries the decision. Applying this taxonomy there is
the intended next test.

## Revisit when

Applying the taxonomy to a real tree produces names that read worse than what a
human would have chosen, or a mature public skill set is found that is internally
consistent and contradicts the action/reference split. The taxonomy claims to
describe practice, so contrary practice is decisive.
