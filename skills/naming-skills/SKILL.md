---
name: naming-skills
description: >
  Name a new skill, or audit existing skill names against this repo's taxonomy.
  Use when choosing what to call a skill or renaming one, or when checking a tree
  of skills for naming drift. Also use when another skill needs the taxonomy to
  justify a name it is producing.
---

# Naming skills

A name is the skill's **leading word** in its most load-bearing position. It is
what the model matches a request against, what you type, and what other skills
cite. A name that describes the wrong thing costs an invocation that should have
fired.

The rule: **the name is the work, phrased as the question the skill answers.**

## The taxonomy

Two shapes, chosen by what the skill *is*:

| Skill is… | Shape | Examples |
|---|---|---|
| An **action** — it does something, in steps | `<gerund>-<object>` | `naming-skills`, `drafting-release-notes`, `diagnosing-lane-failures` |
| A **reference** — it is consulted, not run | `<noun-phrase>` | `release-model`, `project-structure`, `core-auth` |

The split is not stylistic. It is the same distinction as **steps** vs
**reference** in the information hierarchy: a skill built from ordered actions
names the action; a skill that is a body of knowledge names the knowledge.

**Default to the gerund.** Reach for a noun phrase only when the skill has no
steps at all.

When the object of the knowledge is itself an act, the gerund *is* the noun
phrase — `writing-great-skills` is a gerund and pure reference.

### The one exception: user-invoked commands

A **user-invoked** skill — one only you can reach, by typing its name — may take
a short imperative instead: `ship`, `build-app`, `define-app`. You are typing it,
so brevity at the keyboard beats descriptive precision, and no model needs to
match a request against it.

This narrow licence covers the imperative names in the sources this taxonomy is
drawn from; every one of them is user-invoked. A **model-invoked** skill always
takes the gerund or noun-phrase shape, because its name is what the model matches
against.

## Rules

**Name the work, not the actor.** `drafting-release-notes`, never
`release-notes-writer`. An actor noun names a thing that does the work; the
taxonomy names the work. Actor suffixes — `-writer`, `-helper`, `-manager`,
`-generator`, `-assistant` — are the most common violation.

**The verb answers a question.** `diagnosing-lane-failures` answers "why did my
lane go red?".

**One object, concrete.** `naming-skills` over `naming`; `drafting-release-notes`
over `drafting-notes`. The object is what disambiguates two skills sharing a verb
— `drafting-release-notes` and `drafting-store-notes` differ on the noun that
actually matters.

**Lowercase, hyphen-separated**, matching the directory name.

**The directory is bare; any namespace lives in frontmatter.** In a plugin whose
skills carry a prefix, the prefix goes in `name:`, never in the folder — a
prefixed directory doubles the prefix at invocation.

## Naming a skill

1. **State the skill's purpose as a question** a user would ask. "What do I call
   this skill?" · "What shipped in this release?" · "Why did my lane go red?"

2. **Decide action or reference.** Does it perform ordered steps, or is it
   material consulted on demand? Steps → gerund. Knowledge → noun phrase. If it
   is knowledge *about* an activity, the gerund names the domain.

3. **Draft the name** in the shape that decision picked.

4. **Check it against the rules above** — actor nouns, verb-answers-question,
   concrete object.

5. **Check it against its neighbours.** List the sibling skills. Does the new
   name collide, or sit ambiguously close to an existing one? Two skills sharing
   a verb must differ on a *meaningful* object, not a synonym.

**Done when** the name satisfies every rule and you have listed the sibling
skills it must be distinct from. A rule may be broken only where the skill is
user-invoked, and the frontmatter must say so.

## Auditing existing names

1. **List every skill name** in the target tree.

2. **Classify each** as action or reference, by reading what the skill does —
   not by guessing from the name. A mismatch between shape and kind is the
   finding.

3. **Flag violations**, each with the rule broken and a proposed replacement:
   actor nouns; a gerund on a pure-reference skill that is not knowledge-about-an-
   activity; a noun phrase on a stepped skill; vague or absent objects; near-
   collisions between siblings; an imperative name on a **model-invoked** skill
   (the short-imperative licence covers user-invoked skills only).

4. **Report** — one entry per violation with its evidence and proposal. Propose;
   do not rename. A rename breaks every reference to the old name, which is a
   decision with a blast radius the audit cannot see.

**Done when** every name listed in step 1 appears in the report — count them and
say the count — each classified as action or reference, and every violation
carrying both a named rule and a concrete replacement. Include the names that
pass, stated as passing, so the sweep is visibly complete.

## Where this comes from

This taxonomy describes observed practice rather than inventing one. The sources
analyzed, the confidence argument, and what would overturn it live in
[ADR-0003](../../.agents/adr/0003-skill-naming-taxonomy.md).
