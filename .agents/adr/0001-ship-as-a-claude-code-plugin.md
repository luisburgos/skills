# 0001 — Ship as a Claude Code plugin, Claude-only, and be our own marketplace

**Status:** Accepted

## Context

Skills in this repo need a distribution path. Two exist:

- **Loose files** copied or symlinked into `~/.claude/skills/`. Zero setup, but
  every machine drifts on its own — the copy on one laptop silently diverges
  from the copy on another, and there is no version to point at.
- **A native plugin.** Installed as a read-only, always-current bundle with a
  version users can be updated to.

The loose-file path is what this repo exists to replace. Two skills already
lived that way (`stores-listing-notes-writer`, `github-release-notes-writer`),
and the first was only discoverable because its author remembered it existed.

## Decision

Ship as a **Claude Code plugin**, and make the repo **its own single-plugin
marketplace**:

- `.claude-plugin/plugin.json` — the plugin, with an explicit `skills` array.
- `.claude-plugin/marketplace.json` — one plugin, this one.

Keep `scripts/link-skills.sh` for local development, so work in progress is
reachable without a release.

Run `claude plugin validate . --strict` after touching either manifest.

## Why an explicit `skills` array matters

Claude's manifest takes an **array of explicit skill-directory paths**. Every
shipped skill is named, one by one — so what ships is a curated list, not
"whatever is on disk". A draft skill in the tree does not reach users until
someone adds its path.

That property is what lets [0002](./0002-flat-skills-directory.md) keep the
directory structure flat: the manifest gates shipping, not the filesystem.

## Codex

Not supported, and not attempted. Codex's manifest accepts `skills` only as a
**single path string**, so it cannot express a curated subset of a tree, and it
drops symlinks on install, which rules out the obvious workaround.

Revisit when Codex supports an array or include-list, or preserves symlinks.

## What targeting Claude only lets us omit

Repos that target both harnesses carry an `agents/openai.yaml` beside every
`SKILL.md`. It holds Codex UI metadata and, for user-invoked skills, the policy
flag that stops the model reaching them:

```yaml
interface:
  display_name: "Writing Great Skills"
  short_description: "Principles for predictable skills"
policy:
  allow_implicit_invocation: false
```

Four lines. Measured across the reference repo: 41 files, 171 lines, averaging
4.2 lines each. Cheap to write — and still omitted.

The cost is not bytes, it is a **second source of truth for one fact**. A skill's
invocation mode would live in two files that must agree:
`disable-model-invocation` in `SKILL.md` frontmatter, and
`allow_implicit_invocation` in the YAML. Repos carrying both need an explicit
rule to keep them in sync, and nothing enforces it — a skill silently
user-invoked in one harness and model-invoked in the other is a drift no test
catches. Carrying that risk for a harness we do not use buys nothing.

`SKILL.md` frontmatter is the single source of truth for invocation.

When Codex becomes a target, the files are added **deliberately**, with the sync
rule stated and every skill audited in one pass — rather than having been
carried, unmaintained and unverified, from a day when nothing read them.

## Invariants this creates

- A skill **ships if and only if** it is listed in `.claude-plugin/plugin.json`'s
  `skills` array **and** referenced in the top-level `README.md`.
- `plugin.json`'s `version` is what Claude uses to decide when installed users
  see an update. Bump it deliberately.

## House rule for ADRs

Every ADR carries a `Status:` line — `Accepted`, or `Superseded by NNNN`.

ADRs are **immutable once accepted**. A decision that stops applying is not
edited or deleted: a new ADR supersedes it, and the old one gains a
`Superseded by` status. The record is why a choice was made given what was known
then — the current state lives in the code, not here.

Where a decision has a foreseeable expiry, name the condition that would
trigger revisiting it, rather than writing "we'll revisit later".
