# skills

Agent skills for Claude Code — skill authoring, and the conventions that keep
them predictable.

A skill exists to wrangle determinism out of a stochastic system. The virtue is
**predictability**: the agent taking the same *process* every run, not producing
the same output.

## Install

This repo is its own single-plugin marketplace:

```sh
claude plugin marketplace add luisburgos/skills
claude plugin install luisburgos-skills
```

## Skills

A skill reaches users only when it is both listed in
`.claude-plugin/plugin.json` and referenced in this section; see
[CLAUDE.md](./CLAUDE.md) for that invariant and the rest of the house rules.

Entries are grouped by **invocation** — whether the model can reach a skill on
its own, or only you can.

### Model-invoked

Reachable by the model or by you.

- **[drafting-release-notes](./skills/drafting-release-notes/SKILL.md)** — draft
  curated GitHub Release notes for a tag, as a draft the user approves before it
  goes public.
- **[naming-skills](./skills/naming-skills/SKILL.md)** — name a new skill, or
  audit existing names, against this repo's action/reference taxonomy.

### User-invoked

Reachable only by typing the name.

The **engineering cycle** — a repeating, measured work cycle: collect what
happened, review it, assess it against the goals the cycle started with, then set
the next cycle's goals. The loop closes because the goals written at the end of
one cycle are what the next is measured against. Adapted from Watts Humphrey's
Personal Software Process, moved from task scale to cycle scale.

- **[engineering-cycle-model](./skills/engineering-cycle-model/SKILL.md)** — the
  shared model: the sequence, the artifact contract, and the rules the other six
  obey. Reference, not steps.
- **[configuring-cycle-tracking](./skills/configuring-cycle-tracking/SKILL.md)**
  — one-time setup: artifact root, repos to scan, task source, timezone.
- **[collecting-cycle-data](./skills/collecting-cycle-data/SKILL.md)** — the
  mechanical half: git across the configured repos, plus an optional task export.
- **[writing-cycle-review](./skills/writing-cycle-review/SKILL.md)** — the
  interpretive half: the readable narrative of a cycle.
- **[assessing-cycle-goals](./skills/assessing-cycle-goals/SKILL.md)** — measure
  the cycle against its goals, score the estimates, and close it.
- **[setting-cycle-goals](./skills/setting-cycle-goals/SKILL.md)** — draft the
  next cycle's goals with theory and practice confidence estimates.
- **[reviewing-cycle-trends](./skills/reviewing-cycle-trends/SKILL.md)** — read
  across many cycles for carried goals, estimate calibration, and gaps.

## Local development

```sh
./scripts/link-skills.sh
```

Symlinks every skill in the tree into `~/.claude/skills/`, including ones not
yet promoted — local reach is deliberately wider than what ships.

## Decisions

Architectural decisions live in [`.agents/adr/`](./.agents/adr/), numbered, one
per file, immutable once accepted:

- [0001 — Ship as a Claude Code plugin, Claude-only](./.agents/adr/0001-ship-as-a-claude-code-plugin.md)
- [0002 — Keep `skills/` flat](./.agents/adr/0002-flat-skills-directory.md)
- [0003 — Skill naming taxonomy](./.agents/adr/0003-skill-naming-taxonomy.md)

## Credits

Structure and authoring discipline researched from
[mattpocock/skills](https://github.com/mattpocock/skills) — in particular its
plugin-and-marketplace layout, its ADR trail, and the `writing-great-skills`
vocabulary this repo builds on.

## License

MIT
