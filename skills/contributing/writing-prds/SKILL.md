---
name: writing-prds
description: >
  Draft, fill in or review a product requirements document: what a part of the
  product does, its flows, edge cases and acceptance criteria. Use when writing
  a PRD, starting a new effort, "draft a spec", reverse-engineering a PRD from
  something already built, or before creating a file where the repository
  keeps its PRDs. Also use when a repository has no PRD template yet and needs
  one.
---

# Writing PRDs

The template gives a PRD its structure; this skill is the procedure it cannot
enforce: how a draft gets written, and when it is done.

## 1. Find the template

The repository's own template wins: copy it, never another PRD, and keep every
heading verbatim. Read what the product is and the words it uses first, where
the repository has them: its vision and its glossary.

With none, offer to copy this skill's [assets/_template.md](assets/_template.md)
into the repository. Adding it is a change of its own, so it is its own pull
request, and it waits for the user's yes.

**Done when:** the draft starts from the repository's template.

## 2. Draft first

1. **Ask at most three questions** before the first draft: the effort's name,
   who it is for and the problem, and what starts it. Skip any the conversation
   already answered.
2. **Write the whole draft at once,** every section of the template. What the
   repository answers, fill in. What it does not, write `TBD` with a one-line
   note.
3. **Label every claim nothing backs,** in capitals: `ASSUMPTION` for what is
   taken as true to make progress, `HYPOTHESIS` for a causal claim not yet
   tested, `RECOMMENDATION` for a judgement whoever owns the product decides. An
   unlabelled claim is a fact, and must be checkable. Where the repository
   defines its own labels, use those.
4. **Then ask one or two questions per turn,** highest impact first:
   1. User flows and entry points, which set the scope.
   2. The UI specification and edge cases, which carry the risk.
   3. Permissions and analytics instrumentation.
   4. Acceptance criteria.

A draft with gaps is worth more than another question.

## 3. Reverse-engineering a PRD

When the effort is already built, the code is the source. Read the screens, the
state and the tests before writing. An acceptance criterion is checked only if
a test holds it or it was seen running. Say in the status line which commit it
was read from.

## 4. Done when

The template's review checklist passes, item by item. A PRD failing any item
stays a draft; it is not argued into approved.

The status becomes approved only on the product owner's word, and built only
when every acceptance criterion is checked.

The repository may record failures caught in its own reviews in its agent
instructions. Read them before writing: a mistake made there once is the one
most likely to be made again.
