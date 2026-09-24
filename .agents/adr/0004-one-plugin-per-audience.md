# 0004: One plugin per audience, from one marketplace

**Status:** Accepted

## Context

[0001](./0001-ship-as-a-claude-code-plugin.md) made this repo a single-plugin
marketplace. That fit while every skill served one person.

`writing-pull-requests` and `drafting-release-notes` serve a different
audience: anyone contributing to a repository that declares them. A repository
enables a plugin for all its collaborators, in its `.claude/settings.json`, so
declaring the single plugin would hand every collaborator the weekly cycle
skills too, and their descriptions cost context in every session.

[0002](./0002-flat-skills-directory.md) named this as a trigger: two clearly
different audiences.

## Decision

The marketplace ships **one plugin per audience**, all from this repository:

- `luisburgos-skills`: personal workflow and skill authoring.
- `contributing`: how a contribution to a repository is written up, starting
  with `writing-pull-requests` and `drafting-release-notes`.

A new plugin takes no `luisburgos-` prefix: the marketplace already carries the
name, so `contributing@luisburgos` reads whole. `luisburgos-skills` keeps its
name, since renaming an installed plugin makes every user reinstall it.

A new plugin is created when a group of skills has an audience of its own and
is already used in more than one repository. The skills that derive and audit
UI blueprints are the next foreseen: they stay where they are developed until a
second repository uses them.

Where each plugin's skills sit on disk is a separate decision.

## How

Each plugin is an entry in `.claude-plugin/marketplace.json` with
`"source": "./"`, `"strict": false`, its own `skills` and its own
`version`. There is no `plugin.json`: with one at the root, even one listing no
skills, the entries fail to load with conflicting manifests.

Checked before deciding, in an isolated configuration:
`claude plugin validate . --strict` passes, each plugin loads only its own
skills, and an installed `luisburgos-skills` 0.5.0 updates to the new layout.

## What stands from 0001

Claude only, what ships chosen deliberately so that a draft does not,
`SKILL.md` frontmatter as the single source of truth for invocation, and
`scripts/link-skills.sh` for local development.

## Consequences

- A skill ships if and only if its plugin's entry in `marketplace.json`
  includes it and the README references it.
- Each entry's `version` is what installed users are updated to. A plugin's
  version moves only when its own skills change.
- `drafting-release-notes` leaves `luisburgos-skills`. Whoever used it from
  there installs `contributing` to keep it.

## Revisit when

A plugin needs a visibility or a release pace of its own. Then it moves to a
repository of its own, as a second marketplace.
