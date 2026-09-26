# skills

Agent skills for Claude Code — skill authoring, and the conventions that keep
them predictable.

A skill exists to wrangle determinism out of a stochastic system. The virtue is
**predictability**: the agent taking the same *process* every run, not producing
the same output.

## Install

This repo is a marketplace of two plugins, one per audience
([0004](./.agents/adr/0004-one-plugin-per-audience.md)). Add it once, then
install the plugin you need:

```sh
claude plugin marketplace add luisburgos/skills
claude plugin install contributing@luisburgos
claude plugin install luisburgos-skills@luisburgos
```

## Updating

Refresh the marketplace first, then the plugin, then restart Claude Code:

```sh
claude plugin marketplace update luisburgos
claude plugin update contributing@luisburgos
claude plugin update luisburgos-skills@luisburgos
```

**The order matters.** `plugin update` resolves against a cached copy of the
marketplace manifest, so skipping the first command re-reads the stale cache and
reports nothing to update, which looks identical to no release having shipped.

`claude plugin list` confirms the installed version. Installs made with
`--scope project` or `local` need the same `-s` on `plugin update`, which
defaults to `user`.

## Skills

A skill reaches users only when it sits in a plugin's folder and is referenced
in this section, under that plugin; see [CLAUDE.md](./CLAUDE.md) for that
invariant and the rest of the house rules.

Within a plugin, entries are grouped by **invocation**: whether the model can
reach a skill on its own, or only you can. Model-invoked is the default;
user-invoked is the deliberate exception, marked
`disable-model-invocation: true` in frontmatter.

### contributing

How a contribution to a repository is written up. For any repository whose
collaborators should write the same way, declared in its
`.claude/settings.json`. Every skill here is model-invoked.

- **[drafting-release-notes](./skills/contributing/drafting-release-notes/SKILL.md)** — draft
  curated GitHub Release notes for a tag, as a draft the user approves before it
  goes public.
- **[generating-changelogs](./skills/contributing/generating-changelogs/SKILL.md)**:
  generate a release's changelog entry from Conventional Commits in the version
  bump, per app where a repository tags its apps on their own. Carries a
  configuration for prefixed tags such as `ios/1.2.0+3`.
- **[writing-adrs](./skills/contributing/writing-adrs/SKILL.md)**: check a
  decision needs a record, then write it in a register that states each reason
  once. Carries a template and a records README for repositories without them.
- **[writing-prds](./skills/contributing/writing-prds/SKILL.md)**: draft a
  product requirements document whole, then close its gaps one question at a
  time until its review checklist passes. Carries a template for repositories
  without one.
- **[writing-pull-requests](./skills/contributing/writing-pull-requests/SKILL.md)**: check
  a change is one pull request, then write its description in a register that
  states what the diff cannot. Carries a template for repositories without one.

### luisburgos-skills

Personal workflow and skill authoring.

#### Model-invoked

Reachable by the model or by you.

- **[naming-skills](./skills/personal/naming-skills/SKILL.md)** — name a new skill, or
  audit existing names, against this repo's action/reference taxonomy.

The **weekly cycle** — a repeating, measured work cycle of one ISO week: collect
what happened, review it, assess it against the goals the cycle started with,
then set the next cycle's goals. Domain-agnostic: a goal can be a refactor, a
portfolio sale or a job application, and the machinery treats them the same. The loop closes because the goals written at the end of
one cycle are what the next is measured against. Adapted from Watts Humphrey's
Personal Software Process, moved from task scale to cycle scale.

Its four steps and the model they share are reachable by the model because
something already gates them: each step runs behind a user-invoked facade that
decides when the cycle advances. Putting the flag here too would not add a
second gate, it would break the facade's ability to delegate.

- **[weekly-cycle-model](./skills/personal/weekly-cycle-model/SKILL.md)** — the shared
  model: the sequence, the artifact contract, and the rules the other six obey.
  Reference, not steps.
- **[collecting-cycle-data](./skills/personal/collecting-cycle-data/SKILL.md)** — the
  mechanical half: git across the configured repos, plus an optional task export.
- **[writing-cycle-review](./skills/personal/writing-cycle-review/SKILL.md)** — the
  interpretive half: the readable narrative of a cycle.
- **[assessing-cycle-goals](./skills/personal/assessing-cycle-goals/SKILL.md)** — measure
  the cycle against its goals, score the estimates, and close it.
- **[setting-cycle-goals](./skills/personal/setting-cycle-goals/SKILL.md)** — draft the
  next cycle's goals with theory and practice confidence estimates.

#### User-invoked

Reachable only by typing the name.

The three cycle **facades** — each wrapping the step skills into a command you run
— plus the two cycle skills no facade covers. Nothing else decides when these run,
so the gate has to be you.

- **[recap](./skills/personal/recap/SKILL.md)** — close a finished cycle's record: collect
  what happened, then optionally write the review. Facade over
  `collecting-cycle-data` and `writing-cycle-review`.
- **[recheck](./skills/personal/recheck/SKILL.md)** — close a cycle against its goals: judge
  each, score the estimates, write the assessment, freeze the history row. Facade
  over `assessing-cycle-goals`.
- **[reaim](./skills/personal/reaim/SKILL.md)** — set the coming cycle's goals with theory
  and practice estimates, carrying or dropping what did not land. Facade over
  `setting-cycle-goals`.
- **[configuring-cycle-tracking](./skills/personal/configuring-cycle-tracking/SKILL.md)**
  — one-time setup: artifact root, repos to scan, task source, timezone. It
  writes the config every later tally reads, so a stray run would silently
  redefine what every cycle is measured against.
- **[reviewing-cycle-trends](./skills/personal/reviewing-cycle-trends/SKILL.md)** — read
  across many cycles for carried goals, estimate calibration, and gaps.

## Local development

```sh
./scripts/link-skills.sh
```

Symlinks every skill in the tree into `~/.claude/skills/`, `drafts/` included:
local reach is deliberately wider than what ships.

## Decisions

Architectural decisions live in [`.agents/adr/`](./.agents/adr/), numbered, one
per file, immutable once accepted:

- [0001 — Ship as a Claude Code plugin, Claude-only](./.agents/adr/0001-ship-as-a-claude-code-plugin.md)
- [0002 — Keep `skills/` flat](./.agents/adr/0002-flat-skills-directory.md)
- [0003 — Skill naming taxonomy](./.agents/adr/0003-skill-naming-taxonomy.md)
- [0004: One plugin per audience, from one marketplace](./.agents/adr/0004-one-plugin-per-audience.md)
- [0005: Group skills in a folder per plugin](./.agents/adr/0005-folder-per-plugin.md)

## Credits

Structure and authoring discipline researched from
[mattpocock/skills](https://github.com/mattpocock/skills) — in particular its
plugin-and-marketplace layout, its ADR trail, and the `writing-great-skills`
vocabulary this repo builds on.

## License

MIT
