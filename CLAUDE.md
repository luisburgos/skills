# skills — agent notes

A collection of agent skills, shipped as a Claude Code plugin.

## Layout

`skills/` is **flat** — one directory per skill, no bucket folders
([0002](./.agents/adr/0002-flat-skills-directory.md)):

```
skills/<skill-name>/SKILL.md
```

Reference a skill discloses (rung-3 material — see the skill-authoring
discipline below) sits **beside** its `SKILL.md`, inside that skill's folder.

## The shipping invariant

A skill **ships if and only if** it is:

1. listed in `.claude-plugin/plugin.json`'s `skills` array, **and**
2. referenced in the top-level `README.md`, linked to its `SKILL.md`.

Both, or neither. The manifest is the gate — a skill can sit in the tree
unfinished without reaching users, which is why the layout needs no
`in-progress/` folder.

After touching either manifest, run:

```sh
claude plugin validate . --strict
```

`plugin.json`'s `version` is what Claude uses to decide when installed users see
an update — bump it deliberately, not on every edit.

## Invocation

Every skill is one of two kinds, and the choice is explicit:

- **User-invoked** — `disable-model-invocation: true` in frontmatter. Reachable
  only by the human typing its name; no other skill can reach it either. The
  `description` is human-facing: a one-line summary, no trigger lists.
- **Model-invoked** — the default. The `description` is model-facing and carries
  rich trigger phrasing so auto-invocation fires.

The test: *could the model usefully reach for this on its own?* Reuse is a
reason to extract a skill, not a reason to make it model-invoked.

The flag blocks **every** model path, not just auto-invocation — including one
skill delegating to another. A skill that a facade is supposed to invoke must
therefore stay model-invoked, even when a human never types its name; the gate
lives on the facade instead. Flagging both levels does not double the protection,
it breaks the delegation, and the work silently gets inlined by hand.

Where the gate is a facade rather than the flag, record that in the README entry
rather than the skill body — the facade often lives in a private repo, and a
shipped skill should not depend on naming it.

`SKILL.md` frontmatter is the **single source of truth** for invocation mode —
there is no second file to keep in sync
([0001](./.agents/adr/0001-ship-as-a-claude-code-plugin.md)).

## Dependencies between skills

Expressed as **prose invocation** — "run the `naming-skills` skill" — never as a
cross-folder file path (`../other-skill/REFERENCE.md`). Shared reference lives
inside the skill that owns it; other skills reach it by invoking that skill.

A deep link couples two skills' internals and breaks when either reorganises.

## Decisions

Architectural decisions live in `.agents/adr/`, numbered, one decision per file.

ADRs are **immutable once accepted**. A decision that stops applying is not
edited or deleted — a new ADR supersedes it, and the old one's `Status:` becomes
`Superseded by NNNN`. The ADR records why a choice was made given what was known
then; the current state lives in the code.

Where a decision has a foreseeable expiry, name the condition that triggers
revisiting it rather than writing "revisit later".

## Local development

`scripts/link-skills.sh` symlinks every skill in this repo into
`~/.claude/skills/`, so a `git pull` keeps them current. Re-run it after adding,
removing, or renaming a skill.

Symlinked skills are reachable **before** they are promoted into the manifest —
that is the point. The manifest controls what other people get; the symlinks
control what you get.
