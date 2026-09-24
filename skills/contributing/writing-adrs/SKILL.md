---
name: writing-adrs
description: >
  Write or review an architecture decision record, and check first that the
  decision needs one. Use when recording a decision, writing or reviewing an
  ADR, or before creating a file where the repository keeps its decision
  records, often docs/adr/. Also use when a repository has no decision records
  yet and needs a place and a template for them, or when another skill needs
  the register an ADR is written in.
---

# Writing ADRs

A record can satisfy every structural rule and still fail its reader. The
repository's template gives the structure and its records' README gives which
sections to use and how long a record runs; this skill is the register neither
can enforce.

Write to be read by someone who has forgotten why, not by someone checking that
a process was followed.

## 1. Check the decision needs a record

**Did you reject an alternative?** If not, it is not an ADR: behaviour a test
can verify belongs in a test, a procedure in a guide, a rule for agents in the
agent instructions.

**A decision the glossary or a principle already made is not an ADR.** Where the
repository has a glossary or principles, ask before copying the template
whether any option survives them. If none does, the decision was spent when
they were written, and the record would restate a definition with a "because"
attached.

**Done when:** at least one real alternative was rejected, and nothing already
written decides the question.

## 2. Find where the repository keeps its records

The repository's own records win: their README (often `docs/adr/README.md`)
settles sections, length and numbering, and its template gives the structure.
Copy the template, never another record. Some repositories keep records in a
format of their own; follow it.

With none, offer to copy this skill's
[assets/README.md](assets/README.md) and [assets/_template.md](assets/_template.md)
into the repository's `docs/adr/`. Adding them is a change of its own, so it is
its own pull request, and it waits for the user's yes.

**Done when:** the record has a template to follow and a README that says how
long it runs.

## 3. Write it in the register

- **A reason appears once.** Context says what is wrong. Drivers say what would
  make an option good. The outcome says why this one won. The same argument in
  two of them is the most common defect, and the hardest to see while writing.
- **Options are what someone might actually choose.** Weighing a published
  standard against undocumented in-house conventions is not a comparison: those
  are prior art, not candidates, and comparing against local history reads as
  justifying a choice already made.
- **Nothing outside the repository is evidence.** Other repositories, private
  notes and the conversation are invisible to a reader. State the substance
  instead.
- **A criterion that needs judgement says so.** "A reviewer will accept this"
  is not checkable. Mark it rather than dressing it as a condition.
- **An expiry names its trigger.** "Revisit later" is not a condition. Where a
  decision has a foreseeable end, say what would reopen it.
- **The index row goes in the same commit.** It is the step most often
  forgotten.

The repository may record failures caught in its own reviews in its agent
instructions. Read them before writing: a mistake made there once is the one
most likely to be made again.

**Done when:** no reason is stated in two places, every optional section present
carries something the reader could not infer, the index has its row, and the
record arrives by pull request rather than a direct commit.
