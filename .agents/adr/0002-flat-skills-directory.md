# 0002 — Keep `skills/` flat until the count justifies buckets

**Status:** Accepted

## Context

The repo this one's structure was researched from
([mattpocock/skills](https://github.com/mattpocock/skills)) organises ~40 skills
into bucket folders that double as lifecycle states: `engineering/` and
`productivity/` are *promoted* (they ship), while `misc/`, `personal/`,
`in-progress/`, and `deprecated/` are not.

That structure earns its keep at forty skills. This repo starts with none.

Copying it now would mean inventing a taxonomy for a population we have not met
— deciding that "engineering" and "productivity" are the right axes before
there is anything to sort. The categories most likely to be wrong are the ones
chosen before the things they categorise exist.

## Decision

`skills/` is **flat**. One directory per skill, no buckets:

```
skills/
  <skill-name>/
    SKILL.md
```

No `in-progress/`: with a handful of skills, which are drafts is not something
that needs a folder to remember, and [0001](./0001-ship-as-a-claude-code-plugin.md)'s
explicit `skills` array is the real gate on what ships.

No `deprecated/`: nothing has been retired yet. The folder would be empty
structure waiting for a need that has not arrived.

## Why this is cheap to reverse

A bucket path is **not** part of a skill's identity:

- `plugin.json` lists explicit paths, which are edited when a path changes.
- `scripts/link-skills.sh` links by `basename`, so nesting depth is irrelevant.
- The invocation name comes from `SKILL.md` frontmatter, not the directory.

So adopting buckets later is `git mv` plus one line per skill in `plugin.json`.
Nothing downstream reads the bucket.

## Revisit when

Skills reach a count where a flat listing stops being scannable — roughly a
dozen — or where two clearly different audiences emerge (say, personal setup
skills alongside general engineering ones).

Retirement is the other trigger: the first time a skill in **this repo** needs
retiring, decide then between a `deprecated/` bucket and deletion-with-git-history,
and record it. That decision is deliberately not made here.
