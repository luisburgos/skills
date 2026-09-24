# PRD NNNN: [Effort Name]

<!--
  Copy this file to NNNN-title-with-dashes.md, next number in sequence. Keep every
  heading verbatim, so people and agents fill the same structure, and delete each
  comment as its section is filled in. A section that does not apply stays, with one
  line saying why. Nothing is left blank: write TBD with a one-line note. A claim
  nothing in the repository backs carries its label in capitals: ASSUMPTION (taken
  as true, on purpose, to make progress), HYPOTHESIS (a causal claim not yet tested)
  or RECOMMENDATION (a judgement for whoever owns the product). An unlabelled claim
  is a FACT, and must be checkable.

  The sections follow the classic feature PRD spine:
  https://www.productmap.io/blog/ai-prd-template#the-classic-feature-prd-spine
  except Success Metrics. A PRD describes what the product does, and changes as the
  product does; the problem, the bet and how it is measured belong to whatever frames
  the work, such as an initiative or a brief. The PRD names none.

  Write in the terms of the product's glossary, where it has one. Who the product is
  for and where it is going belongs to its vision; do not restate it. Its principles,
  where it has them, filter every decision below.
-->

**Status:** [draft | approved | built]. [One line: what it was written from, or what it waits on.]

## Overview

<!--
  Two or three sentences for someone who reads nothing else: what part of the product
  this describes, and for whom. Not the problem it solves: that frames the work.
-->

## Goals

<!--
  What a person can do once this is built, each one observable. Not an outcome or a
  metric: those frame the work. Non-goals are what this will never do. Deferred work goes to Future
  Enhancements instead: one list for both turns deferred work into implied scope.
-->

- [What a person can do: observable]
- [Non-goal: what this effort will not do]

## Core Concepts

<!--
  The glossary terms this effort builds or changes, and the invariants that shape the
  design, before any flow. A term new to the product goes into its glossary first, as
  its own change; here it is named, not defined again.
-->

- [Term]: [what this effort does with it]
- [Invariant that shapes the design]

## Entry Points

<!--
  Every screen or surface this effort touches. A missing entry point is missing scope.
-->

### [Screen / Surface Name]

- [Element added or changed]
- [Trigger condition, if not obvious]

## User Flows

<!--
  One subsection per flow. Alternatives go as nested bullets under the step they
  belong to. An error path is a flow of its own, not an aside.
-->

### [Flow Name]

**Trigger:** [What starts it]

**Steps:**
1. [Step]
2. [Step]

**Outcome:** [What the person ends with]

## UI Specification

<!--
  One subsection per screen or sheet. All four states, always: a state a screen cannot
  reach says why, for example "reads are synchronous, so nothing loads". Missing empty
  and error states are the usual cause of late design changes.

  Layout is what the person must see together, in what order and grouped how, as
  product rules. Not sizes, materials, colours or placement: the design settles those,
  and links back here. Where the two disagree on a product rule, this wins.
-->

### [Screen / Sheet]

**Layout:**
- [Structure]

**Elements:**
- [Control and what it does]

**States:**
- Default: [description]
- Loading: [description]
- Error: [description]
- Empty: [description]

## Permissions

<!--
  Who may do what. While the product has one role, one line saying so. Once it has
  more, a row per action and a column per role, every cell filled.
-->

| Capability | [Role A] | [Role B] |
|---|---|---|
| [Action] | Yes / No | Yes / No |

## Edge Cases

<!--
  At least: empty data, a value that cannot be accepted, a date in the future, the day
  changing while a screen is open, and, once more than one person can change the same
  thing, revoked access and two people changing it at once.
-->

| Scenario | Expected behavior |
|---|---|
| [Scenario] | [What happens] |

## Analytics Instrumentation

<!--
  Events named before building, never after. While the product measures nothing, one
  line saying so.
-->

| Event name | Trigger | Key properties |
|---|---|---|
| [area]_[action] | [When it fires] | [property], [property] |

## Acceptance Criteria

<!--
  Pass or fail, grouped by area. Assert behaviour a person or a test can observe, never
  implementation. These gate the effort: it is not built until every box is checked,
  and each is held by a test or was checked on a device or simulator.
-->

### [Area]

- [ ] [Condition]

## AI Feature Addendum

<!--
  Only when the effort calls a model; otherwise one line saying it does not. When it
  does, the addendum in the spine's source covers why a model, evaluation, autonomy
  and tools, failure modes, cost and latency, monitoring and rollout.
-->

## Future Enhancements (Out of Scope)

<!--
  Deferred, each with why it waits.
-->

- [Enhancement]: deferred because [reason]

## Open Questions

<!--
  Each owned and dated. The PRD is not approved while one blocks building. "None."
  when there are none.
-->

| Question | Owner | Due (YYYY-MM-DD) | Status |
|---|---|---|---|
| [Question] | [Who] | [Date] | open |

## Review Checklist

<!--
  Run before the Status becomes approved. A PRD failing any item stays a draft. Delete
  this section from the copy once every item passes.
-->

- [ ] Every heading is present and verbatim; any section that does not apply says why in one line.
- [ ] Nothing is blank: gaps are TBD with a note, and every claim that is not a FACT carries its label.
- [ ] The Overview reads on its own for someone who reads nothing else.
- [ ] Non-goals are specific enough to refuse a change, and are not repeated as Future Enhancements.
- [ ] Every term is in the glossary, where there is one, or the glossary change is its own pull request.
- [ ] No principle is broken, or the principle changes first.
- [ ] Every Entry Point has at least one User Flow, and every flow names its trigger and outcome.
- [ ] Every screen in the UI Specification has all four states.
- [ ] Edge Cases cover at least the minimum listed in that section.
- [ ] Every Acceptance Criterion is pass or fail and asserts behaviour, not implementation.
- [ ] Every Future Enhancement says why it waits.
- [ ] Every Open Question has an owner and a due date, and none blocks building.
