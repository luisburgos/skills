# Architecture Decision Records

Decisions that govern this repository and outlive the conversations that produced them. An ADR records **why a solution was chosen and what was rejected**, not what the system currently does. For what the system does, see the code and its tests.

Format is [MADR 4.0.0](https://adr.github.io/madr/), minimal variant.

| ADR | Title | Tags | Status |
|---|---|---|---|

## Writing one

Copy [`_template.md`](_template.md). Do not reconstruct the structure from memory or from another ADR.

Name it `NNNN-title-with-dashes.md`, next number in sequence, starting at `0000`. Add a row to the table above in the same commit. Every ADR arrives by pull request.

## Shape

Which sections a record uses, and how long it runs. How it should *read* is the `writing-adrs` skill.

MADR's own [decision log](https://github.com/adr/madr/tree/develop/docs/decisions) is the reference. Their ADR-0000 is 26 lines. Length is not a virtue here, and the common failure is writing too much rather than too little.

**Context is two or three sentences, ending in the question the decision answers.** Say what is missing or wrong. Do not argue for the chosen option there.

**Decision Outcome is `Chosen option: "X", because` followed by short bullets.** One thought per bullet. Paragraphs of argument belong in *Pros and Cons*, if anywhere.

**Omit optional sections.** *Decision Drivers*, *Consequences*, *Confirmation*, *Pros and Cons* and *More Information* are all optional, and omitting one is normal rather than careless. MADR's own 0000 uses none of them. Include a section only when it carries something a reader could not infer.

**Use the full *Pros and Cons* form only for real trade-offs**, where options must be weighed point by point. Choosing a format for a new repository is not that; choosing between four ways to store a status field is.

**Expect 50 to 70 lines.** Past 70, look for duplicated reasoning, a section filled because it existed, or reference material that belongs in a guide. Well under 50 is fine when the decision is genuinely small.

## Tags

Every ADR carries a `tags` list. It may be empty.

| Tag | Means |
|---|---|
| `candidate-standard` | intended to propagate to other repositories once validated here |

Some of what is settled in a repository is meant to travel and some is not. An untagged decision is local. A `candidate-standard` ADR must say in **Confirmation** what would count as validated, and what would sink it.

More tags arrive when there is something to sort, not in advance.

## Two rules

**Immutable once accepted.** A decision that stops applying is superseded by a new ADR, never edited or deleted. The old one's status becomes `superseded by ADR-NNNN`.

**Name the expiry condition.** Where a decision has a foreseeable end, say what would trigger reopening it. "Revisit later" is not a condition.

## What is not an ADR

| It is | Then it belongs in |
|---|---|
| a rejected alternative and the reasoning | here |
| behaviour a test can verify | a test |
| a repeatable procedure | a guide |
| what the product is and who it is for | the product's own documents |
| an operating rule for agents | the agent instructions |

The test: **did you reject an alternative?** If yes, it is an ADR. **Can a test verify it?** If yes, it belongs in a test.
